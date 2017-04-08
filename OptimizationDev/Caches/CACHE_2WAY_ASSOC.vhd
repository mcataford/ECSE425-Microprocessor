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
	m_readdata : in std_logic_vector (31 downto 0);
	m_write : out std_logic;
	m_writedata : out std_logic_vector (31 downto 0);
	m_waitrequest : in std_logic
);
end cache;

architecture arch of cache is

--State definitions
--Entry: 
--Decode:
--Hit/Miss:
--Memory:
--Cache:

type state_type is (ENTRY,DECODE,HIT,MISS,WRITE_TO_MEM,FETCH_FROM_MEM);

--- Cache array
--- Cache array location: || 2 Flags: Dirty/Valid | 20 Tag | 32 Data ||
--- 32 blocks leads to array size
--- 152 bits per location in cache array = 2 bits dirty/valid + 20 bits of tag + 128 bits of data
type MEM is array (4096 downto 0) of STD_LOGIC_VECTOR(53 downto 0);
signal CACHE0 : MEM := (others=>(others=>'0'));
signal CACHE1 : MEM := (others=>(others=>'1'));

-- Current and next state signals
signal current_state: state_type := ENTRY;
signal next_state: state_type := ENTRY;


signal TAG : STD_LOGIC_VECTOR (19 downto 0):= (others=>'0');
signal INDEX : STD_LOGIC_VECTOR (11 downto 0):= (others=>'0');
signal WRITEDATA : STD_LOGIC_VECTOR(31 downto 0):= (others=>'0');

signal ROW0 : STD_LOGIC_VECTOR(53 downto 0):= (others=>'0');
signal TAG0 : STD_LOGIC_VECTOR(19 downto 0):= (others=>'0');
signal VALID0 : STD_LOGIC:= '0';
signal DIRTY0 : STD_LOGIC:= '0';
signal ROW1 : STD_LOGIC_VECTOR(53 downto 0):= (others=>'0');
signal TAG1 : STD_LOGIC_VECTOR(19 downto 0):= (others=>'0');
signal VALID1 : STD_LOGIC:= '0';
signal DIRTY1 : STD_LOGIC:= '0';

signal CACHE_EVICT : STD_LOGIC := '0';
signal CACHE_CONTROL : STD_LOGIC:= '0';
signal HIT_ROW : STD_LOGIC_VECTOR(53 downto 0):= (others=>'0');


begin

-- State behavioural handling process, synchronized with current state changes.
state_behaviour : process(clock)

variable TAG_TOP : INTEGER := 51;
variable TAG_BOTTOM : INTEGER := 32;

begin
if rising_edge(clock) then
	--Next state becomes current state.
	current_state <= next_state;

	-- Branch to behavioural segment based on current state signal.
	case current_state is

		-- Entry state - Waiting on CPU request
		when ENTRY =>
			-- Setting of memory control signals low
			m_read <= '0';
			m_write <= '0';
			s_waitrequest <= '0';

			-- If request, decode.
			if(s_read = '1' OR s_write = '1') then
				next_state <= DECODE;
			end if;
			
		
		-- Decode s_addr contents and proceed to the next appropriate state
		when DECODE =>
			-- Set the s_waitrequest high as the slave has some work to do. This informs the master that it is working.
			s_waitrequest <= '1';

			--- Decoding inputs and putting them in signals	
			TAG <= s_addr(31 downto 12);
			INDEX <= s_addr(11 downto 0);
			WRITEDATA <= s_writedata;
			--Determine if hit/miss
			ROW0 <= CACHE0(to_integer(unsigned(INDEX)));
			ROW1 <= CACHE1(to_integer(unsigned(INDEX)));
			TAG0 <= ROW0(51 downto 32);
			TAG1 <= ROW1(51 downto 32);
			VALID0 <= ROW0(53);
			VALID1 <= ROW1(53);
			DIRTY0 <= ROW0(52);
			DIRTY1 <= ROW1(52);

			-- If cache 0 has a hit set its hit variable
			if(TAG0 = TAG AND VALID0 = '1') then
				CACHE_CONTROL <= '0';
				HIT_ROW <= ROW0;
				next_state <= HIT;
			-- Else if cache 1 has a hit set its hit variable
			elsif(TAG1 = TAG AND VALID1 = '1') then
				CACHE_CONTROL <= '1';
				HIT_ROW <= ROW1;
				next_state <= HIT;
			-- If neither those, then its a miss
			else
				Report "Some silly string";
				CACHE_EVICT <= ((NOT VALID1) OR (VALID0 AND DIRTY0));
				next_state <= MISS;
			end if;

			-- The CPU requested a write to the cache. Must determine if hit or miss
		when HIT =>
            	if(s_write = '0' and s_read = '1') then
            	    s_readdata <= HIT_ROW(31 downto 0);
        		elsif(s_write = '1' and s_read = '0') then                		
					HIT_ROW(31 downto 0) <= s_writedata;
               		--Set valid and dirty bits
               		HIT_ROW(53) <= '1'; --Valid
            		HIT_ROW(52) <= '1'; --Dirty

            		--Return the row to the correct cache
            		case CACHE_CONTROL is
						when '0' =>
							CACHE0(to_integer(unsigned(INDEX))) <= HIT_ROW;
						when '1' =>
							CACHE1(to_integer(unsigned(INDEX))) <= HIT_ROW;
						when others =>
							next_state <= ENTRY;
					end case;
            	end if;

            	next_state <= ENTRY;


			-- The CPU requested a write and the item it wanted to write to was in the cache.
		when MISS =>
			case CACHE_EVICT is
				when '0' =>
					if(VALID0 = '1' AND DIRTY0 = '1') then
						next_state <= WRITE_TO_MEM;
					else
						next_state <= FETCH_FROM_MEM;
					end if;
				when '1' =>
					if(VALID1 = '1' AND DIRTY1 = '1') then
						next_state <= WRITE_TO_MEM;
					else
						next_state <= FETCH_FROM_MEM;
					end if;
				when others =>
					next_state <= ENTRY;
			end case;

		when FETCH_FROM_MEM =>
			case CACHE_EVICT is
				when '0' =>
					m_read <= '1';
					m_write <= '0';
					-- while(m_waitrequest > '0') loop
					-- 	ROW0(31 downto 0) <= m_readdata;
					-- end loop;
					m_read <= '0';
					CACHE0(to_integer(unsigned(INDEX))) <= ROW0;
					next_state <= HIT;
				when '1' =>
					m_read <= '1';
					m_write <= '0';
					-- while(m_waitrequest > '0') loop
					-- 	ROW1(31 downto 0) <= m_readdata;
					-- end loop;
					m_read <= '0';
					CACHE1(to_integer(unsigned(INDEX))) <= ROW1;
					next_state <= HIT;
				when others =>
				next_state <= ENTRY;
			end case;

		when WRITE_TO_MEM =>
			case CACHE_EVICT is
				when '0' =>
					m_read <= '0';
					m_write <= '1';
					-- while(m_waitrequest > '0') loop
					-- 	m_writedata <= ROW0(31 DOWNTO 0);
					-- end loop;
					m_write <= '0';
					next_state <= FETCH_FROM_MEM;
				when '1' =>
					m_read <= '0';
					m_write <= '1';
					-- while(m_waitrequest > '0') loop
					-- 	m_writedata <= ROW1(31 DOWNTO 0);
					-- end loop;
					m_write <= '0';
					next_state <= FETCH_FROM_MEM;
				when others =>
					next_state <= ENTRY;
				end case;
        	end case;
    	end if;
end process state_behaviour;

end arch;
