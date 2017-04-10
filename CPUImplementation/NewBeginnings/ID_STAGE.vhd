library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_STAGE is
	
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
		
		--OUTPUT
		--Register A
		REG_A: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Register B
		REG_B: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Sign-extended immediate
		IMMEDIATE: out std_logic_vector(31 downto 0) := (others => 'Z');
		--Control signals
		CONTROL_VECTOR: out std_logic_vector(7 downto 0) := (others => 'Z')
	);
	
end entity;

architecture ID_STAGE_Impl of ID_STAGE is

	--Intermediate signals and constants
	
	--Register count
	constant REG_COUNT_MAX: integer := 32;
	
	--Register file
	type REGISTER_FILE is array (REG_COUNT_MAX-1 downto 0) of std_logic_vector(31 downto 0);
	signal REG: REGISTER_FILE := (others => (others => '0'));
	
	--Subcomponent instantiation
	
	component ID_CONTROL_UNIT
		
		port (
			--INPUT
			--Opcode segment
			OPCODE: in std_logic_vector(5 downto 0);
			--Funct segment
			FUNCT: in std_logic_vector(5 downto 0);
			
			--OUTPUT
			--Control signals
			CONTROL_VECTOR: out std_logic_vector(7 downto 0)
		);
		
	end component;

begin

	--Control unit
	CU: ID_CONTROL_UNIT port map(
		--INPUT
		--Opcode
		INSTR(31 downto 26),
		--Funct
		INSTR(5 downto 0),
		
		--OUTPUT
		--Control signals
		CONTROL_VECTOR
	);
	
	--R[0] is locked at 0.
	REG(0) <= (others => '0');
	
	REGISTER_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if rising_edge(CLOCK) then
		
		
		elsif falling_edge(CLOCK) then
		
				if INSTR /= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" then
				
					REG_A <= REG(to_integer(unsigned(INSTR(25 downto 21))));
					REG_B <= REG(to_integer(unsigned(INSTR(20 downto 16))));
					
				end if;
				
		end if;
	
	end process;
	

end architecture;