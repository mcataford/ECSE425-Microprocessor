library IEEE;

use ieee.std_logic_1164.all;

entity IF_ID_REGISTER is
    port(
        --Inputs--
	CLOCK: in std_logic; 
        PC_IN,
        INSTR_IN : in std_logic_vector(31 downto 0);
        --Outputs--
        PC_OUT,
        INSTR_OUT : out std_logic_vector(31 downto 0):= (others => '0')
    );

end IF_ID_REGISTER;


architecture arch of IF_ID_REGISTER is

    signal PC_MEM, INSTR_MEM: std_logic_vector(31 downto 0) := (others => '0');

    begin

        process(CLOCK)
	
	begin

            if rising_edge(CLOCK) then
                INSTR_OUT <= INSTR_MEM;
		PC_OUT <= PC_MEM;
	
		PC_MEM <= PC_IN;
		INSTR_MEM <= INSTR_IN;

            end if;
	end process;

end arch;
