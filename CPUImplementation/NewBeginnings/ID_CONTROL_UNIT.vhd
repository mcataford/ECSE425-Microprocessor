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
		"000000001011" when OPCODE = "001000" else --addi
		"000000001001" when FUNCT = "100000" else --add
		"000100001001" when FUNCT = "100010" else --sub
		--MULT
		--DIV
		"010000001001" when FUNCT = "100100" else --and
		"010000001011" when OPCODE = "001100" else --andi
		"010100001001" when FUNCT = "100101" else --or
		"010100001011" when OPCODE = "001101" else --ori
		"011000001001" when FUNCT = "101000" else --xor
		"011000001011" when OPCODE = "001110" else --xori
		"011100001001" when FUNCT = "100111" else --nor
		
		
		(others => '0');
	
end architecture;