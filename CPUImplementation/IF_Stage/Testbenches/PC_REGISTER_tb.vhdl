library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_REGISTER_tb is
end entity;

architecture PC_REGISTER_tst of PC_REGISTER_tb is

signal CLOCK, RESET, REG_WRITE: std_logic;
signal DATA_IN,DATA_OUT: std_logic_vector(31 downto 0);

constant CLK_PERIOD: time := 1 ns;

component PC_REGISTER

port(
	CLOCK,RESET,REG_WRITE: in std_logic;
	DATA_IN: in std_logic_vector(31 downto 0);
	DATA_OUT: out std_logic_vector(31 downto 0)
);

end component;

begin

REG : PC_REGISTER port map(CLOCK,RESET,REG_WRITE,DATA_IN,DATA_OUT);

process

begin

CLOCK <= '0';
wait for 0.5 * CLK_PERIOD;
CLOCK <= '1';
wait for 0.5 * CLK_PERIOD;

end process;

process

begin

RESET <= '0';
REG_WRITE <= '0';
DATA_IN <= std_logic_vector(to_unsigned(312387,32));

wait for 1 * CLK_PERIOD;

assert DATA_OUT = std_logic_vector(to_unsigned(0,32)) report "REG_WRITE gate failed to block.";

REG_WRITE <=  '1';

wait for 1 * CLK_PERIOD;

assert DATA_OUT = DATA_IN report "REG_WRITE gate failed to allow.";

RESET <= '1';
REG_WRITE <= '0';

wait for 1 * CLK_PERIOD;

RESET <= '0';

assert DATA_OUT <= std_logic_vector(to_unsigned(0,32)) report "RESET failed.";

wait;

end process;

end architecture;