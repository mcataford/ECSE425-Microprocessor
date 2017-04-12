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
		--Enable
		ENABLE : in std_logic;
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

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
			if RESET = '1' then
				ID_PC <= (others => 'Z');
				ID_INSTR <= (others => 'Z');
				
			elsif rising_edge(CLOCK) AND ENABLE = '1' then
			
				ID_PC <= IF_PC;
				ID_INSTR <= IF_INSTR;
			
			end if;

	end process;

end architecture;