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