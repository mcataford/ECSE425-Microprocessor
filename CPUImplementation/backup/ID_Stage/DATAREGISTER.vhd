
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATAREGISTER is

    port(

        ---Inputs---
        CLOCK : in std_logic;
        READ_REG1 : in std_logic_vector (4 downto 0);
        READ_REG2 : in std_logic_vector (4 downto 0);
        WRITE_REG : in std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        WRITE_HILO : in std_logic_vector(63 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);

        ---Control Signals---
        CONTROL_LINK : in std_logic;
        CONTROL_REG_WRITE : in std_logic;
        CONTROL_GET_HI : in std_logic;
        CONTROL_GET_LO : in std_logic;

        ---Outputs---

        READ_DATA_OUT1 : out std_logic_vector (31 downto 0);
        READ_DATA_OUT2 : out std_logic_vector (31 downto 0)

    );
end DATAREGISTER;

architecture arch of DATAREGISTER is

    type MEM is array (31 downto 0) of std_logic_vector(31 downto 0);
    signal REG : MEM:=(others=>"00000000000000000000000000000001");
    signal HI, LO : std_logic_vector(31 downto 0);
    signal rs, rt, rd : integer;

    begin


        --- Decode addresses to integers
        rs <= to_integer(unsigned(READ_REG1));
        rt <= to_integer(unsigned(READ_REG2));
        rd <= to_integer(unsigned(WRITE_REG));

        reg_hilo : process(WRITE_HILO)
            begin
                HI <= WRITE_HILO(63 downto 32);
                LO <= WRITE_HILO(31 downto 0);
        end process reg_hilo;

        reg_op : process(CLOCK)
            begin

            REG(0) <= "00000000000000000000000000000000";
            --Writing to register on the falling edge of clk--
            if(falling_edge(CLOCK) AND CONTROL_REG_WRITE = '1') then
                REG(rd) <= WRITE_DATA;
            end if;

            --Reading out of register on the risign edge of clk--
            if rising_edge(CLOCK) then
                if(CONTROL_LINK = '1') then
                    REG(3) <= PC_IN;
                end if;
                if(CONTROL_GET_HI = '1') then
                    READ_DATA_OUT1 <= REG(0);
                    READ_DATA_OUT2 <= HI;
                elsif(CONTROL_GET_LO = '1') then
                    READ_DATA_OUT1 <= REG(0);
                    READ_DATA_OUT2 <= LO;
                else
                    READ_DATA_OUT1 <= REG(rs);
                    READ_DATA_OUT2 <= REG(rt);
                end if;
            end if;
        end process reg_op;
end arch;