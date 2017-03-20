library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR is
	
	port(
		CLOCK: in std_logic
	);

end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR is

	--Intermediate signals : IF STAGE--
	
	signal IF_RESET, IF_PC_SRC: std_logic := '0';
	signal IF_ALU_PC, IF_PC_OUT, IF_INSTR_OUT: std_logic_vector(31 downto 0) := (others => '0');

	--Intermediate signals : ID STAGE--
	
	signal ID_CONTROL_REG_WRITE : std_logic := '0';
	signal ID_PC_IN, ID_INSTR_IN, ID_WRITE_DATA,ID_INSTR_OUT,ID_PC_OUT,ID_SIGN_OUT,ID_REGA_OUT, ID_REGB_OUT: std_logic_vector(31 downto 0) := (others => '0');
	signal ID_WRITE_HILO : std_logic_vector(63 downto 0) := (others => '0');
	signal ID_READ_OUT, ID_WRITE_REG : std_logic_vector(4 downto 0) := (others => '0');
	signal ID_CONTROL_OUT : std_logic_vector(9 downto 0) := (others => '0');
	
	--Intermediate signals : EX STAGE--
	
	signal EX_CONTROL_IN: std_logic_vector(9 downto 0);
	signal EX_PC_IN, EX_SIGN_IN, EX_REGA_IN, EX_REGB_IN, EX_INSTR_IN, EX_R32_OUT, EX_B_OUT, EX_INSTR_OUT: std_logic_vector(31 downto 0);
	signal EX_R64_OUT : std_logic_vector(63 downto 0);
	signal EX_SELA_IN,EX_SELB_IN,EX_BRANCH_OUT : std_logic := '0';
	
	--Intermediate signals : MEM STAGE--
	
	signal MEM_B_IN, MEM_R32_IN, MEM_INSTR_IN: std_logic_vector(31 downto 0);
	signal MEM_R64_IN: std_logic_vector(63 downto 0);
	signal MEM_BRANCH_IN: std_logic;
	signal MEM_DATA_OUT, MEM_INSTR_OUT, MEM_B_OUT: std_logic_vector(31 downto 0);
	signal MEM_CONTROL : std_logic_vector(1 downto 0) := (others => '0');
	
	--Intermediate signals : WB STAGE--
	signal WB_DATA_IN,WB_INSTR_IN,WB_B_IN: std_logic_vector(31 downto 0);
	signal WB_R64_IN: std_logic_vector(63 downto 0);
	
	component IF_STAGE

		port(
			--INPUT--
			--Clock signal--
			CLOCK: in std_logic;
			--Reset signal--
			RESET: in std_logic;
			--PC MUX select signal--
			PC_SRC: in std_logic;
			--Feedback from ALU for PC calc.--
			ALU_PC: in std_logic_vector(31 downto 0);
			--OUTPUT--
			--PC output--
			PC_OUT,
			--Fetched instruction--
			INSTR: out std_logic_vector(31 downto 0) := (others => '0')
		);

	end component;

	component IF_ID_REGISTER
	
    port(
        --Inputs--
				CLOCK: in std_logic; 
        PC_IN,
        INSTR_IN : in std_logic_vector(31 downto 0);
        --Outputs--
        PC_OUT,
        INSTR_OUT : out std_logic_vector(31 downto 0):= (others => '0')
    );
		
	end component;
	
	component ID
	
	    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION_IN : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WRITE_REG : std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        WRITE_HILO : in std_logic_vector(63 downto 0);
        --Control Signals In--
        CONTROL_REG_WRITE_IN : in std_logic;
        ---Control Signals Out---
        CONTROL_VECTOR : out std_logic_vector(9 downto 0);
        ---Data Outputs---
        INSTRUCTION_OUT : out std_logic_vector(31 downto 0);
        PC_OUT : out std_logic_vector (31 downto 0);
        RD_OUT : out std_logic_vector(4 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    );
	
	end component;
	
	component ID_EX_REGISTER
	 port(
						--Inputs--
						
			--CLOCK SIGNAL--
						CLOCK: in std_logic;

			--CONTROL SIGNALS IN--
			CONTROL_IN: in std_logic_vector(9 downto 0);
		--
						--PROGRAM COUNTER IN--
			PC_IN,

						--SIGN EXTENDER IN--
			SIGN_EXTENDER_IN,

						--REGISTER DATA IN--
			REG_IN1,
						REG_IN2 : in std_logic_vector(31 downto 0);
			
			--INSTRUCTION IN--
			INSTR_IN: in std_logic_vector(31 downto 0);

						--Outputs--
						--CONTROL SIGNALS OUT--
			CONTROL_OUT: out std_logic_vector(9 downto 0);

			--PROGRAM COUNTER OUT--
						PC_OUT,
			
			--SIGN EXTENDER OUT--
						SIGN_EXTENDER_OUT,

			--REGISTER DATA OUT--
						REG_OUT1,
						REG_OUT2 : out std_logic_vector(31 downto 0) := (others => '0');
			
			--INSTRUCTION OUT--
			INSTR_OUT: out std_logic_vector(31 downto 0)

    );
	end component;
	
	component EX_STAGE
	
		port(
			--INPUT--
			--ALU operands
			A,B,
			--Immediate--
			IMM,
			--Instruction forward--
			INSTR_IN,
			--PC forward--
			PC_IN: in std_logic_vector(31 downto 0);
			--Control signal ALUOP--
			ALU_CONTROL: in std_logic_vector(3 downto 0);
			--Multiplexer control--
			SELECTOR1, 
			SELECTOR2: in std_logic;
			--OUTPUT--
			--Branch Taken--
			BRANCH: out std_logic;
			--ALU 32b out--
			R,
			--Operand B forward--
			B_OUT,
			--Instruction forward--
			INSTR_OUT: out std_logic_vector(31 downto 0);
			--ALU 64b out--
			R_64: out std_logic_vector(63 downto 0)
		);
		
	end component;
	
	component EX_MEM_REGISTER
		port(
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Branch selection--
		BRANCH_IN: in std_logic;
		--ALU 32b out--
		R_IN,
		--Operand B forward--
		B_FORWARD_IN,
		--Instruction forward--
		INSTR_IN: in std_logic_vector(31 downto 0);
		--ALU 64b out--
		R_64_IN: in std_logic_vector(63 downto 0);
		--OUTPUT--
		--Branch selection--
		BRANCH_OUT: out std_logic := '0';
		--ALU 32b out--
		R_OUT,
		--Operand B forward--
		B_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT: out std_logic_vector(31 downto 0) := (others => '0');
		--Alu 64b out--
		R_64_OUT: out std_logic_vector(63 downto 0) := (others => '0')
		
	);
	end component;
	
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
			MEM_CONTROL: in std_logic_vector(1 downto 0);
			--OUTPUT--
			--Data output--
			DATA_OUT,
			--Data forward--
			DATA_FORWARD_OUT,
			--Instruction forward--
			INSTR_OUT : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component MEM_WB_REGISTER
	
		port (
			CLOCK: in std_logic;
			DATA_IN, INSTR_IN, B_FORWARD_IN : in std_logic_vector(31 downto 0);
			DATA_OUT, INSTR_OUT, B_FORWARD_OUT : out std_logic_vector(31 downto 0);
			DATA64_IN: in std_logic_vector(63 downto 0);
			DATA64_out: out std_logic_vector(63 downto 0)
		);
	
	end component;
	
