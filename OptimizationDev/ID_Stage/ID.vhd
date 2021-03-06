library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ID is

    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION_IN : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WRITE_REG : std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        WRITE_HILO : in std_logic_vector(63 downto 0);
        --Control Signals In--
        CONTROL_REG_WRITE_IN : in std_logic;
        ---Control Signals Out---
        CONTROL_VECTOR : out std_logic_vector(9 downto 0);
        ---Data Outputs---
        INSTRUCTION_OUT : out std_logic_vector(31 downto 0);
        PC_OUT : out std_logic_vector (31 downto 0);
        RD_OUT : out std_logic_vector(4 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    );

end ID;


architecture arch of ID is
    --CONTROL--
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
        INSTRUCTION_OP: in std_logic_vector(31 downto 26);
        INSTRUCTION_FUNC : in std_logic_vector(5 downto 0);
        ---Outputs---
        REG_DEST : out std_logic;
        BRANCH : out std_logic;
        MEM_READ : out std_logic;
        MEM_TO_REG : out std_logic;
        MEM_WRITE : out std_logic;
        ALU_SRC : out std_logic;
        REG_WRITE : out std_logic;
        ALU_OP : out std_logic_vector(3 downto 0);
        GET_HI : out std_logic;
        GET_LO : out std_logic;
        CONTROL_JAL : out std_logic
        );
    end component;

    begin

        REG_DEST_MUX : MUX_5BIT
            port map(INSTRUCTION_IN(20 downto 16), INSTRUCTION_IN(15 downto 11), CTRL_REG_DEST, RD_OUT);

        EXTENDER : SIGNEXTENDER
            port map(INSTRUCTION_IN(15 downto 0), SIGN_EXTENDED_OUT);

        REG : DATAREGISTER
            port map(
                CLOCK,
                INSTRUCTION_IN(25 downto 21),
                INSTRUCTION_IN(20 downto 16),
                WRITE_REG,
                WRITE_DATA,
                WRITE_HILO,
                PC_IN,
                CTRL_LINK,
                CONTROL_REG_WRITE_IN, 
                CTRL_GET_HI,
                CTRL_GET_LO,
                REG_OUT1,
                REG_OUT2
            );
        
        CONTROL_UNIT : CONTROL
            port map(
                INSTRUCTION_IN(31 downto 26),
                INSTRUCTION_IN(5 downto 0),
                CTRL_REG_DEST,
                CONTROL_VECTOR(0),
                CONTROL_VECTOR(1),
                CONTROL_VECTOR(2),
                CONTROL_VECTOR(3),
                CONTROL_VECTOR(4),
                CONTROL_VECTOR(5),
                CONTROL_VECTOR(9 downto 6),
                CTRL_GET_HI,
                CTRL_GET_LO,
                CTRL_LINK
            );
        INSTRUCTION_OUT <= INSTRUCTION_IN;
        PC_OUT <= PC_IN;

end arch;