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
			INSTR: out std_logic_vector(31 downto 0) := (others => 'Z')
		);
	
end entity;

architecture IF_STAGE_Impl of IF_STAGE is

	--Intermediate signals and constants
	
	--Stage constants
	constant PC_MAX: integer := 1024;
	
	--Instruction memory addr.
	signal IR_ADDR: integer range 0 to PC_MAX-1 := 0;
	
	--Fetched instruction.
	signal IR_OUT: std_logic_vector(31 downto 0) := (others => '0');
	
	--Memory stall request.
	signal IR_MEMSTALL: std_logic;
	
	--Program counter memory.
	signal PC_REG: integer range 0 to PC_MAX-1 := 0;
	
	--Memory read allow
	signal IR_MEMREAD: std_logic := '0';

	--Subcomponent instantiation
	
	--Instruction memory
	
	component memory is
	
		GENERIC(
		ram_size : INTEGER := PC_MAX;
		mem_delay : time := 2 ns;
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
		IR_MEMREAD,
		
		--OUTPUT
		--Data out
		IR_OUT,
		--Stall signal
		IR_MEMSTALL		
	);
	
	FSM: process(CLOCK)
	
		--State variables
		variable CURRENT_STATE: integer range 0 to 2 := 0;
		variable NEXT_STATE: integer range 0 to 2 := 0;
		
		--Temporary PC buffer
		variable PC_INCREMENT: integer range 0 to PC_MAX-1 := 0;
		
		--End-of-program flag
		variable EOP: boolean := false;
		
		--EOP pattern
		variable UNDEF: std_logic_vector(31 downto 0) := (others => 'Z');
	
	begin
	
		if rising_edge(CLOCK) then
			--State switch.
			CURRENT_STATE := NEXT_STATE;
		
			case CURRENT_STATE is
			
				when 0 =>
					PC_INCREMENT := PC_REG + 1;
					
					IR_ADDR <= PC_REG;
					IR_MEMREAD <= '1';
					
					NEXT_STATE := 1;
					
					report "IF: FSM S1 - Memory request sent.";
					
				when 1 =>
					if IR_MEMSTALL = '0' then
					
						if IR_OUT = UNDEF then
						
							EOP := true;
							INSTR <= (others => 'Z');
							
							NEXT_STATE := 2;
							
							report "IF: FSM S2 - End of program. Stopping feed.";
						
						else
							INSTR <= IR_OUT;
							
							if PC_SEL = '0' then
								PC_REG <= PC_INCREMENT;
								PC_OUT <= PC_INCREMENT;
							else
								PC_REG <= ALU_PC;
								PC_OUT <= ALU_PC;
							end if;
							
							IR_MEMREAD <= '0';
							
							NEXT_STATE := 0;
							
							report "IF: FSM S2 - Memory request fulfilled. Posted output.";
							
						end if;
						
					else
					
						report "IF: FSM S2 - Waiting on request fulfillment.";
						
					end if;
					
				when 2 =>
					
					
					
			end case;
		
		end if;
	
	end process;
	
	
	


end architecture;