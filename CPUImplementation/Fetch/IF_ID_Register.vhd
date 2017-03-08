library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity IF_ID_Register is 
    port(
	      CLK: in std_logic;
			RESET: in std_logic;
	      PC_ADDR_IN: in std_logic_vector(31 downto 0);
	      INSTR_IN: in std_logic_vector(31 downto 0);
	      PC_ADDR_OUT: out std_logic_vector(31 downto 0);
	      INSTR_OUT: out std_logic_vector(31 downto 0)
        );
end IF_ID_Register;

architecture arch of IF_ID_Register is
begin
	process(CLK,RESET,PC_ADDR_IN,INSTR_IN)
		begin
			if RESET = '1' then
				PC_ADDR_OUT	<= (others => '0');
				INSTR_OUT <= (others => '0');
			elsif rising_edge(CLK) then
				PC_ADDR_OUT	<= PC_ADDR_IN;
				INSTR_OUT <= INSTR_IN;
			end if;
	end process; 
end arch;