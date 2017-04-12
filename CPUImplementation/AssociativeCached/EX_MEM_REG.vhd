library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		ENABLE: in std_logic;
		--Reset
		RESET: in std_logic;
		--PC
		EX_PC: in std_logic_vector(31 downto 0);
		--Results
		EX_R: in std_logic_vector(63 downto 0);
		--Operand B forwarding
		EX_B_FW: in std_logic_vector(31 downto 0);
		--Instruction
		EX_INSTR: in std_logic_vector(31 downto 0);
		--Control signals
		EX_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
		
		--OUTPUT
		MEM_PC: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Results
		MEM_R: out std_logic_vector(63 downto 0) := (others => 'Z');
		--Operand B forwarding
		MEM_B_FW: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Instruction
		MEM_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Control signals
		MEM_CONTROL_VECTOR: out std_logic_vector(11 downto 0) := (others => 'Z')
	);
	
end entity;

architecture EX_MEM_REG_Impl of EX_MEM_REG is

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if RESET = '1' then
		
			MEM_PC <= (others => 'Z');
			MEM_R <= (others => 'Z');
			MEM_B_FW <= (others => 'Z');
			MEM_INSTR <= (others => 'Z');
			MEM_CONTROL_VECTOR <= (others => 'Z');
	
		elsif rising_edge(CLOCK) and ENABLE = '1' then
	
			MEM_PC <= EX_PC;
			MEM_R <= EX_R;
			MEM_B_FW <= EX_B_FW;
			MEM_INSTR <= EX_INSTR;
			MEM_CONTROL_VECToR <= EX_CONTROL_VECTOR;
		
		end if;
		
	end process;

end architecture;