library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE_tb is
end entity;

architecture EX_STAGE_tst of EX_STAGE_tb is

--Intermediate signals--

signal A,B,IMM,INSTR_IN,PC_IN,R,B_OUT,INSTR_OUT: std_logic_vector(31 downto 0);
signal R_64: std_logic_vector(63 downto 0);
signal BRANCH: std_logic;
signal ALU_CONTROL: std_logic_vector(3 downto 0);
signal SELECTOR1, SELECTOR2: std_logic;

component EX_STAGE

	port(
	
		A,B,IMM,INSTR_IN,PC_IN: in std_logic_vector(31 downto 0);
		SELECTOR1, SELECTOR2: in std_logic;
		ALU_CONTROL: in std_logic_vector(3 downto 0);
		BRANCH: out std_logic;
		R,B_OUT,INSTR_OUT: out std_logic_vector(31 downto 0);
		R_64: out std_logic_vector(63 downto 0)
	
	);

end component;

begin

EX_ST : EX_STAGE port map(
	--INPUT--
	--Operands--
	A,B,
	--Immediate--
	IMM,
	--Instruction in--
	INSTR_IN,
	--PC in--
	PC_IN,
	--Multiplexer selectors
	SELECTOR1,
	SELECTOR2,
	--ALU control ALUOP
	ALU_CONTROL,
	--OUTPUT--
	--Branch selection--
	BRANCH,
	--ALU 32b out--
	R,
	--Operand B forward--
	B_OUT,
	--Instruction forward--
	INSTR_OUT,
	--ALU 64b out--
	R_64
);

process

begin 

A <= std_logic_vector(to_unsigned(61,32));
B <= std_logic_vector(to_unsigned(60,32));

SELECTOR1 <= '0';
SELECTOR2 <= '0';

IMM <= (others => '0');
INSTR_IN <= (others => '0');
PC_IN <= (others => '0');

for i in 0 to 6 loop

	ALU_CONTROL <= std_logic_vector(to_unsigned(i,4));
	wait for 1 ns;

end loop;

wait;

end process;

end architecture;