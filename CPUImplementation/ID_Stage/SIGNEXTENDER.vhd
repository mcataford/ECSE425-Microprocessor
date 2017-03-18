library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIGNEXTENDER is

    port(

        ---Inputs---

       EXTEND_IN : in std_logic_vector (15 downto 0);

        ---Outputs---

        EXTEND_OUT : out std_logic_vector (31 downto 0)

    );
end SIGNEXTENDER;

architecture arch of SIGNEXTENDER is

signal ones : std_logic_vector(15 downto 0):="1111111111111111";
signal zeros : std_logic_vector(15 downto 0):="0000000000000000";

    begin

    EXTEND_OUT<= zeros & EXTEND_IN when EXTEND_IN(15) = '0' else
                 ones & EXTEND_IN when EXTEND_IN(15) = '1' else
                 (others=>'0');

end arch;
