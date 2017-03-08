library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity PC_Register is    
	port(
		CLK: in std_logic;	
		RESET: in std_logic;
		DATA_IN: in std_logic_vector(31 downto 0);
		DATA_OUT: out std_logic_vector(31 downto 0)
	);
end PC_Register;

architecture arch of PC_Register is        
begin
	process(CLK,RESET,DATA_IN)
		begin
			if(RESET = '1') then
				DATA_OUT <= (others => '0');
			elsif rising_edge(CLK) then
				DATA_OUT <= DATA_IN;
			end if;
	end process; 
end arch;