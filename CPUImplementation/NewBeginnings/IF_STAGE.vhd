library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_STAGE is

		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Reset signal
			RESET: in std_logic;
			--PC MUX select signal
			PC_SEL: in std_logic;
			--Feedback from ALU for PC calc.
			ALU_PC: in integer range 0 to 1023;
			
			--OUTPUT
			--PC output
			PC_OUT: out integer range 0 to 1023 := 0;
			--Fetched instruction
			INSTR: out std_logic_vector(31 downto 0) := (others => '0')
		);
	
end entity;

architecture IF_STAGE_Impl of IF_STAGE is

	--Intermediate signals and constants
	
	--Stage constants
	constant ADDR_MAX: integer := 1024;
	constant PC_MAX: integer := 1024;
	
	--Instruction memory addr.
	signal IR_ADDR: integer range 0 to ADDR_MAX-1 := 0;
	
	--Fetched instruction.
	signal IR_OUT: std_logic_vector(31 downto 0) := (others => '0');
	
	--Memory stall request.
	signal MEM_STALL: std_logic;
	
	--Program counter memory.
	signal PC_REG: integer range 0 to PC_MAX-1 := 0;
	
	--Program counter output.
	signal PC_OUTPUT: integer range 0 to PC_MAX-1 := 0;
	
	--Memory read allow
	signal INSTR_FEED: std_logic := '1';

	--Subcomponent instantiation
	
	--Instruction memory
	
	component memory is
	
		GENERIC(
		ram_size : INTEGER := ADDR_MAX;
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns;
		from_file : boolean := true;		
		file_in : string := "program.txt";
		to_file : boolean := false;
		file_out : string := "output.txt";
		sim_limit : time := 10 ns
	);
		PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO ram_size-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
	
	end component;

begin

	IR: memory port map(
		--INPUT
		--Clock signal
		CLOCK,
		--Data in (DISABLED)
		std_logic_vector(to_unsigned(0,32)),
		--Data addr.
		IR_ADDR,
		--Memory write perm. (DISABLED)
		'0',
		--Memory read perm.
		INSTR_FEED,
		
		--OUTPUT
		--Data out
		IR_OUT,
		--Stall signal
		MEM_STALL		
	);
	
	STAGE_BEHAVIOUR: process(CLOCK)
	
		variable INCREMENTED_PC: integer range 0 to PC_MAX-1;
		variable DONE: boolean := false;
		
		variable UNDEF: std_logic_vector(31 downto 0) := (others => 'Z');
	
	begin
	
		--Asynchronous reset for the program counter.
		if RESET = '1' then
			
			PC_OUTPUT <= 0;
			INSTR_FEED <= '0';
			
			report "IF: Program counter reset.";
		
		--Detects the end of the program.
		elsif now >= 1 ps and IR_OUT = UNDEF and not DONE then
			
			DONE := true;
			
			report "IF: Reached end of program.";
	
		elsif rising_edge(CLOCK) and not DONE then
		
			INSTR_FEED <= '1';
			
			--Incrementing the PC to the next value.
			INCREMENTED_PC := PC_REG + 1;
			
			--Feeding the current PC into the instr. memory to fetch.
			IR_ADDR <= PC_REG;
			
			--Multiplexer output to select PC output source.
			if PC_SEL = '0' then
				PC_OUTPUT <= INCREMENTED_PC;
			else
				PC_OUTPUT <= ALU_PC;
			end if;
			
			report "IF: PC increment.";
		
		end if;
	
	end process;
	
	--Setting the output signals.
	PC_OUT <= PC_OUTPUT;
	PC_REG <= PC_OUTPUT;
	INSTR <= IR_OUT when INSTR_FEED = '1' else
		(others => 'Z');

end architecture;