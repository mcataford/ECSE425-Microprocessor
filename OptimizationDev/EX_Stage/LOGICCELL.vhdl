library IEEE;

use ieee.std_logic_1164.all;

entity LOGICCELL is

port (
	A,B: in std_logic_vector(31 downto 0);
	MODE: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0)
);

end entity;

architecture LOGICCELL_Impl of LOGICCELL is

begin

process(A,B,MODE)

begin

--The mode selector is a 2 bit setting signal:
--00 : AND
--01 : OR
--10 : XOR
--11 : NOR

case MODE is

	--AND
	when "00" =>
		OUTPUT <= A and B;
	--OR
	when "01" =>
		OUTPUT <= A or B;

	--XOR	
	when "10" =>
		OUTPUT <= A xor B;

	--NOR
	when "11" =>
		OUTPUT <= A nor B;

	--If the code is invalid, high impedance to signal error.
	when others =>
		OUTPUT <= (others => 'Z');
end case;


end process;

end architecture;