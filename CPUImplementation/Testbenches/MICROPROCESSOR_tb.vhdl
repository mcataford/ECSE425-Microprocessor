library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR_tb is
end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR_tb is

signal CLOCK: std_logic;

component MICROPROCESSOR
	port(
	CLOCK: in std_logic
	);
end component;

begin

CPU : MICROPROCESSOR port map(CLOCK);

process

constant CLK_PERIOD: time := 1 ns;

begin

	CLOCK <= '1';
	wait for 0.5 * CLK_PERIOD;
	CLOCK <= '0';
	wait for 0.5 * CLK_PERIOD;

end process;

end architecture;