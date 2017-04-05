--Complete write back instruction. Only a multiplexer (in this case, built as a process) and proper connections.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_STAGE is
	port( 
		--Inputs
		MUX_SELECT: in std_logic; --Selector for the multiplexer
		READ_DATA, FORWARD_DATA: in std_logic_vector(31 downto 0); --Data from memory instruction
		--Outputs
		WRITE_DATA: out std_logic_vector(31 downto 0)	-- Outputs either data from fetch or memory instructions
	);
end entity;

architecture WB_STAGE_Impl of WB_STAGE is 

	component MUX
		port(
			A,B: in std_logic_vector(31 downto 0);
			SELECTOR: in std_logic;
			OUTPUT: out std_logic_vector(31 downto 0)
		);
	end component;

	begin

	MX : MUX port map(READ_DATA,FORWARD_DATA,MUX_SELECT,WRITE_DATA);

end architecture;