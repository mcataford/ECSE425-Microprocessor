library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register is

    port(

        ---Inputs---
        CLOCK : in std_logic;
        READ_REG1 : in std_logic_vector (4 downto 0);
        READ_REG2 : in std_logic_vector (4 downto 0);
        WRITE_REG : in std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        
        ---Internal Signals---
        PC_IN : in std_logic_vector (31 downto 0);

        ---Control Signals---
        CONTROL_LINK : in std_logic;
        

        ---Outputs---

        READ_DATA_OUT1 : out std_logic_vector (31 downto 0);
        READ_DATA_OUT2 : out std_logic_vector (31 downto 0)

    );
end register;

architecture arch of register is

    type MEM is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal REG : MEM;
    signal rs, rt, rd : integer;

    begin

        --- Continuously sets $0 = 0x0000;
        REG(0) <= x"0000";

        --- Decode addresses to integers
        rs <= to_integer(unsigned(READ_REG1));
        rt <= to_integer(unsigned(READ_REG2))
        rd <= to_integer(unsigned(WRITE_REG));

        reg_op : process(rising_edge(CLOCK))
            begin
                if(CONTROL_LINK = '1') then
                    REG(31) <= PC_IN;
                else
                    REG(rd) <= WRITE_DATA;
                    READ_DATA_OUT1 <= REG(rs);
                    READ_DATA_OUT2 <= REG(rt);
                end if;
        end reg_op;


end arch;