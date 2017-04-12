library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_WB_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		ENABLE: in std_logic;
		--Reset
		RESET: in std_logic;
		--PC
		MEM_DATA: in std_logic_vector(31 downto 0);
		MEM_ADDR: in std_logic_vector(63 downto 0);
		MEM_INSTR: in std_logic_vector(31 downto 0);
		MEM_CONTROL_VECTOR: in std_logic_vector(11 downto 0);
		
		WB_DATA: out std_logic_vector(31 downto 0) := (others => 'Z');
		WB_ADDR: out std_logic_vector(63 downto 0) := (others => 'Z');
		WB_INSTR: out std_logic_vector(31 downto 0) := (others => 'Z');
		WB_CONTROL_VECTOR: out std_logic_vector(11 downto 0) := (others => 'Z')
	);
	
end entity;

architecture MEM_WB_REG_Impl of MEM_WB_REG is

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if RESET = '1' then
		
			WB_DATA <= (others => 'Z');
			WB_ADDR <= (others => 'Z');
			WB_INSTR <= (others => 'Z');
			WB_CONTROL_VECTOR <= (others => 'Z');
			
		elsif rising_edge(CLOCK) and ENABLE = '1' then
		
			WB_DATA <= MEM_DATA;
			WB_ADDR <= MEM_ADDR;
			WB_INSTR <= MEM_INSTR;
			WB_CONTROL_VECTOR <= MEM_CONTROL_VECTOR;

		end if;
		
	end process;

end architecture;