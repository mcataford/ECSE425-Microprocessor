library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE is
	port (
		--INPUT
		--Program counter
		PC: in std_logic_vector(31 downto 0);
		--Operands
		A: in std_logic_vector(31 downto 0);
		B: in std_logic_vector(31 downto 0);
		Imm: in std_logic_vector(31 downto 0);
		--Control signals
		CONTROL_VECTOR: in std_logic_vector(11 downto 0);
		--Instruction
		INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Results
		R: out std_logic_vector(63 downto 0) := (others => 'Z')
	);
	
end entity;

architecture EX_STAGE_Impl of EX_STAGE is

	signal OPERAND_A, OPERAND_B: std_logic_vector(31 downto 0);

	component ALU
		port(
			--INPUT
			--Operand A
			A: in std_logic_vector(31 downto 0);
			--Operand B
			B: in std_logic_vector(31 downto 0);
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			--ALUop
			ALUOP: in std_logic_vector(3 downto 0);
			
			--OUTPUT
			--Results
			R: out std_logic_vector(63 downto 0)
		);
	end component;

begin

	ARITH_UNIT: ALU port map(
		--INPUT
		--Operands
		OPERAND_A,
		OPERAND_B,
		--Instruction
		INSTR,
		CONTROL_VECTOR(11 downto 8),
		
		--OUTPUT
		--Results
		R
	);
	
	OPERAND_A <= A when CONTROL_VECTOR(7) = '0' else PC;
	OPERAND_B <= B when CONTROL_VECTOR(1) = '0' else Imm;

end architecture;