begin

	--IF STAGE instantiation--
	IF_ST : IF_STAGE port map(
		CLOCK,
		IF_RESET,
		IF_PC_SRC,
		IF_ALU_PC,
		IF_PC_OUT,
		IF_INSTR_OUT
	);
	
	--IF-ID interstage register--
	IF_ID_REG : IF_ID_REGISTER port map(
		CLOCK,
		IF_PC_OUT,
		IF_INSTR_OUT,
		ID_PC_IN,
		ID_INSTR_IN
	);
	
	ID_ST : ID port map(
		CLOCK,
		ID_INSTR_IN,
		ID_PC_IN,
		ID_WRITE_REG,
		ID_WRITE_DATA,
		ID_WRITE_HILO,
		ID_CONTROL_REG_WRITE,
		ID_CONTROL_OUT,
		ID_INSTR_OUT,
		ID_PC_OUT,
		ID_READ_OUT,
		ID_SIGN_OUT,
		ID_REGA_OUT,
		ID_REGB_OUT
	);
	
	ID_EX_REG : ID_EX_REGISTER port map(
		CLOCK,
		ID_CONTROL_OUT,
		ID_PC_OUT,
		ID_SIGN_OUT,
		ID_REGA_OUT,
		ID_REGB_OUT,
		ID_INSTR_OUT,
		EX_CONTROL_IN,
		EX_PC_IN,
		EX_SIGN_IN,
		EX_REGA_IN,
		EX_REGB_IN,
		EX_INSTR_IN
	);
	
	EX_ST : EX_STAGE port map(
		EX_REGA_IN,
		EX_REGB_IN,
		EX_SIGN_IN,
		EX_INSTR_IN,
		EX_PC_IN,
		EX_CONTROL_IN(9 downto 6),
		EX_SELA_IN,
		EX_SELB_IN,
		EX_BRANCH_OUT,
		EX_R32_OUT,
		EX_B_OUT,
		EX_INSTR_OUT,
		EX_R64_OUT
	);
	
	EX_MEM_REG : EX_MEM_REGISTER port map(
		CLOCK,
		EX_BRANCH_OUT,
		EX_R32_OUT,
		EX_B_OUT,
		EX_INSTR_OUT,
		EX_R64_OUT,
		MEM_BRANCH_IN,
		MEM_R32_IN,
		MEM_B_IN,
		MEM_INSTR_IN, 
		MEM_R64_IN
	);
	
	MEM_ST : MEM_STAGE port map(
		CLOCK,
		MEM_R32_IN,
		MEM_B_IN,
		MEM_INSTR_IN,
		MEM_CONTROL,
		MEM_DATA_OUT,
		MEM_B_OUT,
		MEM_INSTR_OUT
	);
	
	MEM_WB_REG : MEM_WB_REGISTER port map(
		CLOCK,
		MEM_DATA_OUT,
		MEM_INSTR_OUT,
		MEM_B_OUT,
		WB_DATA_IN,
		WB_INSTR_IN,
		WB_B_IN,
		MEM_R64_IN,
		WB_R64_IN
	);
	
	
	EX_SELA_IN <= '0';
	EX_SELB_IN <= EX_CONTROL_IN(4);
	
	ID_WRITE_REG <= ID_INSTR_IN(15 downto 11);
	
	

end architecture;