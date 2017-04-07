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

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if rising_edge(CLOCK) and RESET = '0' then
		
			ID_PC <= IF_PC;
			ID_INSTR <= IF_INSTR;
		
		end if;
	
	end process;

end architecture;