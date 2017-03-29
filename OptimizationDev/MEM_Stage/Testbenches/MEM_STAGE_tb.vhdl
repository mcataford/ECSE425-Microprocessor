library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_STAGE_tb is
end entity;

architecture MEM_STAGE_tst of MEM_STAGE_tb is

signal CLOCK: std_logic;
signal MEM_CONTROL : std_logic_vector(1 downto 0);
signal DATA_IN, DATA_ADDR, INSTR_IN, DATA_OUT, DATA_FORWARD_OUT, INSTR_OUT: std_logic_vector(31 downto 0) := (others => '0');

constant CLK_PERIOD: time := 1 ns;

component MEM_STAGE
	port (
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Data to register--
		DATA_IN,
		--Write addr.
		DATA_ADDR,
		--Instruction in--
		INSTR_IN : in std_logic_vector(31 downto 0);
		MEM_CONTROL : in std_logic_vector(1 downto 0);
		--OUTPUT--
		--Data output--
		DATA_OUT,
		--Data forward--
		DATA_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT : out std_logic_vector(31 downto 0)
	);
end component;

begin

MEM_ST : MEM_STAGE port map(
	CLOCK,
	DATA_IN,
	DATA_ADDR,
	INSTR_IN,
	MEM_CONTROL,
	DATA_OUT,
	DATA_FORWARD_OUT,
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

wait for 0.5 * CLK_PERIOD;

DATA_IN <= std_logic_vector(to_unsigned(50,32));
DATA_ADDR <= (others => '0');
MEM_CONTROL <= "00";

wait for 1 * CLK_PERIOD;

MEM_CONTROL <= "10";

wait for 1 * CLK_PERIOD;

MEM_CONTROL <= "01";

wait;

end process;

end architecture;