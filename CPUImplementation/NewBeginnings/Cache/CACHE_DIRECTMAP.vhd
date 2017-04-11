library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cache_DirectMapped is
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
end Cache_DirectMapped;

architecture arch of Cache_DirectMapped is


type state_type is 
(ENTRY, DECODE, DETERMINATION, HIT, MISS, FETCH_FROM_MEM, WRITE_TO_MEM, MEMORY_WAIT);

type MEM is array (1024 downto 0) of STD_LOGIC_VECTOR(55 downto 0);
signal CACHE : MEM := (others=> (15 => '1',others=>'0'));


signal current_state: state_type := ENTRY;
signal next_state: state_type := ENTRY;
signal previous_state : state_type;

signal TAG : STD_LOGIC_VECTOR (21 downto 0);
signal INDEX : STD_LOGIC_VECTOR (9 downto 0);
signal vINDEX : INTEGER;

signal ROW0 : STD_LOGIC_VECTOR(55 downto 0);
signal TAG0 : STD_LOGIC_VECTOR(21 downto 0);
signal VALID0 : STD_LOGIC;
signal DIRTY0 : STD_LOGIC;
signal T0 : STD_LOGIC_VECTOR (31 downto 0);


begin

state_transitions : process(clock)
begin
	if(rising_edge(clock)) then
		current_state <= next_state;
	end if;
end process state_transitions;


state_behaviour : process(clock)
begin
if falling_edge(clock) then
	
	case current_state is

		when ENTRY =>
			m_read <= '0';
			m_write <= '0';
			s_waitrequest <= '0';

			-- If request, decode.
			if(s_read = '1' OR s_write = '1') then
				next_state <= DECODE;
			end if;
			
		when DECODE =>
			
			s_waitrequest <= '1';

			TAG <= s_addr(31 downto 10);
			INDEX <= s_addr(9 downto 0);

			ROW0 <= CACHE(to_integer(unsigned(s_addr(9 downto 0))));
			TAG0 <= CACHE(to_integer(unsigned(s_addr(9 downto 0))))(53 downto 32);
			VALID0 <= CACHE(to_integer(unsigned(s_addr(9 downto 0))))(55);
			DIRTY0 <= CACHE(to_integer(unsigned(s_addr(9 downto 0))))(54);
			
			next_state <= DETERMINATION;
	
		when DETERMINATION =>
		  			
			if (TAG0 = TAG AND VALID0 = '1') then
				next_state <= HIT;
			else
				next_state <= MISS;
			end if;
		  
		when HIT =>
			if(s_write = '0' and s_read = '1') then
				s_readdata <= ROW0(31 downto 0);
			elsif(s_write = '1' and s_read = '0') then
				ROW0 <= "11" & TAG & s_writedata;
				CACHE(to_integer(unsigned(s_addr(9 downto 0)))) <= "11" & TAG & s_writedata;
			end if;
			s_waitrequest <= '0';
			next_state <= ENTRY;
		
		when MISS =>
			if(VALID0 = '1' AND DIRTY0 = '1') then
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
			m_read <= '0';
			m_write <= '1';
			T0(31 downto 10) <= TAG0;
			T0(9 downto 0) <= INDEX;
			m_addr <= to_integer(unsigned(T0));
			m_writedata <= ROW0(31 downto 0);
			next_state <= MEMORY_WAIT;
			previous_state <= WRITE_TO_MEM;

		when MEMORY_WAIT =>
			if(m_waitrequest = '0') then
				m_write <= '0';
				m_read <= '0';
				if(previous_state = FETCH_FROM_MEM) then
					ROW0 <= "10" & TAG & m_readdata;
					CACHE(to_integer(unsigned(s_addr(9 downto 0)))) <= "10" & TAG & m_readdata;
					next_state <= HIT;
					previous_state <= MEMORY_WAIT;
				elsif(previous_state = WRITE_TO_MEM) then
					next_state <= FETCH_FROM_MEM;
				end if;
			end if;


