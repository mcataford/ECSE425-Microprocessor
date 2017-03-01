library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WORDFULLADDER_tb is
end entity;

architecture WORDFULLADDER_tst of WORDFULLADDER_tb is

signal A,B,S: std_logic_vector(31 downto 0);
signal Cout: std_logic;

component WORDFULLADDER

port(
	A,B: in std_logic_vector(31 downto 0);
	Cout: out std_logic;
	S: out std_logic_vector(31 downto 0)
);

end component;

begin

WFA: WORDFULLADDER port map(A,B,Cout,S);

process

begin

A <= std_logic_vector(to_unsigned(50,32));

B <= std_logic_vector(to_unsigned(50,32));

wait for 1 ns;

for i in 0 to INTEGER'HIGH loop

	A <= std_logic_vector(to_unsigned(i,32));

	for j in 0 to INTEGER'HIGH loop

	B <= std_logic_vector(to_unsigned(j,32));

	wait for 1 ns;

	end loop;

end loop;

end process;

end architecture;