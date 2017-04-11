library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEM_STAGE_tb is
end entity;

architecture MEM_STAGE_tst of MEM_STAGE_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal CLOCK, RESET: std_logic;
	signal CONTROL_VECTOR: std_logic_vector(11 downto 0);
	signal DATA_ADDRESS, DATA_PAYLOAD, DATA_OUT: std_logic_vector(31 downto 0);

	component MEM_STAGE
	
		port(
			--INPUT
			--Clock
			CLOCK: in std_logic;
			--Reset
			RESET: in std_logic;
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(11 downto 0);
			--Results from ALU
			DATA_ADDRESS: in std_logic_vector(31 downto 0);
			--B fwd
			DATA_PAYLOAD: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			DATA_OUT: out std_logic_vector(31 downto 0)
		);
		
	end component;
	
begin

	MEM_ST: MEM_STAGE port map(
		CLOCK,
		RESET,
		CONTROL_VECTOR,
		DATA_ADDRESS,
		DATA_PAYLOAD,
		DATA_OUT
	);
	
	CLK: process
	
	begin
	
		CLOCK <= '0';
		wait for 0.5 * CLK_PERIOD;
		CLOCK <= '1';
		wait for 0.5 * CLK_PERIOD;
	
	end process;
	
	TST: process
	
	begin
	
		RESET <= '0';
		CONTROL_VECTOR <= "000000100000";
		DATA_ADDRESS <= x"00000000";
		DATA_PAYLOAD <= std_logic_vector(to_unsigned(50,32));
		
		wait for 1 * CLK_PERIOD;
		
		CONTROL_VECTOR <= "000000100000";
		DATA_ADDRESS <= x"00000001";
		DATA_PAYLOAD <= std_logic_vector(to_unsigned(100,32));
		
		wait for 1 * CLK_PERIOD;
		
		CONTROL_VECTOR <= "000000010000";
		DATA_ADDRESS <= x"00000000";
	
		
		
		wait;
		
	end process;

end architecture;