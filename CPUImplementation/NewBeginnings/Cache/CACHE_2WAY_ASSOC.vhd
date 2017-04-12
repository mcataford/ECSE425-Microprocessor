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
--Ready: Cache is ready for a new request
--Entry: A request has been made, set signals
--Decode: Place input signals into internal signals for processing and get the row from the 2 cache arrays
--Hit: When a hit has occured as determined by the Determination state
--Miss: When a miss has occured as determined by the Determination state
--WRITE_TO_MEM: When the cache must write some data to memory
--FETCH_FROM_MEM: When the cache must fetch something from memory
--MEMORY_WAIT: When the cache is waiting on data to be read or written into the memory

type state_type is (READY,ENTRY,DECODE,HIT,MISS,WRITE_TO_MEM,FETCH_FROM_MEM,DETERMINATION,MEMORY_WAIT);

--- Cache array
--- Cache array location: || 2 Flags: Dirty/Valid | 10 Tag | 32 Data ||
type MEM is array (512 downto 0) of STD_LOGIC_VECTOR(56 downto 0);
--Initialize to zero
signal CACHE0 : MEM := (others=>(others=>'0'));
signal CACHE1 : MEM := (others=>(others=>'0'));

-- Current, next, previous state signals
signal current_state: state_type := READY;
signal next_state: state_type;
signal previous_state : state_type;

--Signals for internal processing from the items given to the cache from the pipeline
signal TAG : STD_LOGIC_VECTOR (22 downto 0):= (others=>'0');
signal INDEX : STD_LOGIC_VECTOR (8 downto 0):= (others=>'0');
signal WRITEDATA : STD_LOGIC_VECTOR(31 downto 0):= (others=>'0');


--Signals for internal processing of the items from the 2 cache arrays
signal ROW0 : STD_LOGIC_VECTOR(56 downto 0):= (others=>'0');
signal TAG0 : STD_LOGIC_VECTOR(22 downto 0):= (others=>'0');
signal VALID0 : STD_LOGIC:= '0';
signal DIRTY0 : STD_LOGIC:= '0';
signal ROW1 : STD_LOGIC_VECTOR(56 downto 0):= (others=>'0');
signal TAG1 : STD_LOGIC_VECTOR(22 downto 0):= (others=>'0');
signal VALID1 : STD_LOGIC:= '0';
signal DIRTY1 : STD_LOGIC:= '0';

signal CACHE_CONTROL : STD_LOGIC := '0';
signal T1 : STD_LOGIC_VECTOR(31 downto 0);
signal T0 : STD_LOGIC_VECTOR(31 downto 0);
signal vINDEX : INTEGER;
signal IS_HIT : STD_LOGIC_VECTOR(1 downto 0);

begin
	
--Process which takes care of setting which cache to evict data from
cache_controller : process(clock)
begin
	if(IS_HIT(1) = '1') then
		CACHE_CONTROL <= IS_HIT(0);
	elsif(IS_HIT(1) = '0') then
		CACHE_CONTROL <= ((NOT VALID1) OR (VALID0 AND DIRTY0));
	end if;
end process cache_controller;


--Process for state transitions
state_transitions: process(clock)
begin
	if(rising_edge(clock)) then
		current_state<=next_state;
	end if;
end process state_transitions;

-- State behavioural handling process, synchronized with current state changes.
state_behaviour : process(clock)

variable TAG_TOP : INTEGER := 54;
variable TAG_BOTTOM : INTEGER := 32;

