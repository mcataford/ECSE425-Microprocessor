
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL_TB is
end CONTROL_TB;

architecture behavior of CONTROL_TB is

component CONTROL is

 port(
         ---Inputs---
        INSTRUCTION_OP : in std_logic_vector(31 downto 26);
        INSTRUCTION_FUNC : in std_logic_vector(5 downto 0);
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
	
-- test signals 
signal insto : std_logic_vector(5 downto 0);
signal instf : std_logic_vector(5 downto 0);
signal rd : std_logic;
signal b : std_logic;
signal mr : std_logic;
signal mtr : std_logic;
signal aluop : std_logic_vector(3 downto 0);
signal mw : std_logic;
signal alusrc : std_logic;
signal rw : std_logic;
signal gh : std_logic;
signal gl : std_logic;
signal cjal : std_logic;
constant clk_period : time := 1 ns;

begin

comp_control : CONTROL
port map(
	  ---Inputs---
        insto,
        instf,
        rd,
        b,
        mr,
        mtr,
        aluop,
        mw,
        alusrc,
        rw,
        gh,
        gl,
        cjal
);
 

test : PROCESS 
BEGIN

wait for 1 ns;

insto <= "000000";
instf <= "001000";

wait for 1 ns;

insto <= "001000";

wait for 1 ns;

insto <= "001100";

wait for 1 ns;

insto <= "000011";

wait for 1 ns;

end process;
end behavior;