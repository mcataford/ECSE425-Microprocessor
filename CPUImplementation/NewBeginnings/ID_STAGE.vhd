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
	signal REG: REGISTER_FILE;
	
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

	STAGE_BEHAVIOUR: process(INSTR)
	
		--Patterns for comparisons and assign.
		variable ZERO_EXT: std_logic_vector(15 downto 0) := (others => '0');
		variable ONE_EXT: std_logic_vector(15 downto 0) := (others => '0');
		variable UNDEF: std_logic_vector(31 downto 0) := (others => 'Z');
		
		--Instruction parsing
		variable RS,RT,RD,SHAMT: std_logic_vector(4 downto 0) := (others => 'Z');
		variable OPCODE,FUNCT: std_logic_vector(5 downto 0) := (others => 'Z');
		variable IMM: std_logic_vector(15 downto 0) := (others => 'Z');
		variable ADDR: std_logic_vector(25 downto 0) := (others => 'Z');
		
		--Unsigned versions of OP & FU for comparison
		variable uOPCODE, uFUNCT: unsigned(5 downto 0) := (others => 'Z');
		
	begin
		
		--Stage action only if the register file is init. and the instruction is valid.
		if now >= 1 ps and not(INSTR = UNDEF) then
			
			--Parsing the instruction word.
			OPCODE := INSTR(31 downto 26);
			RS := INSTR(25 downto 21);
			RT := INSTR(20 downto 16);
			RD := INSTR(15 downto 11);
			SHAMT := INSTR(10 downto 6);
			FUNCT := INSTR(5 downto 0);
			IMM := INSTR(15 downto 0);
			ADDR := INSTR(25 downto 0);
			
			--Set register output.
			REG_A <= REG(to_integer(unsigned(RS)));
			REG_B <= REG(to_integer(unsigned(RT)));
			
			--Shortcuts for further processing
			uOPCODE := unsigned(OPCODE);
			uFUNCT := unsigned(FUNCT);
			
			--Sign-extending the immediate value
			
			--Zero-extend any logical ops (ANDI, ORI, XORI)
			if uOPCODE = 12 or uOPCODE = 13 or uOPCODE = 14 then
				IMMEDIATE <= ZERO_EXT & IMM;
				
				report "ID: Zero extension.";
				
			--Sign-extend Arithmetic or memory accesses
			elsif uOPCODE = 8 or uOPCODE = 10 or uOPCODE = 35 or uOPCODE = 43 then
				IMMEDIATE <= ONE_EXT & IMM;
				
				report "ID: Sign extension.";
				
			else
			
				report "ID: Padding.";
			
			end if;
			
		else
				
			--Default value.
			
			REG_A <= (others => 'Z');
			REG_B <= (others => 'Z');
			IMMEDIATE <= (others => 'Z');
				
		end if;

	end process;
	
	--Initialization of registers to 0.
	
	REGISTER_FILE_INIT: process
	
	begin
	
		if now < 1 ps then
		
			for idx in 0 to REG_COUNT_MAX-1 loop
			
				REG(idx) <= std_logic_vector(to_unsigned(idx + 100,32));
				
			end loop;
			
		end if;
		
		wait;
	
	end process;
	
	--Load from registers.
	

end architecture;