library IEEE;

use ieee.std_logic_1164.all;

entity MUX_5BIT is

port(
	A,B: in std_logic_vector(4 downto 0);
	SELECTOR: in std_logic;
	OUTPUT: out std_logic_vector(4 downto 0)
);

end entity;

architecture MUX_IMPL of MUX_5BIT is

begin

OUTPUT <= A when SELECTOR = '0' else
	B when SELECTOR = '1' else
	(others => 'Z');

end architecture;