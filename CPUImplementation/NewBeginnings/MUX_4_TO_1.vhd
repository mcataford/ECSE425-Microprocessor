library IEEE;

use ieee.std_logic_1164.all;

entity MUX is

port(
	A,B,C: in std_logic_vector(4 downto 0);
	SELECTOR: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(4 downto 0)
);

end entity;

architecture MUX_IMPL of MUX is

begin

selection : process(SELECTOR)
begin
	case SELECTOR is
		when "00" =>
			OUTPUT <= A;
		when "01" =>
			OUTPUT <= B;
		when "10" =>
			OUTPUT <= C;
		when "11" =>
			OUTPUT <= A;
		when others =>
		
		end case;
end process selection;

end architecture;