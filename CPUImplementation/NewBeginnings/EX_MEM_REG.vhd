library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--Results
		EX_R: in std_logic_vector(63 downto 0);
		--Operand B forwarding
		EX_B_FW: in std_logic_vector(31 downto 0);
		--Instruction
		EX_INSTR: in std_logic_vector(31 downto 0);
		--Control signals
		EX_CONTROL_VECTOR: in std_logic_vector(7 downto 0);
		
		--OUTPUT
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

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if rising_edge(CLOCK) then
		
			MEM_R <= EX_R;
			MEM_B_FW <= EX_B_FW;
			MEM_INSTR <= EX_INSTR;
			MEM_CONTROL_VECTOR <= EX_CONTROL_VECTOR;
		
		end if;
	
	end process;

end architecture;