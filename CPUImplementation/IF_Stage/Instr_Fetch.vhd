--Complete fetch instruction. It requires a PC register, an adder, a multiplexer, an instruction memory, and the IF/ID register
--(The multiplexer is implemented as a process instead of a block)

library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity IF_STAGE is
	port(
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
end IF_STAGE;

architecture IF_STAGE_Impl of IF_STAGE is	

signal PC_CURRENT: std_logic_vector(31 downto 0) := (others => '0'); --Old PC instruction
signal PC_INCR: std_logic_vector(31 downto 0); --New PC instruction (and carry out)
signal PC_FEEDBACK: std_logic_vector(31 downto 0) := (others => '0');
signal PC_OUT_NEXT: std_logic_vector(31 downto 0) := (others => '0');

signal INSTR_ADDR: integer := 0;
signal INSTR_BYTE: std_logic_vector(7 downto 0);
signal WAIT_REQ: std_logic;

signal INSTR_AUX: std_logic_vector(31 downto 0); --Current instruction

signal WFA_Cout: std_logic := '0';

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
	port(
		CLOCK: in std_logic;
		RESET: in std_logic;
		REG_WRITE: in std_logic;
		DATA_IN: in std_logic_vector(31 downto 0);
		DATA_OUT: out std_logic_vector(31 downto 0)
	);
end component PC_Register;

component memory is
	GENERIC(
	ram_size : INTEGER := 32768;
	mem_delay : time := 1 ns;
	clock_period : time := 1 ns
);
	PORT (
	clock: IN STD_LOGIC;
	writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	address: IN INTEGER RANGE 0 TO ram_size-1;
	memwrite: IN STD_LOGIC;
	memread: IN STD_LOGIC;
	readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	waitrequest: OUT STD_LOGIC
);
end component;

--Port maps--
begin

WFA : WORDFULLADDER port map(PC_CURRENT, std_logic_vector(to_unsigned(4,32)), PC_INCR, WFA_Cout);
PC_REG : PC_Register port map(CLOCK, '0', '1', PC_FEEDBACK, PC_CURRENT);
MX : MUX port map(PC_INCR, ALU_PC, PC_SRC, PC_FEEDBACK);
INSTR_MEM : memory port map(CLOCK, std_logic_vector(to_unsigned(0,32)), INSTR_ADDR, '0', '1', INSTR, WAIT_REQ);

process(CLOCK)

begin

if rising_edge(CLOCK) then
	PC_OUT_NEXT <= PC_FEEDBACK;
	INSTR_ADDR <= to_integer(unsigned(PC_CURRENT)) / 4 + 1;
end if;

end process;

PC_OUT <= PC_OUT_NEXT;

end architecture;