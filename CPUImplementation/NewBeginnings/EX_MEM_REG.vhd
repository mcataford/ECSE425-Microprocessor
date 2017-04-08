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

	REG_BEHAVIOUR: process(EX_PC)
	
		variable REG_R: std_logic_vector(63 downto 0) := (others => 'Z');
		variable REG_B,REG_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
		variable REG_CONTROL_VECTOR: std_logic_vector(7 downto 0) := (others => 'Z');
	
	begin
	
			MEM_R <= REG_R;
			MEM_B_FW <= REG_B;
			MEM_INSTR <= REG_INSTR;
			MEM_CONTROL_VECTOR <= REG_CONTROL_VECTOR;
			
			REG_R := EX_R;
			REG_B := EX_B_FW;
			REG_INSTR := EX_INSTR;
			REG_CONTROL_VECTOR := EX_CONTROL_VECTOR;
	
	end process;

end architecture;