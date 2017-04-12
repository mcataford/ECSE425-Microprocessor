library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_tb is
end entity;

architecture CPU_tst of CPU_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal CLOCK, RESET: std_logic;
	SIGNAL ENABLE_TEST : std_logic;

	component CPU
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			RESET: in std_logic;
			ENABLE_TEST : in std_logic
		);
	
	end component;

begin

	GLOBAL: CPU port map(CLOCK,RESET,ENABLE_TEST);
	
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
		ENABLE_TEST <= '1';

		wait for 10 ns;

		ENABLE_TEST <= '0';

		wait for 10 ns;		

		ENABLE_TEST <= '1';
				
		wait;
	
	end process;

end architecture;