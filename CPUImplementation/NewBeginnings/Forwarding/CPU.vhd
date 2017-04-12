library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	signal IF_PC_RESET, IF_PC_SELECT: std_logic := '0';
	signal IF_PC_ALU, IF_PC: std_logic_vector(31 downto 0) := (others => '0');
	signal IF_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
	
	--ID stage specific
	signal ID_PC: std_logic_vector(31 downto 0) := (others => '0');
	signal ID_REG_A,ID_REG_B,ID_IMMEDIATE,ID_WB_DATA: std_logic_vector(31 downto 0) := (others => '0');
	signal ID_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
	signal ID_WB_SRC: std_logic_vector(31 downto 0) := (others => '0');
	signal ID_CONTROL_VECTOR: std_logic_vector(11 downto 0) := (others => '0');
	signal ID_REGWRITE: std_logic;

	--EX stage specific
	signal EX_PC: std_logic_vector(31 downto 0) := (others => '0');
	signal EX_REG_A,EX_REG_B,EX_IMMEDIATE: std_logic_vector(31 downto 0) := (others => '0');
	signal EX_INSTR: std_logic_vector(31 downto 0) := (others => 'Z');
	signal EX_CONTROL_VECTOR: std_logic_vector(11 downto 0) := (others => '0');
	signal EX_R: std_logic_vector(63 downto 0) := (others => '0');
	
	signal MUX_SEL_A, MUX_SEL_B : std_logic_vector(1 downto 0);
	signal MUX_OUT_A, MUX_OUT_B : std_logic_vector(31 downto 0);
	
	--MEM stage specific
	signal MEM_PC: std_logic_vector(31 downto 0) := (others => '0');
	signal MEM_R: std_logic_vector(63 downto 0) := (others => '0');
	signal MEM_INSTR: std_logic_vector(31 downto 0) := (others => '0');
	signal MEM_B_FW: std_logic_vector(31 downto 0) := (others => '0');
	signal MEM_CONTROL_VECTOR: std_logic_vector(11 downto 0) :=(others => '0');
	signal MEM_DATAREAD: std_logic_vector(31 downto 0) := (others => '0');
	
	--WB stage specific
	signal WB_DATA: std_logic_vector(31 downto 0) := (others => '0');
	signal WB_ADDR: std_logic_vector(31 downto 0) := (others => '0');
	signal WB_INSTR: std_logic_vector(31 downto 0) := (others => '0');
	signal WB_CONTROL_VECTOR: std_logic_vector(11 downto 0) := (others => '0');

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
		ALU_PC: in std_logic_vector(31 downto 0);
		
		--OUTPUT
		--PC output
		PC_OUT: out std_logic_vector(31 downto 0);
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
			WB_SRC: in std_logic_vector(31 downto 0);
			--Writeback data
			WB_DATA: in std_logic_vector(31 downto 0);
			REGWRITE: in std_logic;
			
			--OUTPUT
			--Register A
			REG_A: out std_logic_vector(31 downto 0) := (others => '0');
			--Register B
			REG_B: out std_logic_vector(31 downto 0) := (others => '0');
			--Sign-extended immediate
			IMMEDIATE: out std_logic_vector(31 downto 0) := (others => '0');
			--Control signals
			CONTROL_VECTOR: out std_logic_vector(11 downto 0)
		);
	
	end component;
	
	component EX_STAGE
	
		port (
			--INPUT
			--Program counter
			PC: in std_logic_vector(31 downto 0) := (others => '0');
			--Operands
			A: in std_logic_vector(31 downto 0) := (others => '0');
			B: in std_logic_vector(31 downto 0) := (others => '0');
			Imm: in std_logic_vector(31 downto 0) := (others => '0');
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Results
			R: out std_logic_vector(63 downto 0) := (others => '0')
		);
	
	end component;
	
	component MEM_STAGE
	
		port(
			--INPUT
			--Clock
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			--Results from ALU
			DATA_ADDRESS: in std_logic_vector(31 downto 0);
			--B fwd
			DATA_PAYLOAD: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			DATA_OUT: out std_logic_vector(31 downto 0)
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
			IF_PC: in std_logic_vector(31 downto 0);
			--Instruction
			IF_INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Program counter
			ID_PC: out std_logic_vector(31 downto 0) := (others => '0');
			--Instruction
			ID_INSTR: out std_logic_vector(31 downto 0)
		);
	end component;
	
	component ID_EX_REG
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--Program counter
			ID_PC: in std_logic_vector(31 downto 0);
			--Instruction
			ID_INSTR: in std_logic_vector(31 downto 0);
			--Register values
			ID_REG_A: in std_logic_vector(31 downto 0);
			ID_REG_B: in std_logic_vector(31 downto 0);
			--Immediate
			ID_IMMEDIATE: in std_logic_vector(31 downto 0);
			--Control signals
			ID_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			
			--OUTPUT
			EX_PC: out std_logic_vector(31 downto 0);
			--Instruction
			EX_INSTR: out std_logic_vector(31 downto 0);
			--Register values
			EX_REG_A: out std_logic_vector(31 downto 0);
			EX_REG_B: out std_logic_vector(31 downto 0);
			--Immediate
			EX_IMMEDIATE: out std_logic_vector(31 downto 0);
			--Control signals
			EX_CONTROL_VECTOR: out std_logic_vector(11 downto 0)
		);
	
	end component;
	
	component EX_MEM_REG
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			RESET: in std_logic;
			EX_PC: in std_logic_vector(31 downto 0);
			--Results
			EX_R: in std_logic_vector(63 downto 0);
			--Operand B forwarding
			EX_B_FW: in std_logic_vector(31 downto 0) := (others => '0');
			--Instruction
			EX_INSTR: in std_logic_vector(31 downto 0);
			--Control signals
			EX_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			
			--OUTPUT
			MEM_PC: out std_logic_vector(31 downto 0);
			--Results
			MEM_R: out std_logic_vector(63 downto 0);
			--Operand B forwarding
			MEM_B_FW: out std_logic_vector(31 downto 0);
			--Instruction
			MEM_INSTR: out std_logic_vector(31 downto 0);
			--Control signals
			MEM_CONTROL_VECTOR: out std_logic_vector(11 downto 0)
		);
	
	end component;
	
	component MEM_WB_REG
	
		port(
			--INPUT
			--Clock signal
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--PC
			MEM_DATA: in std_logic_vector(31 downto 0);
			MEM_ADDR: in std_logic_vector(31 downto 0);
			MEM_INSTR: in std_logic_vector(31 downto 0);
			MEM_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			
			WB_DATA: out std_logic_vector(31 downto 0);
			WB_ADDR: out std_logic_vector(31 downto 0);
			WB_INSTR: out std_logic_vector(31 downto 0);
			WB_CONTROL_VECTOR: out std_logic_vector(11 downto 0)
		);
	
	end component;

	component FORWARDING_UNIT
		port(
			--Inputs
			clock : in STD_LOGIC;
			EX_MEM_REGWRITE : in STD_LOGIC;
			MEM_WB_REGWRITE : in STD_LOGIC;
			ID_EX_RS : in STD_LOGIC_VECTOR(4 downto 0);
			ID_EX_RT : in STD_LOGIC_VECTOR(4 downto 0);
			EX_MEM_RD : in STD_LOGIC_VECTOR(4 downto 0);
			MEM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);
			--Outputs
			MUX_A : out STD_LOGIC_VECTOR(1 downto 0);
			MUX_B : out STD_LOGIC_VECTOR(1 downto 0)
		);
	end component;

	component MUX_4_TO_1 
		port(
			A,B,C: in std_logic_vector(31 downto 0);
			SELECTOR: in std_logic_vector(1 downto 0);
			OUTPUT: out std_logic_vector(31 downto 0)
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
		WB_CONTROL_VECTOR(3),
		
		--OUTPUT
		--Register A
		ID_REG_A,
		--Register B
		ID_REG_B,
		--Sign-extended immediate
		ID_IMMEDIATE,
		--Control signals
		ID_CONTROL_VECTOR
	);
	
	ID_EX_R: ID_EX_REG port map(
		--INPUT
		--Clock signal
		CLOCK,
		--Reset
		RESET,
		--Program counter
		ID_PC,
		--Instruction
		ID_INSTR,
		--Register values
		ID_REG_A,
		ID_REG_B,
		--Immediate
		ID_IMMEDIATE,
		--Control signals
		ID_CONTROL_VECTOR,
		
		--OUTPUT
		--Program counter
		EX_PC,
		--Instruction
		EX_INSTR,
		--Register values
		EX_REG_A,
		EX_REG_B,
		--Immediate
		EX_IMMEDIATE,
		--Control signals
		EX_CONTROL_VECTOR
	);
	
	MUX_A : MUX_4_TO_1 port map(
		--Normal output of ID/EX reg for ALU in A
		EX_REG_A,
		--Output of WB stage after the final multiplexer
		WB_DATA,
		--ALU output after it has been run through the EX/MEM reg
		MEM_R(31 downto 0),
		--The control signal produced by the forwarding unit found below
		MUX_SEL_A,
		--The output of this multiplexer, either from Register File, MEM forwarding, or WB forwarding
		MUX_OUT_A
	);

	MUX_B : MUX_4_TO_1 port map(
		--These are the same as that for MUX_A but with inputs B for the ALU
		EX_REG_B,
		WB_DATA,
		MEM_R(31 downto 0),
		MUX_SEL_B,
		MUX_OUT_B
	);

	EX_ST: EX_STAGE port map(
		--INPUT
		--Program counter
		EX_PC,
		--Operands
		--EX_REG_A,
		--EX_REG_B,
		MUX_OUT_A,
		MUX_OUT_B,
		EX_IMMEDIATE,
		--Control signals
		EX_CONTROL_VECTOR,
		--Instruction
		EX_INSTR,
		
		--OUTPUT
		--Results
		EX_R
	);

	FORWARD : FORWARDING_UNIT port map(
		CLOCK,
		--RegisterWrite control from EX/MEM reg
		MEM_CONTROL_VECTOR(3),
		--RegisterWrite control from MEM/WB reg
		WB_CONTROL_VECTOR(3),
		--Rs from instruction out of ID/EX reg
		EX_INSTR(25 downto 21),
		--Rt from instruction out of ID/EX reg
		EX_INSTR(20 downto 16), --Uncertain if 15 downto 11 or 25 downto 21
		--Rd from instruction out of EX/MEM reg
		MEM_INSTR(15 downto 11), --Uncertain if 15 downto 11 or 25 downto 21
		--Rd from instruction out of MEM/WB reg
		WB_INSTR(15 downto 11), --Same as above
		--Controlling output signals to two muxes that feed the EX_ST
		--found above the EX_ST component ^^^^^
		MUX_SEL_A,
		MUX_SEL_B
	);
	
	EX_MEM_R: EX_MEM_REG port map(
		--INPUT
		--Clock signal
		CLOCK,
		RESET,
		EX_PC,
		--Results
		EX_R,
		--Operand B forwarding
		EX_REG_B,
		--Instruction
		EX_INSTR,
		--Control signals
		EX_CONTROL_VECTOR,
		
		--OUTPUT
		MEM_PC,
		--Results
		MEM_R,
		--Operand B forwarding
		MEM_B_FW,
		--Instruction
		MEM_INSTR,
		--Control signals
		MEM_CONTROL_VECTOR
	
	);
	
	MEM_ST: MEM_STAGE port map(
		--INPUT
		--Clock
		CLOCK,
		--Reset
		RESET,
		--Control signals
		MEM_CONTROL_VECTOR,
		--Results from ALU
		MEM_R(31 downto 0),
		--B fwd
		MEM_B_FW,
		
		--OUTPUT
		MEM_DATAREAD
	);
	
	MEM_WB_R: MEM_WB_REG port map(
		--INPUT
		--Clock signal
		CLOCK,
		--Reset
		RESET,
		--PC
		MEM_DATAREAD,
		MEM_R(31 downto 0),
		MEM_INSTR,
		MEM_CONTROL_VECTOR,
		
		WB_DATA,
		WB_ADDR,
		WB_INSTR,
		WB_CONTROL_VECTOR
	);

	WB: process(CLOCK)
	
	begin
	
		if falling_edge(CLOCK) then
		
			if WB_CONTROL_VECTOR(2) = '1' then
		
				ID_WB_DATA <= WB_DATA;
		
			else 
			
				ID_WB_DATA <= WB_ADDR;
			
			end if;
			
			if WB_INSTR(31 downto 26) = "000000" then
				ID_WB_SRC(4 downto 0) <= WB_INSTR(15 downto 11);
			else
				ID_WB_SRC(4 downto 0) <= WB_INSTR(20 downto 16);
			end if;
				
			ID_WB_SRC(31 downto 5) <= (others => '0');
			
		end if;
		
	end process;

end architecture;