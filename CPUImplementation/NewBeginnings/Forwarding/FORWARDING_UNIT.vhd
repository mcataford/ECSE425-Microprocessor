library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FORWARDING_UNIT is
    port(
        clock : in STD_LOGIC;
        EX_MEM_REGWRITE : in STD_LOGIC;
        MEM_WB_REGWRITE : in STD_LOGIC;
        ID_EX_RS : in STD_LOGIC_VECTOR(4 downto 0);
        ID_EX_RT : in STD_LOGIC_VECTOR(4 downto 0);
        EX_MEM_RD : in STD_LOGIC_VECTOR(4 downto 0);
        MEM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);

        MUX_A : out STD_LOGIC_VECTOR(1 downto 0);
        MUX_B : out STD_LOGIC_VECTOR(1 downto 0)
    );

end FORWARDING_UNIT;


architecture behaviour of FORWARDING_UNIT is
--Signals
signal out_a, out_b : STD_LOGIC_VECTOR(1 downto 0);
signal a : std_logic := '0';
--Variables


begin



    -- MUX_A <= "10" when (EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD = ID_EX_RS) else
    --             "01" when (MEM_WB_REGWRITE = '1') AND (MEM_WB_RD /= "00000") AND NOT((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD /= ID_EX_RS)) AND (MEM_WB_RD = ID_EX_RS) else
    --             "00";

    -- MUX_B <= "10" when (EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD = ID_EX_RT) else
    --             "01" when (MEM_WB_REGWRITE = '1') AND (MEM_WB_RD /= "00000") AND NOT ((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD /= ID_EX_RT)) AND (MEM_WB_RD = ID_EX_RT) else
    --             "00";




forwarder : process (clock)
begin

    if(a = '0' and rising_edge(clock)) then
        --EX FORWARDING--
        if((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD = ID_EX_RS)) then
            out_a <= "10";
        elsif((MEM_WB_REGWRITE = '1') AND (MEM_WB_RD /= "00000") AND NOT((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD /= ID_EX_RS)) AND (MEM_WB_RD = ID_EX_RS)) then
            out_a <= "01";
	else
	    out_a <= "00";
        end if;

        if((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD = ID_EX_RT)) then
            out_b <= "10";
        elsif((MEM_WB_REGWRITE = '1') AND (MEM_WB_RD /= "00000") AND NOT ((EX_MEM_REGWRITE = '1') AND (EX_MEM_RD /= "00000") AND (EX_MEM_RD /= ID_EX_RT)) AND (MEM_WB_RD = ID_EX_RT)) then
            out_b <= "01";
	else
	    out_b <= "00";
        end if;
    	a <= '1';
    elsif(a = '1' and rising_edge(clock)) then
	a <= '0';
    end if;



end process forwarder;

MUX_A <= out_a;
MUX_B <= out_b;

end behaviour;