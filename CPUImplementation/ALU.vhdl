library IEEE;

use ieee.std_logic_1164.all;

entity ALU is

port(
	--Clock signal
	CLOCK: in std_logic;
	--Inputs
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(2 downto 0);
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
WFA: WORDFULLADDER port map(A,B,WFA_Cout,WFA_S);

--Word-width multiplier component instance.

--Logic cell component instance
LC: LOGICCELL port map(LC_A, LC_B, LC_MODE, LC_OUTPUT);

process(CLOCK)

begin 

--Synchronized block
if rising_edge(CLOCK) then

case ALU_CONTROL is

--Adder: ADD, ADDI, SUB
when "000" =>
	OUTPUT <= WFA_S;

--Logic cell: AND, ANDI
when "001" =>
	LC_MODE <= "00";
	OUTPUT <= LC_OUTPUT;

--Logic cell: OR, ORI
when "010" =>
	LC_MODE <= "01";
	OUTPUT <= LC_OUTPUT;

--Logic cell: XOR, XORI
when "011" =>
	LC_MODE <= "10";
	OUTPUT <= LC_OUTPUT;

--Logic cell: NOR
when "100" =>
	LC_MODE <= "11";
	OUTPUT <= LC_OUTPUT;
	
when others =>
	OUTPUT <= (others => 'Z');

end case;

end if;

end process;

end architecture;