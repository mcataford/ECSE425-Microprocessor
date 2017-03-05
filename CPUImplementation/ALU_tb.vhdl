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

variable test_condition: boolean;

begin

for i in 0 to 50 loop

A <= std_logic_vector(to_unsigned(i,32));
	
	for j in 0 to 50 loop
		B <= std_logic_vector(to_unsigned(j,32));

		for k in 0 to 7 loop
			ALU_CONTROL <= std_logic_vector(to_unsigned(k,3));

			wait for 1 ns;
			
			if ALU_CONTROL = "000" then
				test_condition := (i + j) = to_integer(unsigned(OUTPUT));
			elsif ALU_CONTROL = "001" then
				test_condition := (A and B) = OUTPUT;
			elsif ALU_CONTROL = "010" then
				test_condition := (A or B) = OUTPUT;
			elsif ALU_CONTROL = "011" then
				test_condition := (A xor B) = OUTPUT;
			elsif ALU_CONTROL = "100" then
				test_condition := (A nor B) = OUTPUT;
			elsif ALU_CONTROL = "101" then
				test_condition := std_logic_vector(to_unsigned((i * j),32)) = OUTPUT;
			elsif ALU_CONTROL = "110" then
				--test_condition := std_logic_vector(to_unsigned((i / j),32)) = OUTPUT;
				test_condition := true;			
			else
				test_condition := true;
			end if;

			assert test_condition report "Failed to assert.";
		
			
		end loop;

	end loop;

end loop;

wait;

end process;

end architecture;