library IEEE;

use ieee.std_logic_1164.all;

entity ALU is

--TODO: determine ALU_CONTROL width.
--ALU_CONTROL width: 3 bits

port(
	CLOCK: in std_logic;
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(5 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	ZERO, OVERFLOW: out std_logic
);

end entity;

architecture ALU_impl of ALU is

--Intermediate signals, WFA interactions.
signal WFA_A, WFA_B, WFA_S: std_logic_vector(31 downto 0) := (others => '0');
signal WFA_Cout: std_logic := '0';

--Intermediate signals, LC interactions
signal LC_A, LC_B, LC_OUTPUT: std_logic_vector(31 downto 0) := (others => '0');
signal LC_MODE: std_logic_vector(1 downto 0) := "00";

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
WFA: WORDFULLADDER port map(WFA_A,WFA_B,WFA_Cout,WFA_S);

--Word-width multiplier component instance.

--Logic cell component instance
LC: LOGICCELL port map(LC_A, LC_B, LC_MODE, LC_OUTPUT);

process(CLOCK)

begin 

--Synchronized block
if rising_edge(CLOCK) then

end if;

end process;

end architecture;