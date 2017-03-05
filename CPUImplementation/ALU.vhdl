library IEEE;

use ieee.std_logic_1164.all;

entity ALU is

port(
	--Inputs
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(2 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	ZERO, OVERFLOW: out std_logic
);

end entity;

architecture ALU_impl of ALU is

--Intermediate signals, WFA interactions.
signal WFA_S: std_logic_vector(31 downto 0) := (others => '0');
signal WFA_Cout: std_logic := '0';

--Intermediate signals, LC interactions
signal LC_OUTPUT: std_logic_vector(31 downto 0) := (others => '0');
signal LC_MODE: std_logic_vector(1 downto 0) := "00";


signal STATUS_FLAGS: std_logic_vector(1 downto 0) := (others => '0');

component WORDFULLADDER

port(
	A,B: in std_logic_vector(31 downto 0);
	Cout: out std_logic;
	S: out std_logic_vector(31 downto 0)
);

end component;

component LOGICCELL

port(
	A,B: in std_logic_vector(31 downto 0);
	MODE: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0)
);

end component;

begin

--Word-width full adder component instance.
WFA: WORDFULLADDER port map(A,B,WFA_Cout,WFA_S);

--Word-width multiplier component instance.

--Logic cell component instance
LC: LOGICCELL port map(A, B, LC_MODE, LC_OUTPUT);

LC_MODE <= "00" when ALU_CONTROL = "001" else
	"01" when ALU_CONTROL = "010" else
	"10" when ALU_CONTROL = "011" else
	"11" when ALU_CONTROL = "100" else
	"00";

OUTPUT <= WFA_S when ALU_CONTROL = "000" else
	LC_OUTPUT when ALU_CONTROL = "001" or ALU_CONTROL = "010" or ALU_CONTROL = "011" or ALU_CONTROL = "100" else
	(others => 'Z');  

OVERFLOW <= STATUS_FLAGS(0);
ZERO <= STATUS_FLAGS(1);

end architecture;