---------------------------------------------
		--Verify the valid and dirty bits
		-- when VALID_DIRTY =>
		--   report "DEBUG: S=VALID_DIRTY";
		  
		--   -- Go to memory if both valid and dirty bits are '1'
		--   if ((C_ROW(137) = '1') AND (C_ROW(136) = '1')) then
		--     WR_placemark := 0;
		-- 		RD_placemark := 0;
		--     next_state <= MEMORY_EVICT;
		   
		--   -- Otherwise read or write accordingly
		--   else
		--     --Read the given data
		-- 	  if(s_read = '1' AND s_write = '0') then
		-- 		  next_state <= CACHE_READ_HIT;
		-- 		--Write the given data
		-- 		elsif(s_read = '0' AND s_write = '1') then
		-- 		  next_state <= CACHE_WRITE_HIT;
		-- 		-- Something went wrong... Return to ENTRY
		--     else
		-- 		  s_waitrequest <='0';
		-- 	 	  next_state <= ENTRY;
		-- 	 	end if;
		-- 	end if;
			
---------------------------------------------
		-- The CPU requested a write and the item it wanted to write to was in the cache.
		-- when CACHE_WRITE_HIT =>
		-- 	report "DEBUG: S=CACHE_WRITE_HIT";
			
		-- 	---Write word to corresponding word in block, specified by block offset
		-- 	---WR_START is the LSB of the word being written to
		-- 	---WR_END is the MSB of the word being written to
		-- 	---Example: given address has offset 2 means third word from the right in block
		-- 	---C_ROW = |Flags|Tag|Word|>Word<|Word|Word|
		-- 	---Its LSB is WR_START and MSB is WR_END

		-- 	WR_START := to_integer(unsigned(C_OFFSET)) * 32;
		-- 	WR_END := to_integer(unsigned(C_OFFSET)) * 32 + 31;

		-- 	report "WR_START: " & integer'image(WR_START);
		-- 	report "WR_END: " & integer'image(WR_END);
			
		-- 	---Write changes to block's word
		-- 	C_ROW(WR_END downto WR_START) <= s_writedata(31 downto 0);
			

		-- 	---Set dirty bit and valid bit
		-- 	C_ROW(137) <= '1';
		-- 	C_ROW(136) <= '1';
		-- 	---Put back in cache at index location
		-- 	CACHE(to_integer(unsigned(C_INDEX))) <= C_ROW;
		-- 	---Deassert waitrequest indicating to CPU that the cache has written s_writedata to the cache
		-- 	s_waitrequest <= '0';
		-- 	---Go back to ENTRY
		-- 	next_state <= ENTRY;
	
---------------------------------------------		
		-- when CACHE_READ_HIT =>
		-- 	report "DEBUG: S=CACHE_READ_HIT";
		--   ---Depending on the input address' offset, the proper 32 bit word block gets read from the cache
		--   ---There are four possible word blocks to choose from
		--   ---Once read, the program goes back to the starting state

		-- 	if(C_OFFSET = "00") then
		-- 		s_readdata <= C_ROW(31 downto 0);
		-- 		s_waitrequest <= '0';
		-- 		next_state <= ENTRY;
		--   	elsif(C_OFFSET = "01") then
		--     		s_readdata <= C_ROW(63 downto 32);
		--     		s_waitrequest <= '0';
		--     		next_state <= ENTRY;
		--   	elsif(C_OFFSET = "10") then
		--     		s_readdata <= C_ROW(95 downto 64);
		--     		s_waitrequest <= '0';
		--     		next_state <= ENTRY;
		--   	elsif(C_OFFSET = "11") then
		--    		s_readdata <= C_ROW(127 downto 96);
		--     		s_waitrequest <= '0';
		--     		next_state <= ENTRY;
		--   	end if;

