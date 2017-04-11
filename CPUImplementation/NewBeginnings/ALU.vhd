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
		--ALUop
		ALUOP: in std_logic_vector(3 downto 0);
		
		--OUTPUT
		--Results
		R: out std_logic_vector(63 downto 0) := (others => 'Z')
	);
	
end entity;

architecture ALU_Impl of ALU is

begin

	ALU_BEHAVIOUR: process(A,B,INSTR,ALUOP)
	
	begin
	
		if INSTR /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" then
			
			case ALUOP is
			
				when x"0" =>
					R <= x"00000000" & std_logic_vector(to_signed(to_integer(signed(A)) + to_integer(signed(B)),32));
				
				when x"1" =>
					R <= x"00000000" & std_logic_vector(to_signed(to_integer(signed(A)) - to_integer(signed(B)),32));
					
				when x"2" =>
					R <= std_logic_vector(to_signed(to_integer(signed(A)) * to_integer(signed(B)),64));
					
				when x"3" =>
					R(63 downto 32) <= std_logic_vector(to_signed(to_integer(signed(A)) / to_integer(signed(B)),32));
					R(31 downto 0) <= std_logic_vector(to_signed(to_integer(signed(A)) mod to_integer(signed(B)),32));
				
				when x"4" => 
					R <= x"00000000" & (A and B);
					
				when x"5" =>
					R <= x"00000000" & (A or B);
					
				when x"6" =>
					R <= x"00000000" & (A xor B);
					
				when x"7" =>
					R <= x"00000000" & (A nor B);
					
				when x"8" =>
					if(to_integer(signed(A)) < to_integer(signed(B))) then
						R(0) <= '1';
						R(63 downto 1) <= (others => '0');
					else
						R <= (others => '0');
					end if;
					
				when x"9" =>
					R <= x"00000000" & std_logic_vector((unsigned(A) sll to_integer(signed(INSTR(10 downto 6)))));
			
				when x"A" =>
					R <= x"00000000" & std_logic_vector((unsigned(A) srl to_integer(signed(INSTR(10 downto 6)))));
					
					
				when others =>
					R <= (others => 'Z');
		
			end case;
		
		end if;
		
	end process;
	
end architecture;