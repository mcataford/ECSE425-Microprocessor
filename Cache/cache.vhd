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
type state_type is (ENTRY,DECODE,CACHE_WRITE,CACHE_WRITE_HIT,CACHE_READ,CACHE_READ_HIT,MEMORY_EVICT,MEMORY_READ,MEMORY_WAIT);

--- Cache array
--- Cache array location | 2 Flags | 25 Tag | 128 Data |
--- 32 blocks leads to array size
--- 155 bits per location in cache array = 2 bits dirty/valid + 25 bits of tag + 128 bits of data
type MEM is array (31 downto 0) of STD_LOGIC_VECTOR(154 downto 0);
signal CACHE : MEM;

-- Current and next state signals
-- Entry point is state A.
signal current_state: state_type := ENTRY;
signal next_state: state_type;

signal C_TAG : STD_LOGIC_VECTOR (24 downto 0);
signal C_INDEX : STD_LOGIC_VECTOR (4 downto 0);
signal C_OFFSET : STD_LOGIC_VECTOR (1 downto 0);
signal C_ROW : STD_LOGIC_VECTOR(154 downto 0);
signal C_DATA : STD_LOGIC_VECTOR (127 downto 0);

signal WR_START : INTEGER;
signal WR_END : INTEGER;
signal WR_placemark : INTEGER;
signal RD_placemark : INTEGER;

signal mem_read : STD_LOGIC;
signal mem_write : STD_LOGIC;

