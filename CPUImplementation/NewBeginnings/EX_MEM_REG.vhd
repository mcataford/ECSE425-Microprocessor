library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--PC
		EX_PC: in std_logic_vector(31 downto 0);
		--Results
		EX_R: in std_logic_vector(63 downto 0);
		--Operand B forwarding
		EX_B_FW: in std_logic_vector(31 downto 0);
		--Instruction
		EX_INSTR: in std_logic_vector(31 downto 0);
		--Control signals
		EX_CONTROL_VECTOR: in std_logic_vector(7 downto 0);
		
		--OUTPUT
		MEM_PC: out std_logic_vector(31 downto 0);
		--Results
		MEM_R: out std_logic_vector(63 downto 0);
		--Operand B forwarding
		MEM_B_FW: out std_logic_vector(31 downto 0);
		--Instruction
		MEM_INSTR: out std_logic_vector(31 downto 0);
		--Control signals
		MEM_CONTROL_VECTOR: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture EX_MEM_REG_Impl of EX_MEM_REG is

begin

	REG_BEHAVIOUR: process(EX_R,EX_INSTR,EX_B_FW,EX_CONTROL_VECTOR)
	
		variable REG_R: std_logic_vector(63 downto 0) := (others => 'Z');
		variable REG_B,REG_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
		variable REG_CONTROL_VECTOR: std_logic_vector(7 downto 0) := (others => 'Z');
		
		variable CURRENT_STATE, NEXT_STATE: integer range 0 to 1 := 0;
		variable READY: std_logic_vector(3 downto 0) := (others => '0');
	
	begin
	
			CURRENT_STATE := NEXT_STATE;
	
			case CURRENT_STATE is
			
				when 0 =>
				
					if EX_R'event then
						READY(0) := '1';
						REG_R := EX_R;
					end if;
					
					if EX_B_FW'event then
						READY(1) := '1';
						REG_B := EX_B_FW;
					end if;
					
					if EX_INSTR'event then
						READY(2) := '1';
						REG_INSTR := EX_INSTR;
					
					end if;
					
					if EX_CONTROL_VECTOR'event then
						READY(3) := '1';
						REG_CONTROL_VECTOR := EX_CONTROL_VECTOR;
					end if;
					
					if READY = "1111" then
						NEXT_STATE := 1;
					end if;
				
				when 1 =>
					MEM_R <= REG_R;
					MEM_B_FW <= REG_B;
					MEM_INSTR <= REG_INSTR;
					MEM_CONTROL_VECTOR <= REG_CONTROL_VECTOR;
					
					READY := (others => '0');
					
					NEXT_STATE := 0;
					
				end case;
	

			
			
			
			
			
	
	end process;

end architecture;