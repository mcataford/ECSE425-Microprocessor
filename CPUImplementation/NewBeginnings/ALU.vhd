library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is

	port(
		--INPUT
		--Operand A
		A: in std_logic_vector(31 downto 0);
		--Operand B
		B: in std_logic_vector(31 downto 0);
		--Instruction
		INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Results
		R: out std_logic_vector(63 downto 0)
	);
	
end entity;

architecture ALU_Impl of ALU is

begin

	ALU_BEHAVIOUR: process(A,B,INSTR)
	
		--Unsigned conversions and buffers.

		variable uOP,uFU: unsigned(5 downto 0);
		variable SHAMT: integer;
		
		variable uA, uB: unsigned(31 downto 0);
		variable uR: unsigned(63 downto 0);
		
		variable UNDEF: std_logic_vector(31 downto 0) := (others => 'Z');
	
	begin
	
		if not (INSTR = UNDEF) then
	
			--Populating buffers and conversions.
			
			uOP := unsigned(INSTR(31 downto 26));
			uFU := unsigned(INSTR(5 downto 0));
			uA := unsigned(A);
			uB := unsigned(B);
			SHAMT := to_integer(unsigned(INSTR(10 downto 6)));
			

			
			--Processing instruction per OPCODE & FUNCT segments.
			
			--ADD, ADDI
			if uOP = 8 or uFU = 32 then
				uR := to_unsigned(0,32) & (uA + uB);
			
			--SUB
			elsif uFU = 34 then
				uR := to_unsigned(0,32) & uA - uB;
			
			--MULT
			elsif uFU = 24 then
				uR := uA * uB;
				
			--DIV
			elsif uFU = 26 and not(uB = 0) then
				uR(63 downto 32) := uA / uB;
				uR(31 downto 0) := uA mod uB;
				
			--AND, ANDI
			elsif uFU = 36 or uOP = 12 then
				uR := to_unsigned(0,32) & (uA and uB);

				
			--OR, ORI
			elsif uFU = 37 or uOP = 13 then
				uR := to_unsigned(0,32) & (uA or uB);
				
			--XOR, XORI
			elsif uFU = 38 or uOP = 14 then
				uR := to_unsigned(0,32) & (uA xor uB);
				
			--NOR
			elsif uFU = 39 then
				uR := to_unsigned(0,32) & (uA nor uB);
				
			--SLT, SLTI
			elsif uFU = 42 or uOP = 10 then
				if A < B then
					uR := to_unsigned(1,64);
				else
					uR := to_unsigned(0,64);
				end if;
			
			--SLL
			elsif uFU = 0 and uOP = 0 then
				uR := to_unsigned(0,32) & (uA sll SHAMT);
							
			--SRL
			elsif uFU = 2 then
				uR := to_unsigned(0,32) & (uA srl SHAMT);
				
			--SRA
			elsif uFU = 3 then
				uR := to_unsigned(0,32) & (uA srl SHAMT);
				
				for offset in 0 to SHAMT-1 loop
					uR(31-offset) := uA(31);			
				end loop;
			
			end if;
			
			R <= std_logic_vector(uR);
			
		else
		
			--If the instruction is undefined, zero out the output.
		
			R <= (others => '0');
			
		end if;
		
	end process;
	
end architecture;