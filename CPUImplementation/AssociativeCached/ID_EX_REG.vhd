library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		ENABLE: in std_logic;
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
		ID_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
		
		--OUTPUT
		EX_PC: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Instruction
		EX_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Register values
		EX_REG_A: out std_logic_vector(31 downto 0) := (others => 'Z');
		EX_REG_B: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Immediate
		EX_IMMEDIATE: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Control signals
		EX_CONTROL_VECTOR: out std_logic_vector(11 downto 0) := (others => 'Z')
	);

end entity;

architecture ID_EX_REG_Impl of ID_EX_REG is

	

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if RESET = '1' then
			
			EX_PC <= (others => 'Z');
			EX_INSTR <= (others => 'Z');
			EX_REG_A <= (others => 'Z');
			EX_REG_B <= (others => 'Z');
			EX_IMMEDIATE <= (others => 'Z');
			EX_CONTROL_VECTOR <= (others => 'Z');
		
		
		elsif rising_edge(CLOCK) and ENABLE = '1' then
		
			EX_PC <= ID_PC;
			EX_INSTR <= ID_INSTR;
			EX_REG_A <= ID_REG_A;
			EX_REG_B <= ID_REG_B;
			EX_IMMEDIATE <= ID_IMMEDIATE;
			EX_CONTROL_VECTOR <= ID_CONTROL_VECTOR;
		
		end if;
	
	end process;

end architecture;