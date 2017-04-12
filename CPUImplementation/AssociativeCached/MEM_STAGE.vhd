-- ECSE425 CPU Pipeline mark II
--
-- Memory stage
--
-- Author: Marc Cataford
-- Last modified: 10/4/2017


library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_STAGE is

		port(
			--INPUT
			--Clock
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			--Results from ALU
			DATA_ADDRESS: in std_logic_vector(63 downto 0);
			--B fwd
			DATA_PAYLOAD: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			DATA_OUT: out std_logic_vector(31 downto 0) := (others => 'Z');
			
			CACHE_IN: in std_logic_vector(32 downto 0);
			CACHE_OUT: out std_logic_vector(65 downto 0)
		);
	
end entity;

architecture MEM_STAGE_Impl of MEM_STAGE is

	--Intermediate signals and constants
	
	signal DATA_IN: std_logic_vector(31 downto 0) := (others => 'Z');
	signal DATA_READ, DATA_WRITE, DATA_MEMSTALL: std_logic := '0';
	
	signal DATA_ADDR: integer := 0;

	--Subcomponent instantiation
	
	--Instruction memory
	
	-- component memory is
	
		-- GENERIC(
		-- ram_size : INTEGER := 8192;
		-- mem_delay : time :=  2 ns;
		-- clock_period : time := 1 ns;
		-- from_file : boolean := false;		
		-- file_in : string := "program.txt";
		-- to_file : boolean := false;
		-- file_out : string := "output.txt";
		-- sim_limit : time := 1000 ns
	-- );
		-- PORT (
		-- clock: IN STD_LOGIC;
		-- writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		-- address: IN INTEGER RANGE 0 TO ram_size-1;
		-- memwrite: IN STD_LOGIC;
		-- memread: IN STD_LOGIC;
		-- readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		-- waitrequest: OUT STD_LOGIC
	-- );
	
	--end component;

begin

	-- DM: memory port map(
		-- --INPUT
		-- --Clock signal
		-- CLOCK,
		-- --Data in (DISABLED)
		-- DATA_IN,
		-- --Data addr.
		-- DATA_ADDR,
		-- --Memory write perm. (DISABLED)
		-- DATA_WRITE,
		-- --Memory read perm.
		-- DATA_READ,
		
		-- --OUTPUT
		-- --Data out
		-- DATA_OUT,
		-- --Stall signal
		-- DATA_MEMSTALL		
	-- );
					
	STAGE_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if falling_edge(CLOCK) then
		
			if CACHE_IN(0) = '0' then
			
				CACHE_OUT(0) <= '0';
				CACHE_OUT(1) <= '0';
			
			end if;
			
		elsif rising_edge(CLOCK) then
		
			if CONTROL_VECTOR(5 downto 4) = "01" then
			
				CACHE_OUT(1) <= '1';
				CACHE_OUT(65 downto 34) <= DATA_ADDRESS(31 downto 0);
			
			elsif CONTROL_VECTOR(5 downto 4) = "10" then
			
				CACHE_OUT(0) <= '1';
				CACHE_OUT(65 downto 34) <= DATA_ADDRESS(31 downto 0);
				CACHE_OUT(33 downto 2) <= DATA_PAYLOAD;
			
			end if;
		
		end if;
	
	end process;
	
end architecture;