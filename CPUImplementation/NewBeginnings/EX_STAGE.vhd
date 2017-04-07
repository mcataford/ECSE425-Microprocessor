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
		CONTROL_VECTOR: in std_logic_vector(7 downto 0);
		--Instruction
		INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Results
		R1: out integer := 0;
		R2: out integer := 0
	);
	
end entity;

architecture EX_STAGE_Impl of EX_STAGE is

	signal OPERAND_A, OPERAND_B: integer := 0;

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
	
	--ALU input multiplexers
	--(1): ALUSrc
	--(8): PCSrc
	--See ID_CONTROL_UNIT.vhd for details
	
	OPERAND_A <= A when CONTROL_VECTOR(7) = '0' else
						PC;
	OPERAND_B <= B when CONTROL_VECTOR(1) = '0' else
						Imm;

end architecture;