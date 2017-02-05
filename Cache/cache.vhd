library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache is
generic(
	ram_size : INTEGER := 32768
);
port(
	clock : in std_logic;
	reset : in std_logic;
	
	-- Avalon interface --
	s_addr : in std_logic_vector (31 downto 0);
	s_read : in std_logic;
	s_readdata : out std_logic_vector (31 downto 0);
	s_write : in std_logic;
	s_writedata : in std_logic_vector (31 downto 0);
	s_waitrequest : out std_logic; 
    
	m_addr : out integer range 0 to ram_size-1;
	m_read : out std_logic;
	m_readdata : in std_logic_vector (7 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (7 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is

-- State definitions
-- A: Initial decoding state
-- WR: Determined a write instruction
-- WR_HIT: Write hit - In cache, just write work to the right word in block
-- WR_MISS: Write miss - Not in cache, evict indexed item and bring in new item

--- TODO: Define states based on diagram.
type state_type is (A,WR,WR_HIT,WR_MISS,RD);

--- Cache array
--- Cache array location | 25 Tag | 2 Flags | 128 Data |
--- 32 blocks leads to array size
--- 155 bits per location in cache array = 25 bits of tag + 28 bits of data + 2 bits for valid/clean
type MEM is array (31 downto 0) of STD_LOGIC_VECTOR(154 downto 0);
signal CACHE : MEM;

-- Current and next state signals
-- Entry point is state A.
signal current_state: state_type := A;
signal next_state: state_type;

signal C_TAG STD_LOGIC_VECTOR (24 downto 0);
signal C_INDEX STD_LOGIC_VECTOR (4 downto 0);
signal C_OFFSET STD_LOGIC_VECTOR (1 downto 0);
signal C_ROW STD_LOGIC_VECTOR(155 downto 0);

signal WR_START : INTEGER;
signal WR_END : INTEGER;


begin

-- State change handling process, synchronized with clock signal.
state_change : process(clock)

begin
	
	if rising_edge(clock) then
		current_state <= next_state;
	end if;

end process state_change;

-- State behavioural handling process, synchronized with current state changes.
state_behaviour : process(current_state)
		
begin
	-- Branch to behavioural segment based on current state signal.
	case current_state is
		when A =>
			--- Decoding inputs and putting them in signals
			
			C_TAG <= s_addr(31 downto 7);
			C_INDEX <= s_addr(6 downto 2);
			C_OFFSET <= s_addr(1 downto 0);

			--- Determining next course of action (read or write)
			if s_read = 1 and s_write = 0 then
				next_state <= RD;
			elsif s_read = 0 and s_write = 1 then
				next_state <= WR;
			end if;

		when WR =>
			---Writing
			---Find index in cache and compare tags
			C_ROW <= CACHE(to_integer(unsigned(INDEX)));
			if C_ROW(154 downto 130) = C_TAG then
				next_state <= WR_HIT;
			elsif C_ROW(154 downto 130) != C_TAG then
				next_state <= WR_MISS;
			end if;

		when WR_HIT =>
			---Write Hit
			---Write word to corresponding word in block, specified by block offset
			WR_START <= to_integer(unsigned(C_OFFSET)) * 32;
			WR_END <= to_integer(unsigned(C_OFFSET)) * 32 + 31;
			
			---Write changes to block's word
			C_ROW(WR_END downto WR_START) <= s_writedata(31 downto 0);
			---Set dirty bit
			C_ROW(129) <= '1';
			---Put back in cache at index location
			CACHE(C_INDEX)<=C_ROW;
			
		when WR_MISS =>
	
	end case;
	
end process state_behaviour;




end arch;