---------------------------------------------
		-- when MEMORY_EVICT =>
		-- 	report "DEBUG: S=MEMORY_EVICT";
		--   --Writing back is done in 3 stages using the Avalon interface:
		--   --memwrite / data and address are asserted
		--   --They are maintained while waitrequest is asserted by the slave
		--   --When waitrequest is deasserted, the signals are deasserted on the master's end.

		-- 	mem_write <= '1';
		-- 	m_write <= '1';
			
		-- 	--Set the address we are writing to equal to the one we are evicting from cache
		-- 	C_NEW_ADDR(1 downto 0) <= "00";		
		-- 	C_NEW_ADDR(6 downto 2) <= C_INDEX;
		-- 	C_NEW_ADDR(14 downto 7) <= C_ROW(135 downto 128);	
		-- 	C_NEW_ADDR(31 downto 15) <= "00000000000000000";
		
		-- 	m_addr <= to_integer(unsigned(C_NEW_ADDR));
		-- 	--Send 8 bits to the memory
		-- 	m_writedata <= C_ROW(127-8*WR_placemark downto 96-8*WR_placemark);	
		-- 	--This loop is to ensure that THIS process doesnt move forward but will be interupted and go to the waiting state for memory to deal with the 8 bits of input
		-- 	--When WR_placemark reaches 15, we will be writing the last 8 bits of the set to memory. When WR_placemark is 16, there are no more bits to write and writing is complete
		-- 	--WR_placemark is incremented in each wait cycle in the MEM_WAIT state, thus incrementing for the next byte to be written as necessary.
		-- 	while WR_placemark < 16	loop
		-- 		next_state <= MEMORY_WAIT;
		-- 	end loop;
		-- 	--Done writing to memory at this point so we can set m_write low.
		-- 	m_write <= '0';
		-- 	mem_write <= '0';
	
		-- 	--Proceed to reading the item from memory

		-- 	mem_read <= '1';
		-- 	m_addr <= to_integer(unsigned(s_addr));
		-- 	next_state <= MEMORY_READ;
			
---------------------------------------------
		-- when MEMORY_READ =>
		-- 	report "DEBUG: S=MEMORY_READ";
		--   ---Must read data from memory, since it was not found in the cache
	
		-- 	--while RD_placemark < 16 loop
		-- 	--	next_state <= MEMORY_WAIT;
		-- 	--end loop;

		-- 	if RD_placemark < 16 then
		-- 		m_read <= '1';
		-- 		mem_read <= '1';
		-- 		next_state <= MEMORY_WAIT;
		-- 	else
			
		-- 	-- Put the data items from memory in the row and build a new row with all its elements and place in the cache
		-- 	C_ROW(127 downto 0) <= C_DATA;
		-- 	C_ROW(135 downto 128) <= C_TAG;
		-- 	C_ROW(137 downto 136) <= "01";
		-- 	CACHE(to_integer(unsigned(C_INDEX))) <= C_ROW;
			
		--   	m_read <= '0';
		-- 	mem_read <= '0';

		-- 	-- If we came from a read miss go back to read hit as it is now in the cache
		-- 	if(s_read = '1') then
		-- 		next_state <= CACHE_READ_HIT;

		-- 	-- If we came from a write miss go back to write hit as it is now in the cache
		-- 	elsif(s_write = '1') then
		-- 		next_state <= CACHE_WRITE_HIT;
			
		-- 	-- Something went wrong...
		-- 	else
		-- 		s_waitrequest <= '0';
		-- 		next_state <= ENTRY;
		--   	end if;
		-- 	end if;

---------------------------------------------
		-- when MEMORY_WAIT =>
		-- 	report "DEBUG: S=MEMORY_WAIT";
		-- 	--We are waiting until the memory has completed an operation, so we loop "forever"
		-- 	--while true loop

		-- 		--If m_write is 1, then we are writing to the memory, thus defining the return path to the calling state				
		-- 		if(mem_write = '1') then
		-- 			--If memory sets m_waitrequest low it has finished its memory operation and we can return to the write state
		-- 			if(m_waitrequest = '0') then
		-- 				--Increment WR_placemark so when we return to the WR_WB state it will know to send the next byte in the data set
		-- 				WR_placemark := WR_placemark + 1;
		-- 				m_write <= '0';
		-- 				next_state <= MEMORY_EVICT;
		-- 			end if;	

		-- 		--If m_read is 1, then we are read from the memory, thus defining the return path to the calling state
		-- 		elsif(mem_read = '1') then
		-- 			--If memory sets m_waitrequest low it has finished its memory operation and we can return to the read state					
		-- 			if(m_waitrequest = '0') then
		-- 				C_DATA(127-8*RD_placemark downto 120-8*RD_placemark) <= m_readdata;
		-- 				RD_placemark := RD_placemark + 1;
		-- 				m_read <= '0';
		-- 				next_state <= MEMORY_READ;
		-- 			end if;		
		-- 			report "MEMREAD WAIT";		
		-- 		end if;
		-- 	--end loop;
	end case;
end if;
end process state_behaviour;

end arch;
