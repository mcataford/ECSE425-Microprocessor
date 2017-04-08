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
		CONTROL_VECTOR: out std_logic_vector(7 downto 0)
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

begin

	CONTROL_VECTOR <= "00001011" when OPCODE = "001000" else
		(others => 'Z');
	
end architecture;