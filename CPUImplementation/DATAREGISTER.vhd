library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register is

    port(

        ---Inputs---

        READ_REG1 : in std_logic_vector (4 downto 0);
        READ_REG2 : in std_logic_vector (4 downto 0);
        WRITE_REG : in std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);

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

        --- Continuously sets $R0 = 0x0000;
        REG(0) <= x"0000";

        --- Decode addresses to integers
        rs <= to_integer(unsigned(READ_REG1));
        rt <= to_integer(unsigned(READ_REG2))
        rd <= to_integer(unsigned(WRITE_REG));

     
        write_to_reg : process(WRITE_DATA)
            begin
                REG(rd) <= WRITE_DATA;
        end write_to_reg

        READ_DATA_OUT1 <= REG(rs);
        READ_DATA_OUT2 <= REG(rt);


end arch;