library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is

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
	
end entity;

architecture ALU_Impl of ALU is

begin

	ALU_BEHAVIOUR: process(A,B)

		variable uOP,uFU: unsigned(5 downto 0);
		variable SHAMT: integer;
		
		variable uA, uB, uR: unsigned(31 downto 0);
		
		variable DWBUFFER: unsigned(63 downto 0);
	
	begin
	
		uOP := unsigned(INSTR(31 downto 26));
		uFU := unsigned(INSTR(5 downto 0));
		SHAMT := to_integer(unsigned(INSTR(10 downto 6)));
		
		uA := to_unsigned(A,32);
		uB := to_unsigned(B, 32);
		
		--ADD, ADDI
		if uOP = 8 or uFU = 32 then
			R1 <= A + B;
			R2 <= 0;
		
		--SUB
		elsif uFU = 34 then
			R1 <= A - B;
			R2 <= 0;
		
		--MULT
		elsif uFU = 24 then
			DWBUFFER := to_unsigned(A * B,64);
			R1 <= to_integer(DWBUFFER(63 downto 32));
			R2 <= to_integer(DWBUFFER(31 downto 0));
			
		--DIV
		elsif uFU = 26 and not(B = 0) then
			R1 <= A / B;
			R2 <= A mod B;
			
		--AND, ANDI
		elsif uFU = 36 or uOP = 12 then
			R1 <= to_integer(uA and uB);
			R2 <= 0;
			
		--OR, ORI
		elsif uFU = 37 or uOP = 13 then
			R1 <= to_integer(uA or uB);
			R2 <= 0;
			
		--XOR, XORI
		elsif uFU = 38 or uOP = 14 then
			R1 <= to_integer(uA xor uB);
			R2 <= 0;
			
		--NOR
		elsif uFU = 39 then
			R1 <= to_integer(uA nor uB);
			R2 <= 0;
			
		--SLT, SLTI
		elsif uFU = 42 or uOP = 10 then
			if A < B then
				R1 <= 1;
			else
				R1 <= 0;
			end if;
		
		--SLL
		elsif uFU = 0 and uOP = 0 then
			R1 <= to_integer(uA sll SHAMT);
			R2 <= 0;
			
		--SRL
		elsif uFU = 2 then
			R1 <= to_integer(uA srl SHAMT);
			R2 <= 0;
			
		--SRA
		elsif uFU = 3 then
			uR := uA srl SHAMT;
			R2 <= 0;
			
			for offset in 0 to SHAMT-1 loop
				uR(31-offset) := uA(31);			
			end loop;

			R1 <= to_integer(uR);
		
		end if;
	
	end process;
	
end architecture;