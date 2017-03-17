library IEEE;

use ieee.std_logic_1164.all;

entity IF_ID_REGISTER is
    port(
        --Inputs--
        --Change as required--
 
        PC_IN,
        INSTRUCTION_IN : in std_logic_vector(31 downto 0);
        --Outputs--
        --Change as required--
        PC_OUT,
        INSTRUCTION_OUT : out std_logic_vector(31 downto 0)
    );

end IF_ID_REGISTER;


architecture arch of IF_ID_REGISTER is
    
    signal values : std_logic_vector(63 downto 0);

    begin

        pipeline_buffer : process(CLOCK)
            if(falling_edge(CLOCK)) then
                values(31 downto 0) <= PC_IN;
                values(63 downto 32) <= INSTRUCTION_IN;
            end if;

        PC_OUT <= values(31 downto 0);
        INSTRUCTION_OUT <= values(63 downto 32);

end arch;
