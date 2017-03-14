library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIERCELL_tb is
end entity;

architecture MULTIPLIERCELL_tst of MULTIPLIERCELL_tb is

signal A,B,OUTPUT: std_logic_vector(31 downto 0);

component MULTIPLIERCELL

port(
	A,B: in std_logic_vector(31 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0)
);

end component;

begin

MC: MULTIPLIERCELL port map(A,B,OUTPUT);

process

begin

for i in 0 to 50 loop
	A <= std_logic_vector(to_unsigned(i,32));
	for j in 0 to 50 loop
		B <= std_logic_vector(to_unsigned(j,32));

		wait for 1 ns;

		assert i * j = to_integer(unsigned(OUTPUT)) report "Assertion failed.";
		
	end loop;

end loop;

wait;

end process;

end architecture;