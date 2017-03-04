library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ID is

    port(
        ---Inputs---
        INSTRUCTION : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        REG_DEST_SELECT : in std_logic;
        WB_DATA : in std_logic_vector (31 downto 0);
        CLOCK : in std_logic;

        ---Outputs---
        PC_OUT : out std_logic_vector (31 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    )

end ID;


architecture arch of ID is

    signal REG_DEST_MUX_OUT std_logic_vector (4 downto 0);

    component DATAREGISTER is
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
    end component;

    component MUX_5BIT is
        port(
            A,B: in std_logic_vector(4 downto 0);
	        SELECTOR: in std_logic;
	        OUTPUT: out std_logic_vector(4 downto 0)
        );
    end component;

    component SIGNEXTENDER is
        port(
            ---Inputs---
            EXTEND_IN : in std_logic_vector (15 downto 0);

            ---Outputs---
            EXTEND_OUT : out std_logic_vector (31 downto 0)
        );
    end component;

    begin

        REG_DEST_MUX : MUX_5BIT
            port map(INSTRUCTION(20 downto 16),INSTRUCTION(15 downto 11),REG_DEST_SELECT, REG_DEST_MUX_OUT);

        EXTENDER : SIGNEXTENDER
            port map(INSTRUCTION(15 downto 0), SIGN_EXTENDED_OUT);

        REG : DATAREGISTER
            port map(INSTRUCTION(25 downto 21), INSTRUCTION(20 downto 16), REG_DEST_MUX_OUT, WB_DATA,
                    REG_OUT1, REG_OUT2);
        

end arch;