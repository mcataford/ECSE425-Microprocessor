library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_STAGE_tb is
end entity;

architecture IF_STAGE_tst of IF_STAGE_tb is

signal CLOCK, RESET, PC_SRC: std_logic;
signal ALU_PC, PC_OUT, INSTR: std_logic_vector(31 downto 0);

constant CLK_PERIOD: time := 1 ns;

component IF_STAGE

port(
	--Inputs--
	CLOCK: in std_logic;
	RESET: in std_logic;
	---Control Signals---
	PC_SRC: in std_logic; --MUX select
	ALU_PC: in std_logic_vector(31 downto 0); --One of the MUX inputs
	--Outputs--
	PC_OUT: out std_logic_vector(31 downto 0);
	INSTR: out std_logic_vector(31 downto 0)
);

end component;

begin

IF_ST : IF_STAGE port map(CLOCK, RESET, PC_SRC, ALU_PC, PC_OUT, INSTR); 

process

begin

CLOCK <= '0';
wait for 0.5 * CLK_PERIOD;
CLOCK <= '1';
wait for 0.5 * CLK_PERIOD;

end process;

process

begin

RESET <= '0';
PC_SRC <= '0';
ALU_PC <= (others => '0');

wait;

end process;

end architecture;