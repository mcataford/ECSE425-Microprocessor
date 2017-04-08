library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--Reset
		RESET: in std_logic;
		--Program counter
		ID_PC: in std_logic_vector(31 downto 0);
		--Instruction
		ID_INSTR: in std_logic_vector(31 downto 0);
		--Register values
		ID_REG_A: in std_logic_vector(31 downto 0);
		ID_REG_B: in std_logic_vector(31 downto 0);
		--Immediate
		ID_IMMEDIATE: in std_logic_vector(31 downto 0);
		--Control signals
		ID_CONTROL_VECTOR: in std_logic_vector(7 downto 0);
		
		--OUTPUT
		EX_PC: out std_logic_vector(31 downto 0);
		--Instruction
		EX_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Register values
		EX_REG_A: out std_logic_vector(31 downto 0);
		EX_REG_B: out std_logic_vector(31 downto 0);
		--Immediate
		EX_IMMEDIATE: out std_logic_vector(31 downto 0);
		--Control signals
		EX_CONTROL_VECTOR: out std_logic_vector(7 downto 0) := (others => 'Z')
	);

end entity;

architecture ID_EX_REG_Impl of ID_EX_REG is

begin

	REG_BEHAVIOUR: process(ID_REG_A)
	
		variable REG_PC, REG_REG_B, REG_IMM: std_logic_vector(31 downto 0):= (others => 'Z');
		variable REG_REG_A: std_logic_vector(31 downto 0) := (others => 'Z');
		variable REG_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
		variable REG_CONTROL_VECTOR: std_logic_vector(7 downto 0) := (others => 'Z');
	
	begin
		
			EX_PC <= REG_PC;
			EX_INSTR <= REG_INSTR;
			EX_REG_A <= REG_REG_A;
			EX_REG_B <= REG_REG_B;
			EX_IMMEDIATE <= REG_IMM;
			EX_CONTROL_VECTOR <= REG_CONTROL_VECTOR;
			
			REG_PC := ID_PC;
			REG_INSTR := ID_INSTR;
			REG_REG_A := ID_REG_A;
			REG_REG_B := ID_REG_B;
			REG_IMM := ID_IMMEDIATE;
			REG_CONTROL_VECTOR := ID_CONTROL_VECTOR;
			

	
	end process;

end architecture;