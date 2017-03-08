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

	component INSTRUCTION_MEMORY is
		port(
			RESET: in std_logic;
  			READ_ADDR: in std_logic_vector(31 downto 0);
  			INSTR: out std_logic_vector(31 downto 0)
		);
	end component INSTRUCTION_MEMORY;
	
--Port maps--
begin
	FETCH_ADDER:
		ADDER port map(
			A => PC_ADDR_AUX1,
			B => PC_COUNT, --Add 4
			Cin => '0',
			S => PC_ADDR_AUX2(31 downto 0),
			Cout	=> PC_ADDR_AUX2(32)
		);

	MUX:
		process(PC_SELECT,PC_ADDR_IN,PC_ADDR_AUX2)
		begin
			if(PC_SELECT = '0') then
				PC_ADDR_AUX3 <= PC_ADDR_AUX2(31 downto 0); 
			else
				PC_ADDR_AUX3 <= PC_ADDR_IN;
			end if;
		end process MUX; 

	PC: 
		PC_Register port map(
			CLK => CLK,
			RESET => RESET,
			DATA_IN => PC_ADDR_AUX3,
			DATA_OUT => PC_ADDR_AUX1
		);
	
	INSTR_MEM:
		INSTRUCTION_MEMORY port map(
			RESET => RESET,
			READ_ADDR => PC_ADDR_AUX1,
			INSTR => INSTR_AUX
		);
		
	IF_ID_REG:
		IF_ID_Register port map(
			CLK => CLK,
			RESET => RESET,
			PC_ADDR_IN => PC_ADDR_AUX2(31 downto 0),
			INSTR_IN => INSTR_AUX,
			PC_ADDR_OUT => PC_ADDR_OUT,
			INSTR_OUT => INSTR
		);	

end arch;