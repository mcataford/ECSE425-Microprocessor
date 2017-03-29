library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DIVIDERCELL_tb is
end entity;

architecture DIVIDERCELL_tst of DIVIDERCELL_tb is

signal A,B,QUOTIENT,REMAINDER: std_logic_vector(31 downto 0);
signal STATUS: std_logic;

signal ERROR: std_logic_vector(31 downto 0) := (others => 'Z');

component DIVIDERCELL

port(
	A,B: in std_logic_vector(31 downto 0);
	STATUS: out std_logic;
	QUOTIENT,REMAINDER: out std_logic_vector(31 downto 0)
);

end component;

begin

DC: DIVIDERCELL port map(A,B,STATUS,QUOTIENT,REMAINDER);

process

begin

for i in 0 to 50 loop
	A <= std_logic_vector(to_unsigned(i,32));
	for j in 0 to 50 loop
		B <= std_logic_vector(to_unsigned(j,32));

		wait for 1 ns;

		if not(j = 0) then
			assert i / j = to_integer(unsigned(QUOTIENT)) report "Quotient failed.";
			assert i mod j = to_integer(unsigned(REMAINDER)) report "Remainder failed.";
		else
			assert STATUS = '1' and QUOTIENT = ERROR and REMAINDER = ERROR report "Error reporting failed.";
		end if;
		
	end loop;

end loop;

wait;

end process;

end architecture;