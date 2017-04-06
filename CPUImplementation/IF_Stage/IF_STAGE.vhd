library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity IF_STAGE is
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
end IF_STAGE;

architecture IF_STAGE_Impl of IF_STAGE is	

--Intermediate signals--

signal PC_CURRENT, PC_INCR, PC_FEEDBACK, PC_OUT_NEXT: std_logic_vector(31 downto 0) := (others => '0');
signal INSTR_ADDR: integer := 10;
signal WAIT_REQ, WFA_Cout: std_logic := '0';

signal INSTR_FETCHED: std_logic_vector(31 downto 0);

constant pc_limit : integer := 32768/4;

--Components--

component WORDFULLADDER 
	port(
		--Operands--
		A,B: in	std_logic_vector(31 downto 0);
		--Result--
		S: out std_logic_vector(31 downto 0);
		--Carry out--
		Cout: out std_logic
	);
end component;

component MUX
	port (
		--Multiplexer inputs--
		A,B: in std_logic_vector(31 downto 0);
		--Multiplexer selector--
		SELECTOR: in std_logic;
		--Multiplexer output--
		OUTPUT: out std_logic_vector(31 downto 0)
	);
	
end component;

component PC_Register is 
	port(
		--Clock signal--
		CLOCK: in std_logic;
		--Reset signal--
		RESET: in std_logic;
		--Write access--
		REG_WRITE: in std_logic;
		--Write input--
		DATA_IN: in std_logic_vector(31 downto 0);
		--Write output--
		DATA_OUT: out std_logic_vector(31 downto 0)
	);
end component PC_Register;

component memory is
	GENERIC(
	ram_size : INTEGER := 32768;
	mem_delay : time := 0 ns;
	clock_period : time := 1 ns;
	from_file : boolean := true;		
	file_in : string := "program.txt";
	to_file : boolean := false;
	file_out : string := "output.txt";
	sim_limit : time := 10 ns
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

	--Word-width full adder--
	WFA : WORDFULLADDER port map(PC_CURRENT, std_logic_vector(to_unsigned(4,32)), PC_INCR, WFA_Cout);
	--Program counter accumulator register--
	PC_REG : PC_Register port map(CLOCK, '0', '1', PC_FEEDBACK, PC_CURRENT);

	--Multiplexer--
	MX : MUX port map(PC_INCR, ALU_PC, PC_SRC, PC_FEEDBACK);

	--Instruction memory--
	INSTR_MEM : memory port map(CLOCK, std_logic_vector(to_unsigned(0,32)), INSTR_ADDR, '0', '1', INSTR, WAIT_REQ);

	process(CLOCK)

	begin

		if rising_edge(CLOCK) then	

			if to_integer(unsigned(PC_CURRENT)) < pc_limit then
				PC_OUT <= PC_FEEDBACK;
				INSTR_ADDR <= to_integer(unsigned(PC_CURRENT)) / 4;
				report "Tick.";
			end if;
			
		end if;

	end process;

end architecture;