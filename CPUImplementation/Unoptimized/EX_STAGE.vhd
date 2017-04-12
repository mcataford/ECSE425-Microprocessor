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
		R: out std_logic_vector(63 downto 0) := (others => 'Z');
		BRANCH: out std_logic
	);
	
end entity;

architecture EX_STAGE_Impl of EX_STAGE is

	signal OPERAND_A, OPERAND_B: std_logic_vector(31 downto 0);
	signal ALU_OUT: std_logic_vector(63 downto 0);

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
		ALU_OUT
	);
	
	--Choosing the upper operand:
	--Can be the register file's output or the PC.
	OPERAND_A <= A when CONTROL_VECTOR(7) = '0' else 
	
	x"00000000" when INSTR(31 downto 26) = "000010" or INSTR(31 downto 26) = "000011" or INSTR(31 downto 26) = "000100" else
	
	PC;
	
	--THe second operand is either a register value or the immediate.
	OPERAND_B <= B when CONTROL_VECTOR(1) = '0' else Imm;
	
	--The result can be the normal ALU out, the offset+PC for relative jumps or A if we are using branches.
	R <= x"00000000" & instr(15 downto 0) & x"0000" when INSTR(31 downto 26) = "001111" else
		
		x"00000000" & std_logic_vector(signed(PC) + signed(Imm) + to_signed(1,32)) when (INSTR(31 downto 26) = "000100" or INSTR(31 downto 26) = "000101") else
		
		x"00000000" & A when INSTR(5 downto 0) = "001000" else
		
		ALU_OUT;
		
	--Branch signal
	BRANCH <= '1' when A = B else
		'0';
	
end architecture;