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
-- A:
-- B:
-- C:
-- D:
-- E:
-- F:
--- TODO: Define states based on diagram.
type state_type is (A,B,C,D,E,F);

-- Current and next state signals
-- Entry point is state A.
signal current_state: state_type := A;
signal next_state: state_type;

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
		when B =>
		when C =>
		when D =>
		when E =>
	
end process state_behaviour;

end arch;
