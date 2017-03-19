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
	
	signal ID_PC_IN, ID_INSTR_IN: std_logic_vector(31 downto 0) := (others => '0');
	
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
	
	

end architecture;