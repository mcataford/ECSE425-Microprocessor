--Complete write back instruction. Only a multiplexer (in this case, built as a process) and proper connections.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
port( 
	--Inputs
	RESET: in std_logic;	--Reset
	MUX_SELECT: in std_logic; --Selector for the multiplexer
	REGWRITE_IN: in	std_logic; --Bottom input
	READ_DATA: in std_logic_vector(31 downto 0); --Data from memory instruction
	ADDRESS: in std_logic_vector(31 downto 0);	--Data from fetch instruction
	--Outputs
	REGWRITE_OUT: out std_logic; --Bottom output
	WRITE_DATA: out std_logic_vector(31 downto 0)	-- Outputs either data from fetch or memory instructions
);
end write_back;

architecture arch of write_back is 
begin
	MUX: -- The multiplexer used
    process(RESET,MUX_SELECT,REGWRITE_IN,READ_DATA,ADDRESS)
		begin
			if(RESET = '1') then -- Initialization/resetting to 0
				REGWRITE_OUT <= '0';
				WRITE_DATA <= "00000000000000000000000000000000"; --Zero in 32 bits
			else
				REGWRITE_OUT <= REGWRITE_IN; --Bottom In/Out
			 	if(MUX_SELECT = '0') then
			 		WRITE_DATA <= ADDRESS; --Data from fetch instruction
			 	else
			 		WRITE_DATA <= READ_DATA; --Data from memory instruction
			 	end if;
			end if;
		end process MUX;
end arch;