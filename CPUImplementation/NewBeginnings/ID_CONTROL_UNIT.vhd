library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_CONTROL_UNIT is
	
	port (
		--INPUT
		--Opcode segment
		OPCODE: in std_logic_vector(5 downto 0);
		--Funct segment
		FUNCT: in std_logic_vector(5 downto 0);
		
		--OUTPUT
		--Control signals
		CONTROL_VECTOR: out std_logic_vector(11 downto 0)
	);
	
end entity;

architecture ID_CONTROL_UNIT_Impl of ID_CONTROL_UNIT is

	--Map of control signals:
	--0: RegDst
	--1: AluSrc
	--2: MemToReg
	--3: RegWrite
	--4: MemRead
	--5: MemWrite
	--6: Branch
	--7: PCSrc
	--8-11: ALUop

begin

	CONTROL_VECTOR <= 
		--I-Types
		"000000001011" when OPCODE = "001000" else --addi
		"010000001011" when OPCODE = "001100" else --andi
		"010100001011" when OPCODE = "001101" else --ori
		"011000001011" when OPCODE = "001110" else --xori
		"100000001011" when OPCODE = "001010" else --slti
		"000000001011" when OPCODE = "001111" else --lui
		"000000101111" when OPCODE = "101011" else --sw
		"000000011111" when OPCODE = "100011" else --lw
		
		--J-types
	  "000011000011" when OPCODE = "000010" else --j
		
		--R-Types
		"000000001001" when FUNCT = "100000" else --add
		"000100001001" when FUNCT = "100010" else --sub
		"001000001001" when FUNCT = "011000" else --mult
		"001100001001" when FUNCT = "011010" else --div
		"010000001001" when FUNCT = "100100" else --and
		"010100001001" when FUNCT = "100101" else --or
		"011000001001" when FUNCT = "101000" else --xor
		"011100001001" when FUNCT = "100111" else --nor
		"100000001001" when FUNCT = "101010" else --slt
		"101000001001" when FUNCT = "000010" else --srl
		"101100001001" when FUNCT = "000011" else --sra
		"100100001001" when FUNCT = "000000" else --sll
		"000000001000" when FUNCT = "010000" else --mfhi
		"000000001000" when FUNCT = "010010" else --mflo
		
		
		(others => '0');
	
end architecture;