--PC register block used before the fetch register. Can be reset and is similar to a delay block.

library IEEE;
use IEEE.std_logic_1164.all;		

entity PC_Register is    
port(
	CLOCK,RESET,REG_WRITE: in std_logic;	
	DATA_IN: in std_logic_vector(31 downto 0);
	DATA_OUT: out std_logic_vector(31 downto 0)
);
end entity;

architecture PC_Register_Impl of PC_Register is        

signal MEM: std_logic_vector(31 downto 0) := (others => '0');

begin
	process(CLOCK,RESET)
		begin
			if RESET = '1' then
				MEM <= (others => '0'); --Resets the value to 0 (to initialize it)
			elsif rising_edge(CLOCK) then
				if REG_WRITE = '1' then
					MEM <= DATA_IN; --Outputs the given 32 bit of data
				end if;
			end if;
	end process;

	DATA_OUT <= MEM; 
end architecture;