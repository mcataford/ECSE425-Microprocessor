--Complete fetch instruction. It requires a PC register, an adder, a multiplexer, an instruction memory, and the IF/ID register
--(The multiplexer is implemented as a process instead of a block)

library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity IF_STAGE is
	port(
		--Inputs--
		CLK: in std_logic;
		RESET: in std_logic;
		---Control Signals---
		PC_SELECT: in std_logic; --MUX select
		PC_ADDR_IN: in std_logic_vector(31 downto 0); --One of the MUX inputs
		--Outputs--
		PC_ADDR_OUT: out std_logic_vector(31 downto 0);
		INSTR: out std_logic_vector(31 downto 0)
	);
end IF_STAGE;

architecture IF_STAGE_Impl of IF_STAGE is	

--Signals--
signal PC_ADDR_AUX1: std_logic_vector(31 downto 0); --Old PC instruction
signal PC_ADDR_AUX2: std_logic_vector(32 downto 0); --New PC instruction (and carry out)
signal PC_ADDR_AUX3: std_logic_vector(31 downto 0); --MUX output  
signal INSTR_AUX: std_logic_vector(31 downto 0); --Current instruction
constant PC_COUNT : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000100"; --The integer 4 to be added

--Components--
component WORDFULLADDER 
port(
	A,B: in	std_logic_vector(31 downto 0);
	S: out std_logic_vector(31 downto 0);
	Cout: out std_logic
);
end component;

component MUX

port (
	A,B: in std_logic_vector(31 downto 0);
	SELECTOR: in std_logic;
	OUTPUT: out std_logic_vector(31 downto 0)
);
	
end component;

component PC_Register is 
	generic (N:NATURAL := 32);
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		DATA_IN: in std_logic_vector(N-1 downto 0);
		DATA_OUT: out std_logic_vector(N-1 downto 0)
	);
end component PC_Register;

component IF_ID_Register is   
	port(
		CLK: in std_logic;
		RESET: in std_logic;
		PC_ADDR_IN: in std_logic_vector(31 downto 0);
		INSTR_IN: in std_logic_vector(31 downto 0);
		PC_ADDR_OUT: out std_logic_vector(31 downto 0);
		INSTR_OUT: out std_logic_vector(31 downto 0)
	);
end component IF_ID_Register;

--component memory is
--  	GENERIC(
--	  ram_size : INTEGER := 32768;
--	  mem_delay : time := 10 ns;
--	  clock_period : time := 1 ns
--   );
--	port(
--		RESET: in std_logic;
-- 			READ_ADDR: in std_logic_vector(31 downto 0);
-- 			INSTR: out std_logic_vector(31 downto 0)
-- 			
-- 			--clock: IN STD_LOGIC;
--	  --writedata: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
--	  --address: IN INTEGER RANGE 0 TO ram_size-1;
--	  --memwrite: IN STD_LOGIC;
--	  --memread: IN STD_LOGIC;
--	  --readdata: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
--	  --waitrequest: OUT STD_LOGIC
--	);
--end component memory;
--
--Port maps--
begin

WFA : WORDFULLADDER port map(PC_ADDR_AUX1, PC_COUNT, PC_ADDR_AUX2, WFA_COut);
PC_REG : PC_Register port map(CLK, RESET, PC_ADDR_AUX3, PC_ADDR_AUX1);
--INSTR_MEM : memory port map();
IF_ID_REG: IF_ID_REGISTER port map(CLK, RESET, PC_ADDR_AUX2, INSTR_AUX, PC_ADDR_OUT, INSTR);	

end architecture;