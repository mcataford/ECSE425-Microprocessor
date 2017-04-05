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

--State definitions
--Entry: 
--Decode:
--Hit/Miss:
--Memory:
--Cache:

type state_type is (ENTRY,DECODE,HIT,MISS);

--- Cache array
--- Cache array location: || 2 Flags: Dirty/Valid | 20 Tag | 128 Data ||
--- 32 blocks leads to array size
--- 152 bits per location in cache array = 2 bits dirty/valid + 20 bits of tag + 128 bits of data
type MEM is array (1023 downto 0) of STD_LOGIC_VECTOR(151 downto 0);
signal CACHE0 : MEM := (others=>(others=>'0'));
signal CACHE1 : MEM := (others=>(others=>'1'));

-- Current and next state signals
signal current_state: state_type := ENTRY;
signal next_state: state_type := ENTRY;


signal TAG : STD_LOGIC_VECTOR (19 downto 0);
signal INDEX : STD_LOGIC_VECTOR (9 downto 0);
signal OFFSET : STD_LOGIC_VECTOR (1 downto 0);
signal WRITEDATA : STD_LOGIC_VECTOR(31 downto 0);

signal ROW0 : STD_LOGIC_VECTOR(151 downto 0);
signal TAG0 : STD_LOGIC_VECTOR(19 downto 0);
signal VALID0 : STD_LOGIC;
signal DIRTY0 : STD_LOGIC;

signal ROW1 : STD_LOGIC_VECTOR(151 downto 0);
signal TAG1 : STD_LOGIC_VECTOR(19 downto 0);
signal VALID1 : STD_LOGIC;
signal DIRTY1 : STD_LOGIC;

signal CACHE_EVICT : STD_LOGIC;
signal CACHE_CONTROL : STD_LOGIC;
signal HIT_ROW : STD_LOGIC_VECTOR(151 downto 0);


begin

-- State behavioural handling process, synchronized with current state changes.
state_behaviour : process(clock)

variable TAG_TOP : INTEGER := 149;
variable TAG_BOTTOM : INTEGER := 130;


variable WR_placemark : INTEGER range 0 to 16;
variable RD_placemark : INTEGER range 0 to 16;
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

			WR_placemark := 0;
			RD_placemark := 0;

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
			INDEX <= s_addr(11 downto 2);
			OFFSET <= s_addr(1 downto 0);
			WRITEDATA <= s_writedata;
			--Determine if hit/miss
			ROW0 <= CACHE0(to_integer(unsigned(INDEX)));
			ROW1 <= CACHE1(to_integer(unsigned(INDEX)));
			TAG0 <= ROW0(TAG_TOP downto TAG_BOTTOM);
			TAG1 <= ROW1(TAG_TOP downto TAG_BOTTOM);
			VALID0 <= ROW0(151);
			VALID1 <= ROW1(151);
			DIRTY0 <= ROW0(150);
			DIRTY1 <= ROW1(150);

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
				CACHE_EVICT <= ((NOT VALID1) OR (VALID0 AND DIRTY0));
				next_state <= MISS;
			end if;

			-- The CPU requested a write to the cache. Must determine if hit or miss
		when HIT =>
            		if(s_write = '0' and s_read = '1') then
                		case OFFSET is
                    			when "00" =>
                	        		s_readdata <= HIT_ROW(31 downto 0);
                	    		when "01" =>
                	        		s_readdata <= HIT_ROW(63 downto 32);
                	    		when "10" =>
                	        		s_readdata <= HIT_ROW(95 downto 64);
                	    		when "11" =>
                	        		s_readdata <= HIT_ROW(127 downto 96);
                	    		when others =>
                	        		s_readdata <= "00000000000000000000000000000000";
                		end case;
            		elsif(s_write = '1' and s_read = '0') then
                		case OFFSET is
                		    when "00" =>
               			         HIT_ROW(31 downto 0) <= s_writedata;
               			     when "01" =>
               			         HIT_ROW(63 downto 32) <= s_writedata;
               			     when "10" =>
               			         HIT_ROW(95 downto 64) <= s_writedata;
               			     when "11" =>
               			         HIT_ROW(127 downto 96) <= s_writedata;
               			     when others =>
               			         HIT_ROW(31 downto 0) <= "00000000000000000000000000000000";
               			 end case;
               		 	--Set valid and dirty bits
               			HIT_ROW(151) <= '1'; --Valid
                		HIT_ROW(150) <= '1'; --Dirty

                		--Return the row to the correct cache
                		case CACHE_CONTROL is
					when '0' =>
						CACHE0(to_integer(unsigned(INDEX))) <= HIT_ROW;
					when '1' =>
                		        	CACHE1(to_integer(unsigned(INDEX))) <= HIT_ROW;
					when others =>

                		end case;
            		end if;

            		next_state <= ENTRY;


			-- The CPU requested a write and the item it wanted to write to was in the cache.
		when MISS =>
			
				m_addr <= to_integer(unsigned(s_addr));
				case CACHE_EVICT is
					when '0' =>
						--Write into memory only if Valid and Dirty
						if(VALID0 = '1' AND DIRTY0 = '1') then
							while (WR_PLACEMARK<16) loop
								m_write <= '1';
								m_read <= '0';
								m_writedata <= ROW0(WR_PLACEMARK*8+7 downto WR_PLACEMARK*8);
								while (m_waitrequest > '0') loop
								
								end loop;
								m_write <= '0';
								WR_PLACEMARK := WR_PLACEMARK + 1;
							end loop;								
						end if;
						ROW0(151) <= '1'; --Valid
						--Read out of Memory
						while(RD_PLACEMARK<16) loop
							m_read <= '1';
							m_write <= '0';
							ROW0(RD_PLACEMARK*8+7 downto RD_PLACEMARK*8)<=m_readdata;
							while(m_waitrequest>'0') loop
			
							end loop;
							m_read <='0';
							RD_PLACEMARK := RD_PLACEMARK + 1;
						end loop;
						CACHE0(to_integer(unsigned(INDEX))) <= ROW0;
						next_state <= HIT;

					when '1' =>
						--Write into memory only if Valid and Dirty
						if(VALID1 = '1' AND DIRTY1 = '1') then
							while (WR_PLACEMARK<16) loop
								m_write <= '1';
								m_read <= '0';
								m_writedata <= ROW1(WR_PLACEMARK*8+7 downto WR_PLACEMARK*8);
								while (m_waitrequest > '0') loop
								
								end loop;
								m_write <= '0';
								WR_PLACEMARK := WR_PLACEMARK + 1;
							end loop;								
						end if;
						ROW1(151) <= '1'; --Valid
						--Read out of Memory
						while(RD_PLACEMARK<16) loop
							m_read <= '1';
							m_write <= '0';
							ROW1(RD_PLACEMARK*8+7 downto RD_PLACEMARK*8)<=m_readdata;
							while(m_waitrequest>'0') loop
			
							end loop;
							m_read <='0';
							RD_PLACEMARK := RD_PLACEMARK + 1;
						end loop;
						CACHE1(to_integer(unsigned(INDEX))) <= ROW1;
						next_state <= HIT;
					when others=>
						next_state <= ENTRY;
				end case;
        	end case;
    	end if;
end process state_behaviour;

end arch;