signal t_addr : STD_LOGIC_VECTOR (31 downto 0);

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
	-- Make init state at some point
	-- Branch to behavioural segment based on current state signal.
	case current_state is
		when ENTRY =>
			m_read <= '0';
			m_write <= '0';
			mem_read <= '0';
			mem_write <= '0';
			if(s_read = '0' or s_write = '0') then
				next_state <= ENTRY;
			else
				next_state <= DECODE;
			end if;
		
		when DECODE =>
			
			s_waitrequest <= '1';
			--- Decoding inputs and putting them in signals	
			C_TAG <= s_addr(31 downto 7);
			C_INDEX <= s_addr(6 downto 2);
			C_OFFSET <= s_addr(1 downto 0);
			--- Determining next course of action (read or write)
			if (s_read = '1' AND s_write = '0') then
				next_state <= CACHE_READ;
			elsif (s_read = '0' AND s_write = '1') then
				next_state <= CACHE_WRITE;
			else
				s_waitrequest <='0';
			 	next_state <= ENTRY;
			end if;

		when CACHE_WRITE =>
			---Writing
			---Find index in cache and compare tags
			C_ROW <= CACHE(to_integer(unsigned(C_INDEX)));
			if (C_ROW(152 downto 128) = C_TAG) then
				next_state <= CACHE_WRITE_HIT;
			elsif (C_ROW(152 downto 128) /= C_TAG) then
				WR_placemark <= 0;
				mem_write <= '1';
				m_write <= '1';
				next_state <= MEMORY_EVICT;
			end if;

		when CACHE_WRITE_HIT =>
			---Write Hit
			---Write word to corresponding word in block, specified by block offset
			---WR_START is the LSB of the word being written to
			---WR_END is the MSB of the word being written to
			---Example: given address has offset 2 means third word from the right in block
			---C_ROW = |Flags|Tag|Word|>Word<|Word|Word|
			---Its LSB is WR_START and MSB is WR_END

			WR_START <= to_integer(unsigned(C_OFFSET)) * 32;
			WR_END <= to_integer(unsigned(C_OFFSET)) * 32 + 31;
			
			---Write changes to block's word
			C_ROW(WR_END downto WR_START) <= s_writedata(31 downto 0);
			---Set dirty bit
			C_ROW(154) <= '1';
			---Put back in cache at index location
			CACHE(to_integer(unsigned(C_INDEX))) <= C_ROW;
			---Deassert waitrequest
			s_waitrequest <= '0';
			---Go back to top
			next_state <= ENTRY;
			
		when CACHE_READ =>
		  ---Reading
		  ---Find index in cache and compare tags
			C_ROW <= CACHE(to_integer(unsigned(C_INDEX)));
			if (C_ROW(152 downto 128) = C_TAG) then
				next_state <= CACHE_READ_HIT;
			elsif (C_ROW(152 downto 128) /= C_TAG) then
			  	RD_placemark <= 0;
			  	mem_read <= '1';
				m_read <= '1';
				next_state <= MEMORY_EVICT;
			end if;
			
		when CACHE_READ_HIT =>
		  ---Depending on the input address' offset, the proper 32 bit word block gets read from the cache
		  ---There are four possible word blocks to choose from
		  ---Once read, the program goes back to the starting state
			if(C_OFFSET = "00") then
				s_readdata <= C_ROW(31 downto 0);
				s_waitrequest <= '0';
				next_state <= ENTRY;
		  	elsif(C_OFFSET = "01") then
		    		s_readdata <= C_ROW(63 downto 32);
		    		s_waitrequest <= '0';
		    		next_state <= ENTRY;
		  	elsif(C_OFFSET = "10") then
		    		s_readdata <= C_ROW(95 downto 64);
		    		s_waitrequest <= '0';
		    		next_state <= ENTRY;
		  	elsif(C_OFFSET = "11") then
		   		s_readdata <= C_ROW(127 downto 96);
		    		s_waitrequest <= '0';
		    		next_state <= ENTRY;
		  	end if;
		
		when MEMORY_EVICT =>
		  --Writing back is done in 3 stages using the Avalon interface:
		  --memwrite / data and address are asserted
		  --They are maintained while waitrequest is asserted by the slave
		  --When waitrequest is deasserted, the signals are deasserted on the master's end.

			--Check if cache location is dirty
			--Only need to write back to memory if it has been changed since it was first pulled from memory
			if(C_ROW(154 downto 154) = '1') then
				--Set the address we are writing to equal to the one we are evicting from cache
				m_addr <= to_integer(unsigned(C_ROW(152 downto 128) & C_INDEX & "00"));
				--Send 8 bits to the memory
				m_writedata <= C_ROW(127-8*WR_placemark downto 119-8*WR_placemark);	
				--This loop is to ensure that THIS process doesnt move forward but will be interupted and go to the waiting state for memory to deal with the 8 bits of input
				--When WR_placemark reaches 15, we will be writing the last 8 bits of the set to memory. When WR_placemark is 16, there are no more bits to write and writing is complete
				--WR_placemark is incremented in each wait cycle in the MEM_WAIT state, thus incrementing for the next byte to be written as necessary.
				while WR_placemark < 16	loop
					next_state <= MEMORY_WAIT;
				end loop;
				--Done writing to memory at this point so we can set m_write low.
				m_write <= '0';
			end if;
			--Proceed to reading the item from memory
			--FROM THE RD_MISS STATE WE CAN GO TO WR_HIT AND WRITE TO THE NEWLY LOADED ITEM
			m_write <= '0';
			mem_write <= '0';
			m_read <= '1';
			mem_read <= '1';
			m_addr <= to_integer(unsigned(s_addr));
			next_state <= MEMORY_READ;

		when MEMORY_READ =>
		  ---Must read data from memory, since it was not found in the cache
	
			while RD_placemark < 16 loop
				next_state <= MEMORY_WAIT;
			end loop;
			
			C_ROW(127 downto 0) <= C_DATA;
			C_ROW(152 downto 128) <= C_TAG;
			C_ROW(154 downto 153) <= "01";
			CACHE(to_integer(unsigned(C_INDEX))) <= C_ROW;
			
		  	m_read <= '0';
			mem_read <= '0';
		  	s_waitrequest <= '0';
			if(s_read = '1') then
				next_state <= CACHE_READ_HIT;
			elsif(s_write = '1') then
				next_state <= CACHE_WRITE_HIT;
			else
				next_state <= ENTRY;
		  	end if;

		when MEMORY_WAIT =>
			--We are waiting until the memory has completed an operation, so we loop "forever"
			while true loop
				--If m_read is 1, then we are read from the memory, thus defining the return path to the calling state
				if(mem_read = '1') then
					--If memory sets m_waitrequest low it has finished its memory operation and we can return to the read state					
					if(m_waitrequest = '0') then
						C_DATA(127-8*RD_placemark downto 119-8*RD_placemark) <= m_readdata;
						RD_placemark <= RD_placemark + 1;
						next_state <= MEMORY_READ;
					end if;
				end if;
				--If m_write is 1, then we are writing to the memory, thus defining the return path to the calling state				
				if(mem_write = '1') then
					--If memory sets m_waitrequest low it has finished its memory operation and we can return to the write state
					if(m_waitrequest = '0') then
						--Increment WR_placemark so when we return to the WR_WB state it will know to send the next byte in the data set
						WR_placemark <= WR_placemark + 1;
						next_state <= MEMORY_EVICT;
					end if;
				end if;
			end loop;
	end case;
end process state_behaviour;

end arch;
