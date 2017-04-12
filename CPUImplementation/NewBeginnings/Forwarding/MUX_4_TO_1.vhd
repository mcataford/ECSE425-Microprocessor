library IEEE;

use ieee.std_logic_1164.all;

entity MUX_4_TO_1 is

port(
	A,B,C: in std_logic_vector(31 downto 0);
	SELECTOR: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0)
);

end entity;

architecture MUX_IMPL of MUX_4_TO_1 is

signal result : std_logic_vector(31 downto 0);

begin



with SELECTOR select result <=
    A when "00",
    B when "01",
    C when "10",
    A when others;

OUTPUT <= result;


-- selection : process(SELECTOR,A,B,C)
-- begin
-- 	case sel is
-- 		when "00" =>
-- 			OUTPUT <= A;
-- 		when "01" =>
-- 			OUTPUT <= B;
-- 		when "10" =>
-- 			OUTPUT <= C;
-- 		when others =>
		
-- 		end case;
-- end process selection;

end architecture;