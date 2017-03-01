library IEEE;

use ieee.std_logic_1164.all;

entity ALU is

--TODO: determine ALU_CONTROL width.

port(
	CLOCK: in std_logic;
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(31 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	ZERO: out std_logic;
);

end entity;

architecture ALU_impl of ALU is

begin

process(CLOCK)

begin 

end process;

end architecture;