library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_tb is
end entity;

architecture ALU_tst of ALU_tb is

signal A,B,OUTPUT: std_logic_vector(31 downto 0);
signal ZERO,OVERFLOW: std_logic;
signal ALU_CONTROL: std_logic_vector(2 downto 0);

constant clock_period: time := 1 ns;

component ALU

--To be replace with future versions of the port map.
port(
	--Inputs
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(2 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	ZERO, OVERFLOW: out std_logic
);

end component;

begin

ALU_tst : ALU port map(A,B,ALU_CONTROL,OUTPUT,ZERO,OVERFLOW);

process

begin

A <= std_logic_vector(to_unsigned(50,32));
B <= std_logic_vector(to_unsigned(60,32));
ALU_CONTROL <= "000";

wait;

end process;

end architecture;