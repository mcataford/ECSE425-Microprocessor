library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE is
	port (
		--INPUT
		--Program counter
		PC: in integer range 0 to 1023;
		--Operands
		A: in integer;
		B: in integer;
		Imm: in integer;
		--Control signals
		CONTROL_VECTOR: in std_logic_vector(8 downto 0);
		--Instruction
		INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Results
		R1: out integer;
		R2: out integer
	);
	
end entity;

architecture EX_STAGE_Impl of EX_STAGE is

	signal OPERAND_A, OPERAND_B: integer;

	component ALU
		port(
			--INPUT
			--Operand A
			A: in integer;
			--Operand B
			B: in integer;
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Results
			R1: out integer;
			--Second result, used if width=64b
			R2: out integer
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
		
		--OUTPUT
		--Results
		R1,
		R2
	);
	
	OPERAND_A <= A when CONTROL_VECTOR(8) = '0' else
						PC;
	OPERAND_B <= B when CONTROL_VECTOR(1) = '0' else
						Imm;

end architecture;