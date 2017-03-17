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
	signal ID_CONTROL_VECTOR_OUT : std_logic_vector(9 downto 0);
	signal ID_DATA_OUT : std_logic_vector(132 downto 0);
	signal ID_DATA_IN : std_logic_vector(164 downto 0);
	signal ID_CONTROL_VECTOR_IN : std_logic;
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
        CONTROL_BRANCH_OUT,
        CONTROL_MEM_READ_OUT,
        CONTROL_MEM_TO_REG_OUT,
        CONTROL_MEM_WRITE_OUT,
        CONTROL_ALU_SRC_OUT,
        CONTROL_REG_WRITE_OUT : out std_logic;
        CONTROL_ALU_OP : out std_logic_vector(3 downto 0);
        ---Data Outputs---
        WB_REG_OUT : out std_logic_vector(4 downto 0);
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
		ID_DATA_IN(164 downto 133),
		ID_DATA_IN(132 downto 101),
		ID_DATA_IN(100 downto 96),
		ID_DATA_IN(95 downto 64),
		ID_DATA_IN(63 downto 0),
		--Control Signals In--
		ID_CONTROL_VECTOR_IN,
		--Control Signals Out--
		ID_CONTROL_VECTOR_OUT(0),
		ID_CONTROL_VECTOR_OUT(1),
		ID_CONTROL_VECTOR_OUT(2),
		ID_CONTROL_VECTOR_OUT(3),
		ID_CONTROL_VECTOR_OUT(4),
		ID_CONTROL_VECTOR_OUT(5),
		ID_CONTROL_VECTOR_OUT(9 downto 6),
		--Outputs--
		ID_DATA_OUT(132 downto 128),
		ID_DATA_OUT(127 downto 96),
		ID_DATA_OUT(95 downto 64),
		ID_DATA_OUT(63 downto 32),
		ID_DATA_OUT(31 downto 0)
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