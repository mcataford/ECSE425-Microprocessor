library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MULTIPLIERCELL is

port (
	A,B: in std_logic_vector(31 downto 0);
	OUTPUT: out std_logic_vector(63 downto 0)
);

end entity;

architecture MULTIPLIERCELL_Impl of MULTIPLIERCELL is

begin

OUTPUT <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) * to_integer(unsigned(B)),64));

end architecture;