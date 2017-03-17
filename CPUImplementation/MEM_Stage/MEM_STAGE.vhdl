library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_STAGE is

	port (
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Data to register--
		DATA_IN,
		--Write addr.
		DATA_ADDR,
		--Instruction in--
		INSTR_IN : in std_logic_vector(31 downto 0);
		MEM_CONTROL: in std_logic_vector(1 downto 0);
		--OUTPUT--
		--Data output--
		DATA_OUT,
		--Data forward--
		DATA_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT : out std_logic_vector(31 downto 0)
	);

end entity;

architecture MEM_STAGE_Impl of MEM_STAGE is

signal WAIT_REQ: std_logic := '0';
signal DATA_READ: std_logic_vector(31 downto 0) := (others => '0');
signal ADDR: integer := 0;

component memory
	GENERIC(
		ram_size : INTEGER := 32768;
		mem_delay : time := 1 ns;
		clock_period : time := 1 ns;
		from_file : boolean := false
	);

	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO (ram_size/4)-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
end component;

begin

DATA_MEMORY : memory port map(
	CLOCK,
	DATA_IN,
	ADDR,
	MEM_CONTROL(0),
	MEM_CONTROL(1),
	DATA_OUT,
	WAIT_REQ
);


ADDR <= to_integer(unsigned(DATA_ADDR));
DATA_FORWARD_OUT <= DATA_IN;
INSTR_OUT <= INSTR_IN;

end architecture;