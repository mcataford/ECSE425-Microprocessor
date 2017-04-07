library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_ID_REG_tb is
end entity;

architecture IF_ID_REG_tst of IF_ID_REG_tb is

signal CLOCK: std_logic := '0';
signal PC_IN, INSTR_IN, PC_OUT, INSTR_OUT: std_logic_vector(31 downto 0) := (others => '0');

constant CLK_PERIOD: time := 1 ns;

component IF_ID_REGISTER

    port(
        --Inputs--
	CLOCK: in std_logic; 
        PC_IN,
        INSTR_IN : in std_logic_vector(31 downto 0);
        --Outputs--
        PC_OUT,
        INSTR_OUT : out std_logic_vector(31 downto 0)
    );

end component;

begin

IF_ID_REG : IF_ID_REGISTER port map(
	--INPUTS--
	--Clock signal--
	CLOCK,
	--Program counter--
	PC_IN,
	--Instruction--
	INSTR_IN,
	--OUTPUTS--
	PC_OUT,
	INSTR_OUT
);

process

begin

CLOCK <= '0';
wait for 0.5 * CLK_PERIOD;
CLOCK <= '1';
wait for 0.5 * CLK_PERIOD;


end process;

process

begin

PC_IN <= std_logic_vector(to_unsigned(500,32));
INSTR_IN <= std_logic_vector(to_unsigned(600,32));

wait for 1 * CLK_PERIOD;

assert PC_IN = PC_OUT and INSTR_IN = INSTR_OUT report "Failed to propagate.";

wait;

end process;

end architecture;