library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REG_tb is
end entity;

architecture EX_MEM_REG_tst of EX_MEM_REG_tb is

signal CLOCK, BRANCH_IN,BRANCH_OUT: std_logic := '0';
signal R_IN,B_FORWARD_IN,INSTR_IN,R_OUT,B_FORWARD_OUT,INSTR_OUT: std_logic_vector(31 downto 0) := (others => '0');
signal R_64_IN,R_64_OUT: std_logic_vector(63 downto 0) := (others => '0');

constant CLK_PERIOD: time := 1 ns;

component EX_MEM_REGISTER

	port(
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Branch selection--
		BRANCH_IN: in std_logic;
		--ALU 32b out--
		R_IN,
		--Operand B forward--
		B_FORWARD_IN,
		--Instruction forward--
		INSTR_IN: in std_logic_vector(31 downto 0);
		--ALU 64b out--
		R_64_IN: in std_logic_vector(63 downto 0) := (others => '0');
		--OUTPUT--
		--Branch selection--
		BRANCH_OUT: out std_logic := '0';
		--ALU 32b out--
		R_OUT,
		--Operand B forward--
		B_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT: out std_logic_vector(31 downto 0);
		--Alu 64b out--
		R_64_OUT: out std_logic_vector(63 downto 0) := (others => '0')
		
	);

end component;

begin

EX_MEM_REG : EX_MEM_REGISTER port map(
	CLOCK,
	BRANCH_IN,
	R_IN,
	B_FORWARD_IN,
	INSTR_IN,
	R_64_IN,
	BRANCH_OUT,
	R_OUT,
	B_FORWARD_OUT,
	INSTR_OUT,
	R_64_OUT
);

process

begin

CLOCK <= '0';
wait for 0.5 * CLK_PERIOD;
CLOCK <= '1';
wait for 0.5 * CLK_PERIOD;

end process;

process

begin

wait for 0.5 * CLK_PERIOD;

BRANCH_IN <= '1';
R_IN <= std_logic_vector(to_unsigned(50,32));
B_FORWARD_IN <= std_logic_vector(to_unsigned(50,32));
INSTR_IN <= std_logic_vector(to_unsigned(60,32));
R_64_IN <= std_logic_vector(to_unsigned(120,64));

wait for 1 * CLK_PERIOD;

assert BRANCH_IN = BRANCH_OUT and R_IN = R_OUT and B_FORWARD_IN = B_FORWARD_OUT and INSTR_IN = INSTR_OUT and R_64_IN = R_64_OUT report "Failed to propagate.";

wait;

end process;

end architecture;
