library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR is
	
	port(
		CLOCK: in std_logic
	);

end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR is

	--IF Signals--
	signal MEM_PC_SRC : std_logic;
	signal MEM_PC, IF_PC, IF_INSTR : std_logic_vector(31 downto 0);
	
	--Definition of IF component--
	component IF_STAGE port(
		--Inputs--
		CLOCK: in std_logic;
		RESET: in std_logic;
		---Control Signals---
		PC_SRC: in std_logic; --MUX select
		ALU_PC: in std_logic_vector(31 downto 0); --One of the MUX inputs
		--Outputs--
		PC_OUT: out std_logic_vector(31 downto 0);
		INSTR: out std_logic_vector(31 downto 0)
	);
	end component;

	--Definition of IF/ID component--
	component IF_ID_REGISTER port(
		--Inputs--
		PC_IN,
	        INSTRUCTION_IN : in std_logic_vector(31 downto 0);

	        REG_WRITE_IN: in std_logic_vector(4 downto 0);
	        --Outputs--
	        PC_OUT,
	        INSTRUCTION_OUT : out std_logic_vector(31 downto 0)
		);
	end component;

	--ID Signals--
	signal ID_INSTR_IN : std_logic_vector(31 downto 0);
	signal ID_PC_IN : std_logic_vector(31 downto 0);
	signal WB_REG : std_logic_vector(4 downto 0);
	signal WB_DATA : std_logic_vector(31 downto 0);
	signal EX_HILO : std_logic_vector(63 downto 0);
	signal MEM_REG_WRITE : std_logic;
	signal ID_CONTROL_OUT : std_logic_vector(9 downto 0);
	signal ID_INSTR : std_logic_vector(31 downto 0);
	signal ID_REG : std_logic_vector(4 downto 0);
	signal ID_PC : std_logic_vector(31 downto 0);
	signal ID_SIGN_EXTENDED : std_logic_vector(31 downto 0);
	signal ID_REG1 : std_logic_vector(31 downto 0);
	signal ID_REG2 : std_logic_vector(31 downto 0);

	--Definition of ID component--
	component ID port(
        
	---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WB_REG_IN : std_logic_vector (4 downto 0);
        WB_DATA : in std_logic_vector (31 downto 0);
        WB_HILO : in std_logic_vector(63 downto 0);

        --Control Signals In--
        CONTROL_REG_WRITE_IN : in std_logic;

        ---Control Signals---
        CONTROL_OUT : out std_logic_vector(9 downto 0);

        ---Data Outputs---
        INSTRUCTION_OUT :out std_logic_vector(31 downto 0);
        WB_REG_OUT : out std_logic_vector(4 downto 0);

        PC_OUT : out std_logic_vector (31 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
	);

	end component;
	
	component ID_EX_REGISTER port(
		--Inputs--
		--CLOCK SIGNAL--
        	CLOCK: in std_logic;
		--CONTROL SIGNALS IN--
		CONTROL_IN: in std_logic_vector(9 downto 0);
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
		REG_OUT2 : out std_logic_vector(31 downto 0);
		--INSTRUCTION OUT--
		INSTR_OUT: out std_logic_vector(31 downto 0)

	);
	end component;


	--EX Signals Here--
	signal EX_A,EX_B,EX_I,EX_Ins,EX_PC,EX_R,EX_FB,EX_FIns: std_logic_vector(31 downto 0);
	signal EX_ALUCTRL: std_logic_vector(3 downto 0);
	signal EX_SEL1, EX_SEL2, EX_BRANCH: std_logic;
	signal EX_R64: std_logic_vector(63 downto 0);
	signal EX_CONTROL_IN: std_logic_vector(9 downto 0);

	component EX_STAGE
		port(
			A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
			ALU_CONTROL: in std_logic_vector(3 downto 0);
			SELECTOR1, SELECTOR2: in std_logic;
			BRANCH: out std_logic;
			R,FB,FIns: out std_logic_vector(31 downto 0);
			R_64: out std_logic_vector(63 downto 0)
		);
	end component;

	


begin

	IF_ST : IF_STAGE port map(
		--Inputs--
		CLOCK,
		'0',
		MEM_PC_SRC,
		MEM_PC,
		--Outputs
		IF_PC,
		IF_INSTR
	);

	IF_ID_REG : IF_ID_REGISTER port map(
		--Inputs--
		IF_PC,
		IF_INSTR,
		ID_PC,
		ID_INSTR

	);


	--Creating instance of ID component and mapping signals--
	ID_ST : ID port map(
		--Inputs--
		CLOCK,
		ID_INSTR,
		ID_PC,
		WB_REG,
		WB_DATA,
		EX_HILO,
		--Control Signals In--
		MEM_REG_WRITE,
		--Control Signals Out--
		ID_CONTROL_OUT,
		--Outputs--
		ID_INSTR,
		ID_REG,
		ID_PC,
		ID_SIGN_EXTENDED,
		ID_REG1,
		ID_REG2
	);

	ID_EX_REG : ID_EX_REGISTER port map(
		--Inputs--
		CLOCK,
		ID_CONTROL_OUT,
		ID_PC,
		ID_SIGN_EXTENDED,
		ID_REG1,
		ID_REG2,
		ID_INSTR,
		EX_CONTROL_IN,
		EX_PC_IN,
		EX_SIGN_EXTENDED_IN,
		EX_REG1_IN,
		EX_REG2_IN,
		EX_INSTR_IN
	);

	EX_ST : EX_STAGE port map(
		EX_A,
		EX_B,
		EX_I,
		EX_Ins,
		EX_PC,
		EX_CONTROL_IN(3 downto 0),
		EX_SEL1,
		EX_SEL2,
		EX_BRANCH,
		EX_R,
		EX_FB,
		EX_FIns,
		EX_R64
	);



	process(CLOCK)

	begin

	end process;

end architecture;