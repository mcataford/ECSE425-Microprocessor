library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_TB is
end ID_TB;

architecture behavior of ID_TB is

component ID is

 port(
---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WB_REG_IN : std_logic_vector (4 downto 0);
        WB_DATA : in std_logic_vector (31 downto 0);
        WB_HILO : in std_logic_vector(63 downto 0);
        --Control Signals In--
        CONTROL_REG_WRITE_IN : in std_logic;
        ---Control Signals---
        CONTROL_BRANCH_OUT,
        CONTROL_MEM_READ_OUT,
        CONTROL_MEM_TO_REG_OUT,
        CONTROL_MEM_WRITE_OUT,
        CONTROL_ALU_SRC_OUT,
        CONTROL_REG_WRITE_OUT : out std_logic;
        CONTROL_ALU_OP_OUT : out std_logic_vector(3 downto 0);
        ---Data Outputs---
        WB_REG_OUT : out std_logic_vector(4 downto 0);
        PC_OUT : out std_logic_vector (31 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    );

end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;
type MEM is array (39 downto 0) of std_logic_vector (31 downto 0);
signal instructions : MEM := ("00100000000010110000011111010000","00100000000011110000000000000100","00100000000000010000000000000011","00000000001000100001100000100100","00100000000010100000000000000000","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000000110001000000100000","10101101101000100000000000000000","00010000001000000000000000001001","00010000010000000000000000001000","00100000000001000000000000000001","00100000000010100000000000000001","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001000001000000100000","10101101101000100000000000000000","00001000000000000000000000010110","00100000000001000000000000000000","00000000001000100010100000100101","00100000000010100000000000000011","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001010001000000100000","10101101101000100000000000000000","00010100001000000000000000001001","00010100010000000000000000001000","00100000000001100000000000000000","00100000000010100000000000000100","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001100001000000100000","10101101101000100000000000000000","00001000000000000000000000101000","00100000000001100000000000000001","00010001011010111111111111111111");
signal i : integer :=39;


signal inst : std_logic_vector(31 downto 0);
signal pcin : std_logic_vector(31 downto 0);
signal wbreg_in : std_logic_vector(4 downto 0);
signal wbdata : std_logic_vector(31 downto 0);
signal wbhilo : std_logic_vector(63 downto 0);
signal CTRL_REG_WRITE_IN : std_logic;

signal CTRL_BRANCH_OUT : std_logic;
signal CTRL_MEM_TO_REG_OUT : std_logic;
signal CTRL_MEM_READ_OUT : std_logic;
signal CTRL_ALU_OP_OUT : std_logic_vector(3 downto 0);
signal CTRL_MEM_WRITE_OUT : std_logic;
signal CTRL_ALU_SRC_OUT : std_logic;
signal CTRL_REG_WRITE_OUT : std_logic;

signal wbreg_out : std_logic_vector(4 downto 0);
signal pc_out : std_logic_vector(31 downto 0);
signal SIGN_EXTEND_OUT : std_logic_vector(31 downto 0);
signal r1 : std_logic_vector(31 downto 0);
signal r2 : std_logic_vector(31 downto 0);

begin

stage : ID
port map(
    --Inputs--
	CLOCK => clk,
	INSTRUCTION => inst,
	PC_IN => pcin,
    WB_REG_IN => wbreg_in,
	WB_DATA => wbdata,
    WB_HILO => wbhilo,
    --Control signal in--
    CONTROL_REG_WRITE_IN => CTRL_REG_WRITE_IN,
    --Control signal out--
	CONTROL_BRANCH_OUT=> CTRL_BRANCH_OUT,	
    CONTROL_MEM_READ_OUT => CTRL_MEM_READ_OUT,
	CONTROL_MEM_TO_REG_OUT => CTRL_MEM_TO_REG_OUT,
    CONTROL_MEM_WRITE_OUT => CTRL_MEM_WRITE_OUT,
	CONTROL_ALU_SRC_OUT => CTRL_ALU_SRC_OUT,
    CONTROL_REG_WRITE_OUT => CTRL_REG_WRITE_OUT,
	CONTROL_ALU_OP_OUT => CTRL_ALU_OP_OUT,
    WB_REG_OUT => wbreg_out,
	PC_OUT => pc_out,
    SIGN_EXTENDED_OUT => SIGN_EXTEND_OUT,
	REG_OUT1 => r1,
	REG_OUT2 => r2
);

clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 

test : PROCESS 
BEGIN
wait for clk_period;

inst <= instructions(i);
pcin <= "00000000000000000000000000000000";
i <= i-1;

wait for clk_period;

inst <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
i <= i-1;

wait for clk_period;

inst <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
wbreg_in <= "01010";
wbdata <="00000000000000000000000000110110";
i <= i-1;

wait for clk_period;

inst <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
CTRL_REG_WRITE_IN <= '1';
wbreg_in <= "01010";
wbdata <="00000000000000000000000000110110";
i <= i-1;

wait for clk_period;

inst <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
wbhilo <="0000000000000000000000000000000000000000000001011011101111011111";
i <= i-1;

wait for clk_period;

inst <= "00000000000000000100100000010010";
pcin <= pcin or "00000000000000000000000000000001";
i <= i-1;

wait for clk_period;

inst <= "00000001010010110100100000100000";
pcin <= pcin or "00000000000000000000000000000100";
i <= i-1;

wait;

end process;
end behavior;