begin

	if falling_edge(clock) then
		--Next state becomes current state.
		-- current_state <= temp_state;
		case current_state is

			when READY =>

				next_state<=ENTRY;

			when ENTRY =>
				-- Setting of memory control signals low
				m_read <= '0';
				m_write <= '0';
				s_waitrequest <= '0';

				-- If request, decode.
				if(s_read = '1' OR s_write = '1') then
					next_state <= DECODE;
				else 
					next_state <= READY;
				end if;
				
			
			-- Decode s_addr contents and proceed to the next appropriate state
			when DECODE =>
				--- Decoding inputs and putting them in signals	
				TAG <= s_addr(31 downto 9);
				INDEX <= s_addr(8 downto 0);
				WRITEDATA <= s_writedata;
				vINDEX <= to_integer(unsigned(s_addr(8 downto 0)));
				ROW0 <= CACHE0(to_integer(unsigned(s_addr(8 downto 0))));
				ROW1 <= CACHE1(to_integer(unsigned(s_addr(8 downto 0))));
				TAG0 <= CACHE0(to_integer(unsigned(s_addr(8 downto 0))))(54 downto 32);
				TAG1 <= CACHE1(to_integer(unsigned(s_addr(8 downto 0))))(54 downto 32);
				VALID0 <= CACHE0(to_integer(unsigned(s_addr(8 downto 0))))(56);
				VALID1 <= CACHE1(to_integer(unsigned(s_addr(8 downto 0))))(56);
				DIRTY0 <= CACHE0(to_integer(unsigned(s_addr(8 downto 0))))(55);
				DIRTY1 <= CACHE1(to_integer(unsigned(s_addr(8 downto 0))))(55);
				--Set waitrequest high as the cache has some work to do
				s_waitrequest <= '1';
				next_state<=DETERMINATION;

			when DETERMINATION =>

				-- If cache 0 has a hit set its hit variable
				if(TAG0 = TAG AND VALID0 = '1') then
					IS_HIT <= "10";
					next_state <= HIT;
				-- Else if cache 1 has a hit set its hit variable
				elsif(TAG1 = TAG AND VALID1 = '1') then
					IS_HIT <= "11";
					next_state <= HIT;
				-- If neither those and we're writing, then its a miss and if we can write to either cache0 or cache1, do it
				elsif(s_write = '1' AND (VALID0 = '0' OR VALID1 = '0')) then
					IS_HIT <= "00";
					next_state <= HIT;
				--Otherwise we need to write to memory and then fetch from memory
				else
					IS_HIT <= "00";
					next_state <= MISS;
				end if;

			when HIT =>
			--If reading
				if(s_write = '0' and s_read = '1') then
					--Determine which cache we are effecting
					case CACHE_CONTROL is
						when '0' =>
							s_readdata <= ROW0(31 downto 0);
						when '1' =>
							s_readdata <= ROW1(31 downto 0);
						when others =>
							s_readdata <= (others => '0');
					end case;
					
				elsif(s_write = '1' and s_read = '0') then 
					--Determine which cache we are effecting

					case CACHE_CONTROL is
						when '0' =>
							ROW0 <= "11" & TAG & s_writedata;
							CACHE0(vINDEX) <= "11" & TAG & s_writedata;
						when '1' =>
							ROW1 <= "11" & TAG & s_writedata;
							CACHE1(vINDEX) <= "11" & TAG & s_writedata;
						when others =>

					end case;
				end if;
				--Done set wiatrequest low
				s_waitrequest <= '0';
				next_state <= READY;


			when MISS =>
				if((VALID0 = '1' AND DIRTY0 = '1') AND (VALID1 = '1' AND DIRTY1 = '1')) then
					next_state <= WRITE_TO_MEM;
				else
					next_state <= FETCH_FROM_MEM;
				end if;
			
			when FETCH_FROM_MEM =>
				m_read <= '1';
				m_write <= '0';
				m_addr <= to_integer(unsigned(s_addr));
				next_state <= MEMORY_WAIT;
				previous_state <= FETCH_FROM_MEM;

			when WRITE_TO_MEM =>
				case CACHE_CONTROL is
					when '0' =>
						m_read <= '0';
						m_write <= '1';
						T0(31 downto 9) <= TAG0;
						T0(8 downto 0) <= INDEX;
						m_addr <= to_integer(unsigned(T0));
						m_writedata <= ROW0(31 downto 0);
						next_state <= MEMORY_WAIT;
						previous_state <= WRITE_TO_MEM;
					when '1' =>
						m_read <= '0';
						m_write <= '1';
						T1(31 downto 9) <= TAG1;
						T1(8 downto 0) <= INDEX;
						m_addr <= to_integer(unsigned(T1));
						m_writedata <= ROW1(31 DOWNTO 0);
						next_state <= MEMORY_WAIT;
						previous_state <= WRITE_TO_MEM;
					when others =>
				end case;

			when MEMORY_WAIT =>
				if(m_waitrequest = '0') then
					m_write <= '0';
					m_read <= '0';
					if(previous_state = FETCH_FROM_MEM) then
						case CACHE_CONTROL is
							when '0' =>
								ROW0 <= "10" & TAG & m_readdata;
								CACHE0(vINDEX) <= "10" & TAG & m_readdata;
								next_state <= HIT;
								previous_state <= MEMORY_WAIT;
							when '1' =>
								CACHE1(vINDEX) <= "10" & TAG & m_readdata;
								ROW1 <= "10" & TAG & m_readdata;
								next_state <= HIT;
								previous_state <= MEMORY_WAIT;
							when others=>
						end case;
					elsif(previous_state = WRITE_TO_MEM) then
						next_state <= FETCH_FROM_MEM;
					end if;
			end if;

		end case;
	end if;
end process state_behaviour;

end arch;
