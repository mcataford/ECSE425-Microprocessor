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
		CONTROL_VECTOR: out std_logic_vector(7 downto 0);
		--ALU control signals
		ALU_CONTROL_VECTOR: out std_logic_vector(6 downto 0)
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
	--7: Branch
	--8: PCSrc

	signal CONTROL: std_logic_vector(7 downto 0);

begin

	CONTROL_UNIT_BEHAVIOUR: process(OPCODE, FUNCT)
	
		variable uOPCODE,uFUNCT: unsigned(5 downto 0);

	begin
	
		uOPCODE := unsigned(OPCODE);
		uFUNCT := unsigned(FUNCT);
	
		--R-type instruction
		if uOPCODE = 0 then
			
			--All R-types have the same footprint except JR
			if uFUNCT = 8 then
				CONTROL <= "00001011";
				
				report "CONTROL UNIT: R-type, JR.";
				
			else
				CONTROL <= "00001011";
				
				report "CONTROL UNIT: R-type, standard.";
				
			end if;
		
		--I or J type instruction
		elsif uFUNCT = 0 then
			
			--There are only 2 J types: J and JAL
			if uOPCODE = 2 or uOPCODE = 3 then
			
				CONTROL <= "00000000";
				
				report "CONTROL UNIT: J-type.";
				
			--Otherwise, I-type
			else
				
				if uOPCODE = 8 or uOPCODE = 10 or uOPCODE = 12 or uOPCODE = 13 or uOPCODE = 14 then
				
					report "CONTROL UNIT: Arithmetic or logical I-type.";
				
				elsif uOPCODE = 4 or uOPCODE = 5 then
				
					report "CONTROL UNIT: Branching I-type.";
				
				elsif uOPCODE = 35 then
					
					report "CONTROL UNIT: LW.";
				
				elsif uOPCODE = 43 then
				
					report "CONTROL UNIT: SW.";
					
				else
				
					report "CONTROL UNIT: invalid J/I-type instruction.";
				
				end if;
			
			end if;
			
		
		else
		
			report "CONTROL UNIT: Error, both OPCODE and FUNCT asserted.";
		
		end if;
	
	end process;

end architecture;