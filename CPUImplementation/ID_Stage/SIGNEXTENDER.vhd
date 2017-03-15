library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender is

    port(

        ---Inputs---

       EXTEND_IN : in std_logic_vector (15 downto 0);

        ---Outputs---

        EXTEND_OUT : out std_logic_vector (31 downto 0)

    );
end extender;

architecture arch of extender is

    begin

    extend : process (EXTEND_IN)
        begin  
            if(EXTEND_IN(15)='1') then
                EXTEND_OUT(31 downto 16) <= x"FFFF";
                EXTEND_OUT(15 downto 0) <= EXTEND_IN;
            elsif(EXTEND_IN(15) = '0') then
                EXTEND_OUT(31 downto 16) <= x"0000";
                EXTEND_OUT(15 downto 0) <= EXTEND_IN;
            end if;
    end process;

end arch;
