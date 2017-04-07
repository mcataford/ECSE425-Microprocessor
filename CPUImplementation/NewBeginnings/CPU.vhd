library IEEE;

use ieee.std_logic_1164.all;

entity CPU is
	port(
		CLOCK: in std_logic
	);
	
end entity;

architecture CPU_Impl of CPU is

	--Intermediate signals and constants
	
	--IF stage specific
	signal IF_PC_RESET, IF_PC_SELECT: std_logic;
	signal IF_PC_ALU, IF_PC_OUT: integer;
	signal IF_INSTR_OUT: std_logic_vector(31 downto 0);

	--CPU constants
	constant PC_MAX: integer := 1024;


	--Stage components
	
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
		ALU_PC: in integer range 0 to PC_MAX;
		
		--OUTPUT
		--PC output
		PC_OUT: out integer range 0 to PC_MAX;
		--Fetched instruction
		INSTR: out std_logic_vector(31 downto 0)
		);
	
	end component;

begin

	IF_ST: IF_STAGE port map(
		--INPUT
		--Clock signal
		CLOCK,
		--PC reset signal
		IF_PC_RESET,
		--PC output selection
		IF_PC_SELECT,
		--Alt. PC from the ALU
		IF_PC_ALU,
		
		--OUTPUT
		--PC output
		IF_PC_OUT,
		--Fetched instruction
		IF_INSTR_OUT
	);

	

end architecture;