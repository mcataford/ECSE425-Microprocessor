library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LOGICCELL_tb is
end entity;

architecture LOGICCELL_tst of LOGICCELL_tb is

signal A,B,OUTPUT: std_logic_vector(31 downto 0);
signal MODE: std_logic_vector(1 downto 0);

component LOGICCELL

port (
	A,B: in std_logic_vector(31 downto 0);
	MODE: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0)
);

end component;

begin

LC: LOGICCELL port map(A,B,MODE,OUTPUT);

process

begin

--Testing over the whole 32b range of A,B

for i in 0 to INTEGER'HIGH loop
	A <= std_logic_vector(to_unsigned(i,32));

	for j in 0 to INTEGER'HIGH loop
		B <= std_logic_vector(to_unsigned(j,32));

		MODE <= "00";
		wait for 1 ns;
		assert OUTPUT = (A and B) report "AND failed.";

		MODE <= "01";	
		wait for 1 ns;
		assert OUTPUT = (A or B) report "OR failed.";

		MODE <= "10";
		wait for 1 ns;
		assert OUTPUT = (A xor B) report "XOR failed.";

		MODE <= "11";
		wait for 1 ns;
		assert OUTPUT = (A nor B) report "NOR failed.";


	end loop;
end loop;

wait;

end process;

end architecture;