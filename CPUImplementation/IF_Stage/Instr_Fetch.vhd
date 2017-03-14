--Complete fetch instruction. It requires a PC register, an adder, a multiplexer, an instruction memory, and the IF/ID register
--(The multiplexer is implemented as a process instead of a block)

library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity Instr_Fetch is
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
end Instr_Fetch;

architecture arch of Instr_Fetch is	

--Signals--
	signal PC_ADDR_AUX1: std_logic_vector(31 downto 0); --Old PC instruction
	signal PC_ADDR_AUX2: std_logic_vector(32 downto 0); --New PC instruction (and carry out)
	signal PC_ADDR_AUX3: std_logic_vector(31 downto 0); --MUX output  
	signal INSTR_AUX: std_logic_vector(31 downto 0); --Current instruction
	constant PC_COUNT : STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000100"; --The integer 4 to be added

--Components--
	component ADDER is 
		port(
			A: in	std_logic_vector(31 downto 0);
			B: in	std_logic_vector(31 downto 0);
			Cin: in std_logic;
			S: out std_logic_vector(31 downto 0);
			Cout: out std_logic
		);
	end component ADDER;

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

	component memory is
	  	GENERIC(
		  ram_size : INTEGER := 32768;
		  mem_delay : time := 10 ns;
		  clock_period : time := 1 ns
	   );
		port(
			RESET: in std_logic;
  			READ_ADDR: in std_logic_vector(31 downto 0);
  			INSTR: out std_logic_vector(31 downto 0)
  			
  			--clock: IN STD_LOGIC;
		  --writedata: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  --address: IN INTEGER RANGE 0 TO ram_size-1;
		  --memwrite: IN STD_LOGIC;
		  --memread: IN STD_LOGIC;
		  --readdata: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  --waitrequest: OUT STD_LOGIC
		);
	end component memory;
	
--Port maps--
begin
	FETCH_ADDER: -- The adder block
		ADDER port map(
			A => PC_ADDR_AUX1,
			B => PC_COUNT, --Add 4
			Cin => '0',
			S => PC_ADDR_AUX2(31 downto 0),
			Cout	=> PC_ADDR_AUX2(32)
		);

	MUX: -- The multiplexer
		process(PC_SELECT,PC_ADDR_IN,PC_ADDR_AUX2)
		begin
			if(PC_SELECT = '0') then
				PC_ADDR_AUX3 <= PC_ADDR_AUX2(31 downto 0); 
			else
				PC_ADDR_AUX3 <= PC_ADDR_IN;
			end if;
		end process MUX; 

	PC: -- The PC register
		PC_Register port map(
			CLK => CLK,
			RESET => RESET,
			DATA_IN => PC_ADDR_AUX3,
			DATA_OUT => PC_ADDR_AUX1
		);
	
	INSTR_MEM: -- The instruction memory
	  memory port map(
			RESET => RESET,
			READ_ADDR => PC_ADDR_AUX1,
			INSTR => INSTR_AUX
			
			--clock => clock,
		  --writedata => PC_ADDR_AUX1,
		  --address => address,
		  --memwrite => memwrite,
		  --memread => memread,
		  --readdata => INSTR_AUX,
		  --waitrequest => waitrequest
		);
		
	IF_ID_REG: -- And the IF/ID register
		IF_ID_Register port map(
			CLK => CLK,
			RESET => RESET,
			PC_ADDR_IN => PC_ADDR_AUX2(31 downto 0),
			INSTR_IN => INSTR_AUX,
			PC_ADDR_OUT => PC_ADDR_OUT,
			INSTR_OUT => INSTR
		);	

end arch;