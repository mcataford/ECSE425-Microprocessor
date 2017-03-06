library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DIVIDERCELL is

port (
	A,B: in std_logic_vector(31 downto 0);
	--TODO: Check if we need to implement MFHI/MFLO
	STATUS: out std_logic;
	REMAINDER,QUOTIENT: out std_logic_vector(31 downto 0)
	
);

end entity;

architecture DIVIDERCELL_Impl of DIVIDERCELL is

begin
STATUS <= '0' when not(to_integer(unsigned(B)) = 0) else
	'1';

REMAINDER <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) mod to_integer(unsigned(B)),32)) when not(to_integer(unsigned(B)) = 0) else
	(others => 'Z');

QUOTIENT <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B)),32)) when not(to_integer(unsigned(B)) = 0) else
	(others => 'Z');


end architecture;