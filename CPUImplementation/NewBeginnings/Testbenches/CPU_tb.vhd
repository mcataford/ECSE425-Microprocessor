library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_tb is
end entity;

architecture CPU_tst of CPU_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal CLOCK, RESET: std_logic;

	component CPU
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			RESET: in std_logic
		);
	
	end component;

begin

	GLOBAL: CPU port map(CLOCK,RESET);
	
	CLK: process
	
	begin
	
		CLOCK <= '1';
		wait for 0.5 * CLK_PERIOD;
		CLOCK <= '0';
		wait for 0.5 * CLK_PERIOD;
		
	end process;
	
	TST: process
	
	begin
	
		--RESET <= '1';
		
		--wait for 1 * CLK_PERIOD;
		
		RESET <= '0';
		
		wait;
	
	end process;

end architecture;