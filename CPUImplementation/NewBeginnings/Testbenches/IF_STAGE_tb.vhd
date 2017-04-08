library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_STAGE_tb is
end entity;

architecture IF_STAGE_tst of IF_STAGE_tb is

	constant CLK_PERIOD: time := 1 ns;
	constant PC_MAX: integer := 1024;

	signal CLOCK,RESET,PC_SEL: std_logic := '0';
	signal ALU_PC, PC_OUT: std_logic_vector(31 downto 0) := (others => 'Z');
	signal INSTR: std_logic_vector(31 downto 0) := (others => '0');

	component IF_STAGE
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Reset signal
			RESET: in std_logic;
			--PC MUX select signal
			PC_SEL: in std_logic;
			--Feedback from ALU for PC calc.
			ALU_PC: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--PC output
			PC_OUT: out std_logic_vector(31 downto 0);
			--Fetched instruction
			INSTR: out std_logic_vector(31 downto 0)
		);
	
	end component;

begin

	IF_ST: IF_STAGE port map(
		CLOCK,
		RESET,
		PC_SEL,
		ALU_PC,
		PC_OUT,
		INSTR
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
	
		RESET <= '1';
		PC_SEL <= '0';
		
		wait for 1.5 * CLK_PERIOD;
		
		RESET <= '0';
	
		wait;
		
	end process;



end architecture;