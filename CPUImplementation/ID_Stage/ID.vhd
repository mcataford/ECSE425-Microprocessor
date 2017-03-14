library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ID is

    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WB_DATA : in std_logic_vector (31 downto 0);

        ---Control Signals---
        CONTROL_BRANCH : out std_logic;
        CONTROL_MEM_TO_REG : out std_logic;
        CONTROL_MEM_READ : out std_logic;
        CONTROL_ALU_OP : out std_logic_vector(3 downto 0);
        CONTROL_MEM_WRITE : out std_logic;
        CONTROL_ALU_SRC : out std_logic;

        ---Data Outputs---
        PC_OUT : out std_logic_vector (31 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    );

end ID;


architecture arch of ID is

    signal REG_DEST_MUX_OUT : std_logic_vector (4 downto 0);
    signal CONTROL_REG_DEST : std_logic;
    signal CTRL_BRANCH : std_logic;
    signal CTRL_MEM_READ : std_logic;
    signal CTRL_MEM_TO_REG : std_logic;
    signal CTRL_ALU_OP : std_logic_vector(3 downto 0);
    signal CTRL_MEM_WRITE : std_logic;
    signal CTRL_ALU_SRC : std_logic;
    signal CTRL_REG_WRITE : std_logic;
    signal CTRL_GET_HI : std_logic;
    signal CTRL_GET_LO : std_logic;
    signal CTRL_LINK : std_logic;
    signal CTRL_REG_DEST : std_logic;

    component DATAREGISTER is
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
            CONTROL_REG_WRITE : in std_logic;
            CONTROL_GET_HI : in std_logic;
            CONTROL_GET_LO : in std_logic;
            
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

    component CONTROL is
        port(
            ---Inputs---
            CLOCK : in std_logic;
            INSTRUCTION : in std_logic_vector(31 downto 26);
            ---Outputs---
            REG_DEST : out std_logic;
            BRANCH : out std_logic;
            MEM_READ : out std_logic;
            MEM_TO_REG : out std_logic;
            ALU_OP : out std_logic_vector(3 downto 0);
            MEM_WRITE : out std_logic;
            ALU_SRC : out std_logic;
            REG_WRITE : out std_logic;
            GET_HI : out std_logic;
            GET_LO : out std_logic;
            CONTROL_JAL : out std_logic
        );
    end component;

    begin

        REG_DEST_MUX : MUX_5BIT
            port map(INSTRUCTION(20 downto 16),INSTRUCTION(15 downto 11), CTRL_REG_DEST, REG_DEST_MUX_OUT);

        EXTENDER : SIGNEXTENDER
            port map(INSTRUCTION(15 downto 0), SIGN_EXTENDED_OUT);

        REG : DATAREGISTER
            port map(CLOCK, INSTRUCTION(25 downto 21), INSTRUCTION(20 downto 16), REG_DEST_MUX_OUT, WB_DATA,
                        PC_IN, CTRL_LINK, CTRL_REG_WRITE, CTRL_GET_HI, CTRL_GET_LO, REG_OUT1, REG_OUT2);
        
        CONTROL_UNIT : CONTROL
            port map(CLOCK, INSTRUCTION(31 downto 26), CTRL_REG_DEST, CTRL_BRANCH, CTRL_MEM_READ, CTRL_MEM_TO_REG,
                    CTRL_ALU_OP, CTRL_MEM_WRITE, CTRL_ALU_SRC, CTRL_REG_WRITE, CTRL_GET_HI, CTRL_GET_LO, CTRL_LINK);

	CONTROL_BRANCH <= CTRL_BRANCH;
        CONTROL_MEM_TO_REG <= CTRL_MEM_TO_REG;
        CONTROL_MEM_READ <= CTRL_MEM_READ;
        CONTROL_ALU_OP <= CTRL_ALU_OP;
        CONTROL_MEM_WRITE <= CTRL_MEM_WRITE;
        CONTROL_ALU_SRC <= CTRL_ALU_SRC;

end arch;