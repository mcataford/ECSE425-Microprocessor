
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIGNEXTENDER_TB is
end SIGNEXTENDER_TB;

architecture behavior of SIGNEXTENDER_TB is

component SIGNEXTENDER is

 port(
        ---Inputs---

       EXTEND_IN : in std_logic_vector (15 downto 0);

        ---Outputs---

        EXTEND_OUT : out std_logic_vector (31 downto 0)

    );

end component;
	
    signal exin : std_logic_vector(15 downto 0);
    signal exout : std_logic_vector(31 downto 0);

begin

s : SIGNEXTENDER 
port map(
	exin,
    exout
);
 


test : PROCESS 
BEGIN

exin <= "0000000000000000";

wait for 1 ns;

exin <= "1111100000111001";

wait;

end process;
end behavior;