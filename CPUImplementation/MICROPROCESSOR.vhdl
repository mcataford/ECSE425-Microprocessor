library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR is
	port(
	CLOCK: in std_logic
	);

end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR is

	--EX Signals Here--

	signal EX_A,EX_B,EX_I,EX_Ins,EX_PC,EX_R,EX_FB,EX_FIns: std_logic_vector(31 downto 0);
	signal EX_ALUCTRL: std_logic_vector(3 downto 0);
	signal EX_SEL1, EX_SEL2, EX_BRANCH: std_logic;
	signal EX_R64: std_logic_vector(63 downto 0);

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

	--ID Signals Here--
	signal ID_CONTROL_BRANCH, ID_CONTROL_MEM_TO_REG, ID_CONTROL_MEM_READ : std_logic;
	signal ID_CONTROL_MEM_WRITE, ID_CONTROL_ALU_SRC : std_logic;
	signal ID_PC_OUT, ID_SIGN_EXTENDED_OUT, ID_REG_OUT1, ID_REG_OUT2 : std_logic_vector(31 downto 0);
	signal ID_INSTRUCTION, ID_PC_IN, ID_WB_DATA : std_logic_vector(31 downto 0);
	signal ID_HILO_DATA: std_logic_vector(63 downto 0);
	signal ID_CONTROL_ALU_OP: std_logic_vector(3 downto 0);

	--Definition of ID component--
	component ID port(
		---Inputs---
		CLOCK : in std_logic;
		INSTRUCTION : in std_logic_vector (31 downto 0);
		PC_IN : in std_logic_vector (31 downto 0);
		WB_DATA : in std_logic_vector (31 downto 0);
		WB_HILO : in std_logic_vector(63 downto 0);
		---Control Signals---
		CONTROL_BRANCH : out std_logic;
		CONTROL_MEM_TO_REG : out std_logic;
		CONTROL_MEM_READ : out std_logic;
		CONTROL_ALU_OP : out std_logic_vector(3 downto 0);
		CONTROL_MEM_WRITE : out std_logic;
		CONTROL_ALU_SRC : out std_logic;
		---Data Outputs---
		PC_OUT : out std_logic_vector (31 downto 0);
		SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
		REG_OUT1 : out std_logic_vector (31 downto 0);
		REG_OUT2 : out std_logic_vector (31 downto 0)
		);
	end component;

begin

	--Creating instance of ID component and mapping signals--
	ID_ST : ID port map(
		--Inputs--
		CLOCK,
		ID_INSTRUCTION,
		ID_PC_IN,
		ID_WB_DATA,
		ID_HILO_DATA,
		--Control Signals--
		ID_CONTROL_BRANCH,
		ID_CONTROL_MEM_TO_REG,
		ID_CONTROL_MEM_READ,
		ID_CONTROL_ALU_OP,
		ID_CONTROL_MEM_WRITE,
		ID_CONTROL_ALU_SRC,
		--Outputs--
		ID_PC_OUT,
		ID_SIGN_EXTENDED_OUT,
		ID_REG_OUT1,
		ID_REG_OUT2
	);

	EX_ST : EX_STAGE port map(
		EX_A,
		EX_B,
		EX_I,
		EX_Ins,
		EX_PC,
		EX_ALUCTRL,
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