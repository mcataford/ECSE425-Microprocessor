--The register used in between fetch and instruction decode instructions. Similar to a standard register block.

library IEEE;
use IEEE.std_logic_1164.all;		
use IEEE.numeric_std.all;

entity IF_ID_Register is 
    port(
	      CLK: in std_logic;
			  RESET: in std_logic;
	      PC_ADDR_IN: in std_logic_vector(31 downto 0); -- Input from the multiplexer (added PC address)
	      INSTR_IN: in std_logic_vector(31 downto 0); -- Input from the instruction memory
	      PC_ADDR_OUT: out std_logic_vector(31 downto 0); -- Output from the multiplexer (added PC address)
	      INSTR_OUT: out std_logic_vector(31 downto 0) -- Output from the instruction memory
        );
end IF_ID_Register;

architecture arch of IF_ID_Register is
begin
	process(CLK,RESET,PC_ADDR_IN,INSTR_IN)
		begin
			if RESET = '1' then -- Reset to initialize the outputs to 0
				PC_ADDR_OUT	<= (others => '0');
				INSTR_OUT <= (others => '0');
			elsif rising_edge(CLK) then -- Passing a given input as output
				PC_ADDR_OUT	<= PC_ADDR_IN;
				INSTR_OUT <= INSTR_IN;
			end if;
	end process; 
end arch;