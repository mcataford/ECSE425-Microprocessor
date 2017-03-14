library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BYTEFULLADDER_tb is
end entity;

architecture BYTEFULLADDER_tst of BYTEFULLADDER_tb is

signal A,B,S: std_logic_vector(7 downto 0);
signal Cin,Cout: std_logic;

component BYTEFULLADDER

port(
	A,B: in std_logic_vector(7 downto 0);
	Cin: in std_logic;
	Cout: out std_logic;
	S: out std_logic_vector(7 downto 0)
);

end component;

begin

BFA: BYTEFULLADDER port map(A,B,Cin,Cout,S);

process

begin

Cin <= '0';

for i in 0 to 255 loop

	A <= std_logic_vector(to_unsigned(i,8));

	for j in 0 to 255 loop

		B <= std_logic_vector(to_unsigned(j,8));

		wait for 1 ns;

		assert to_integer(unsigned(S)) = (i + j) mod 256 report "Assertion failed at A="& integer'image(i) & " B=" & integer'image(j) & " S=" & integer'image(to_integer(unsigned(S)));
	end loop;
end loop;

wait;

end process;

end architecture;