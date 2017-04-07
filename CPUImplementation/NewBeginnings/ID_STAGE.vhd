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
		WB_SRC: in integer range 0 to 31;
		--Writeback data
		WB_DATA: in integer;
		
		--OUTPUT
		--Register A
		REG_A: out integer := 0;
		--Register B
		REG_B: out integer := 0;
		--Sign-extended immediate
		IMMEDIATE: out integer := 0;
		--Control signals
		CONTROL_VECTOR: out std_logic_vector(7 downto 0) := (others => '0')
	);
	
end entity;

architecture ID_STAGE_Impl of ID_STAGE is

	--Intermediate signals and constants
	
	constant REG_COUNT_MAX: integer := 32;
	
	--Register file
	type REGISTER_FILE is array (REG_COUNT_MAX-1 downto 0) of integer;
	signal REG: REGISTER_FILE;
	
	--Instruction parsing
	signal RS,RT,RD,SHAMT: std_logic_vector(4 downto 0);
	signal OPCODE,FUNCT: std_logic_vector(5 downto 0);
	signal IMM: std_logic_vector(15 downto 0);
	signal ADDR: std_logic_vector(25 downto 0);
	
	signal CONTROL_VECTOR_INTERNAL: std_logic_vector(7 downto 0);
	
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

	CU: ID_CONTROL_UNIT port map(
		--INPUT
		--Opcode
		OPCODE,
		--Funct
		FUNCT,
		
		--OUTPUT
		--Control signals
		CONTROL_VECTOR_INTERNAL
	);

	STAGE_BEHAVIOUR: process(CLOCK)
	
		variable uOPCODE, uFUNCT: unsigned(5 downto 0);
		
		variable ZERO_EXT: std_logic_vector(15 downto 0) := (others => '0');
		variable ONE_EXT: std_logic_vector(15 downto 0) := (others => '0');
		variable UNDEF: std_logic_vector(31 downto 0) := (others => 'Z');
		
	
	begin
	
		if now >= 1 ps and not(INSTR = UNDEF) then
			
			--Parsing the instruction word.
			
			OPCODE <= INSTR(31 downto 26);
			RS <= INSTR(25 downto 21);
			RT <= INSTR(20 downto 16);
			RD <= INSTR(15 downto 11);
			SHAMT <= INSTR(10 downto 6);
			FUNCT <= INSTR(5 downto 0);
			IMM <= INSTR(15 downto 0);
			ADDR <= INSTR(25 downto 0);
			
			--Shortcuts for further processing
			uOPCODE := unsigned(OPCODE);
			uFUNCT := unsigned(FUNCT);
			
			--Sign-extending the immediate value
			
			--Zero-extend any logical ops (ANDI, ORI, XORI)
			if uOPCODE = 12 or uOPCODE = 13 or uOPCODE = 14 then
				IMMEDIATE <= to_integer(unsigned(ZERO_EXT & IMM));
				
				report "ID: Zero extension.";
				
			--Sign-extend Arithmetic or memory accesses
			elsif uOPCODE = 8 or uOPCODE = 10 or uOPCODE = 35 or uOPCODE = 43 then
				IMMEDIATE <= to_integer(unsigned(ONE_EXT & IMM));
				
				report "ID: Sign extension.";
				
			else
			
				report "ID: Padding.";
			
			end if;
			
			REG_A <= REG(to_integer(unsigned(RS)));
			REG_B <= REG(to_integer(unsigned(RT)));
			CONTROL_VECTOR <= CONTROL_VECTOR_INTERNAL;
			
			else
				
				REG_A <= 0;
				REG_B <= 0;
				IMMEDIATE <= 0;
				CONTROL_VECTOR <= (others => '0');
				
		end if;
		


	end process;
	
	--Initialization of registers to 0.
	
	REGISTER_FILE_INIT: process
	
	begin
	
		if now < 1 ps then
		
			for idx in 0 to REG_COUNT_MAX-1 loop
			
				REG(idx) <= idx + 100;
				
			end loop;
			
		end if;
		
		wait;
	
	end process;
	
	--Load from registers.
	

end architecture;