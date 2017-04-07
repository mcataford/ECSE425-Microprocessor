library IEEE;

use ieee.std_logic_1164.all;

entity CPU is
	port(
		CLOCK: in std_logic;
		RESET: in std_logic
	);
	
end entity;

architecture CPU_Impl of CPU is

	--Intermediate signals and constants
	
	--CPU constants
	constant PC_MAX: integer := 1024;
	constant REG_COUNT: integer := 32;
	
	--IF stage specific
	signal IF_PC_RESET, IF_PC_SELECT: std_logic;
	signal IF_PC_ALU, IF_PC: integer range 0 to PC_MAX-1;
	signal IF_INSTR: std_logic_vector(31 downto 0);
	
	--ID stage specific
	signal ID_PC: integer range 0 to PC_MAX-1;
	signal ID_REG_A,ID_REG_B,ID_IMMEDIATE,ID_WB_DATA: integer;
	signal ID_INSTR: std_logic_vector(31 downto 0);
	signal ID_WB_SRC: integer range 0 to REG_COUNT-1;
	signal ID_CONTROL_VECTOR, ID_ALU_CONTROL_VECTOR: std_logic_vector(7 downto 0);  


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
	
	component ID_STAGE
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			--Writeback source
			WB_SRC: in integer range 0 to REG_COUNT-1;
			--Writeback data
			WB_DATA: in integer;
			
			--OUTPUT
			--Register A
			REG_A: out integer;
			--Register B
			REG_B: out integer;
			--Sign-extended immediate
			IMMEDIATE: out integer;
			--Control signals
			CONTROL_VECTOR: out std_logic_vector(7 downto 0);
			--ALU control signals
			ALU_CONTROL_VECTOR: out std_logic_vector(7 downto 0)
		);
	
	end component;
	
	--Interstage registers
	
	component IF_ID_REG
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--Program counter
			IF_PC: in integer range 0 to 1023;
			--Instruction
			IF_INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Program counter
			ID_PC: out integer range 0 to 1023;
			--Instruction
			ID_INSTR: out std_logic_vector(31 downto 0)
		);
	end component;

begin

	--Stages and registers, in order.

	IF_ST: IF_STAGE port map(
		--INPUT
		--Clock signal
		CLOCK,
		--PC reset signal
		RESET,
		--PC output selection
		--IF_PC_SELECT,
		'0',
		--Alt. PC from the ALU
		IF_PC_ALU,
		
		--OUTPUT
		--PC output
		IF_PC,
		--Fetched instruction
		IF_INSTR
	);
	
	IF_ID_R: IF_ID_REG port map(
		--INPUT
		--Clock signal
		CLOCK,
		--Reset
		RESET,
		--Program counter
		IF_PC,
		--Instruction
		IF_INSTR,
		
		--OUTPUT
		--Program counter
		ID_PC,
		--Instruction
		ID_INSTR
	);
	
	ID_ST: ID_STAGE port map(
		--INPUT
		--Clock signal
		CLOCK,
		--Instruction
		ID_INSTR,
		--Writeback source
		ID_WB_SRC,
		--Writeback data
		ID_WB_DATA,
		
		--OUTPUT
		--Register A
		ID_REG_A,
		--Register B
		ID_REG_B,
		--Sign-extended immediate
		ID_IMMEDIATE,
		--Control signals
		ID_CONTROL_VECTOR,
		--ALU control signals
		ID_ALU_CONTROL_VECTOR
	);

end architecture;