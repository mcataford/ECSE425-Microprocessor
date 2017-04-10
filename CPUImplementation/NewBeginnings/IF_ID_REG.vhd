-- ECSE425 CPU Pipeline mark II
--
-- IF-ID interstage register
--
-- Author: Marc Cataford
-- Last modified: 7/4/2017

library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--Reset
		RESET: in std_logic;
		--Program counter
		IF_PC: in std_logic_vector(31 downto 0);
		--Instruction
		IF_INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Program counter
		ID_PC: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Instruction
		ID_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z')
	);

end entity;

architecture IF_ID_REG_Impl of IF_ID_REG is

	signal REG_PC, REG_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
			if rising_edge(CLOCK) then
			
				REG_PC <= IF_PC;
				REG_INSTR <= IF_INSTR;
			
			elsif falling_edge(CLOCK) then
			
				ID_PC <= REG_PC;
				ID_INSTR <= REG_INSTR;
			
			end if;

	end process;

end architecture;