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
	
	ID_WRITE_REG <= ID_INSTR_IN(15 downto 11);
	
	

end architecture;