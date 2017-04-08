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
		IF_PC: in integer range 0 to 1023;
		--Instruction
		IF_INSTR: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--Program counter
		ID_PC: out integer range 0 to 1023 := 0;
		--Instruction
		ID_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z')
	);

end entity;

architecture IF_ID_REG_Impl of IF_ID_REG is

begin

	REG_BEHAVIOUR: process(IF_PC)
	
		variable REG_PC: integer := 0;
		variable REG_INSTR: std_logic_vector(31 downto 0) := (others => '0');
	
	begin
	
			ID_PC <= REG_PC;
			ID_INSTR <= REG_INSTR;
			
			REG_PC := IF_PC;
			REG_INSTR := IF_INSTR;

	end process;

end architecture;