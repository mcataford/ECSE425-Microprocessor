library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_tb is
end entity;

architecture MUX_tst of MUX_tb is

signal A,B,OUTPUT: std_logic_vector(31 downto 0);
signal SELECTOR: std_logic;

component MUX

port(
	A,B: in std_logic_vector(31 downto 0);
	SELECTOR: in std_logic;
	OUTPUT: out std_logic_vector(31 downto 0)
);

end component;

begin

M: MUX port map(A,B,SELECTOR,OUTPUT);

process

begin

A <= std_logic_vector(to_unsigned(50,32));
B <= std_logic_vector(to_unsigned(99,32));

SELECTOR <= '0';

wait for 5 ns;

assert OUTPUT = A report "SELECTOR = 0, failed to assert OUTPUT = A.";

SELECTOR <= '1';

wait for 5 ns;

assert OUTPUT = B report "SELECTOR = 1, failed to assert OUTPUT = B.";

wait;

end process;

end architecture;