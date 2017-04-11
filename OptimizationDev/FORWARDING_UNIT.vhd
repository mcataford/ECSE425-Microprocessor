library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FORWARDING_UNIT is
    port(
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

--Variables


begin

forwarder : process (ID_EX_RS, ID_EX_RT)
begin

    --EX FORWARDING--
    if(EX_MEM_REGWRITE AND (EX_MEM_RD /= '0') AND (EX_MEM_RD = ID_EX_RS)) then
        MUX_A <= "10";
    elsif(EX_MEM_REGWRITE AND (EX_MEM_RD /= '0') AND (EX_MEM_RD = ID_EX_RT)) then
        MUX_B <= "10";

    --MEM FORWARDING--
    elsif(MEM_WB_REGWRITE AND (MEM_WB_RD /= '0') AND NOT(EX_MEM_REGWRITE and (EX_MEM_RD /= '0') and (EX_MEM_RD /= ID_EX_RS)) and (MEM_WB_RD = ID_EX_RS)) then
        MUX_A <= "01";
    elsif(MEM_WB_REGWRITE AND (MEM_WB_RD /= '0') AND NOT (EX_MEM_REGWRITE AND(EX_MEM_RD /= '0') AND (EX_MEM_RD /= ID_EX_RT)) AND MEM_WB_RD = ID_EX_RT)) then
        MUX_B <= "01";
    end if;
end process forwarder;

end behaviour;