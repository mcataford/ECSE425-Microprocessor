<<<<<<< HEAD
library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_STAGE_tb is
end entity;

architecture ID_STAGE_tst of ID_STAGE_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal CLOCK: std_logic;
	signal PC,WB_SRC: std_logic_vector(31 downto 0) := (others => '0');
	signal REG_A, REG_B, IMMEDIATE: std_logic_vector(31 downto 0) := (others => '0');
	signal INSTR, WB_DATA: std_logic_vector(31 downto 0) := (others => '0');
	signal CONTROL_VECTOR: std_logic_vector(7 downto 0);

	component ID_STAGE
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			--Writeback source
			WB_SRC: in std_logic_vector(31 downto 0);
			--Writeback data
			WB_DATA: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Register A
			REG_A: out std_logic_vector(31 downto 0) := (others => 'Z');
			--Register B
			REG_B: out std_logic_vector(31 downto 0) := (others => 'Z');
			--Sign-extended immediate
			IMMEDIATE: out std_logic_vector(31 downto 0) := (others => 'Z');
			--Control signals
			CONTROL_VECTOR: out std_logic_vector(7 downto 0)
		);
		
	end component;
	
begin

	ID_ST: ID_STAGE port map(
		CLOCK,
		INSTR,
		WB_SRC,
		WB_DATA,
		REG_A,
		REG_B,
		IMMEDIATE,
		CONTROL_VECTOR
	);
	
	CLK: process
	
	begin
	
		CLOCK <= '0';
		wait for 0.5 * CLK_PERIOD;
		CLOCK <= '1';
		wait for 0.5 * CLK_PERIOD;
	
	end process;
	
	TST: process
	
	begin
	
		INSTR <= (others => 'Z');
		
		wait for 1 * CLK_PERIOD;
	
		INSTR <= "00100000000000010000001111101000";
		
		wait for 1 * CLK_PERIOD;
		
		INSTR <= "00100000001000010000000000000000";
		
	
		wait;
		
	end process;

end architecture;
=======
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

end component;
	
-- test signals 
signal clk : std_logic := '0';
constant clk_period : time := 1 ns;
type MEM is array (39 downto 0) of std_logic_vector (31 downto 0);
signal instructions : MEM := ("00100000000010110000011111010000","00100000000011110000000000000100","00100000000000010000000000000011","00000000001000100001100000100100","00100000000010100000000000000000","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000000110001000000100000","10101101101000100000000000000000","00010000001000000000000000001001","00010000010000000000000000001000","00100000000001000000000000000001","00100000000010100000000000000001","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001000001000000100000","10101101101000100000000000000000","00001000000000000000000000010110","00100000000001000000000000000000","00000000001000100010100000100101","00100000000010100000000000000011","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001010001000000100000","10101101101000100000000000000000","00010100001000000000000000001001","00010100010000000000000000001000","00100000000001100000000000000000","00100000000010100000000000000100","00000001010011110000000000011000","00000000000000000110000000010010","00000001011011000110100000100000","00000000000001100001000000100000","10101101101000100000000000000000","00001000000000000000000000101000","00100000000001100000000000000001","00010001011010111111111111111111");
signal i : integer :=39;


signal instout : std_logic_vector(31 downto 0);
signal instin : std_logic_vector(31 downto 0);
signal pcin : std_logic_vector(31 downto 0);
signal pcout : std_logic_vector(31 downto 0);
signal wbreg_in : std_logic_vector(4 downto 0);
signal wbdata : std_logic_vector(31 downto 0);
signal wbhilo : std_logic_vector(63 downto 0);
signal CTRL_REG_WRITE_IN : std_logic;

signal control : std_logic_vector(9 downto 0);

signal wbreg_out : std_logic_vector(4 downto 0);
]signal SIGN_EXTEND_OUT : std_logic_vector(31 downto 0);
signal r1 : std_logic_vector(31 downto 0);
signal r2 : std_logic_vector(31 downto 0);

begin

stage : ID
port map(
    --Inputs--
	CLOCK=>clk,
    INSTRUCTION_IN=>instin,
    PC_IN=>pcin,
    WRITE_REG=>wbreg_in,
    WRITE_DATA=>wbdata,
    WRITE_HILO=>wbhilo,
    CONTROL_REG_WRITE_IN=>CTRL_REG_WRITE_IN,
    CONTROL_VECTOR=>control,
    INSTRUCTION_OUT=>instout,
    PC_OUT=>pcout,
    RD_OUT=>wbreg_out,
    SIGN_EXTENDED_OUT=>SIGN_EXTEND_OUT,
    REG_OUT1=>r1,
    REG_OUT2=>r2
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

instin <= instructions(i);
pcin <= "00000000000000000000000000000000";
i <= i-1;

wait for clk_period;

instin <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
i <= i-1;

wait for clk_period;

instin <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
i <= i-1;

wait for clk_period;

instin <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
CTRL_REG_WRITE_IN <= '1';
wbreg_in <= "01010";
wbdata <="00000000000000000000000000110110";
i <= i-1;

wait for clk_period;

instin <= instructions(i);
pcin <= pcin OR "00000000000000000000000000000001";
wbhilo <="0000000000000000000000000000000000000000000001011011101111011111";
i <= i-1;

wait for clk_period;

instin <= "00000000000000000100100000010010";
pcin <= pcin or "00000000000000000000000000000001";
i <= i-1;

wait for clk_period;

instin <= "00000001010010110100100000100000";
pcin <= pcin or "00000000000000000000000000000100";
i <= i-1;

wait;

end process;
end behavior;
>>>>>>> 0f92f0a2058d6e5161aaacf7b57e736864844187
