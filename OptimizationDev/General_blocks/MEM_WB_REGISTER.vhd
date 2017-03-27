library IEEE;

use ieee.std_logic_1164.all;

entity EX_MEM_REGISTER is
    port(
        --Inputs--
        --Change as required--
        CLOCK,
        CONTROL_REG_WRITE_IN,  
        CONTROL_MEM_TO_REG_IN : in std_logic;

        PC_IN,
        READ_DATA_IN,
        ALU_ADDRESS_IN : in std_logic_vector(31 downto 0);
        
        REG_WRITE_IN: in std_logic_vector(4 downto 0);

        --Outputs--
        --Change as required--
        CONTROL_REG_WRITE_OUT,
        CONTROL_MEM_TO_REG_OUT : out std_logic;

        READ_DATA_OUT,
        ALU_ADDRESS_OUT : out std_logic_vector(31 downto 0);

        REG_WRITE_OUT : out std_logic_vector(4 downto 0)

    );

end EX_MEM_REGISTER;


architecture arch of EX_MEM_REGISTER is
    
    signal control : std_logic_vector(1 downto 0);
    signal registers : std_logic_vector(4 downto 0);
    signal values : std_logic_vector(63 downto 0);

    begin

        pipeline_buffer : process(CLOCK)
            if(falling_edge(CLOCK)) then
                control(0) <= CONTROL_REG_WRITE_IN;
                control(1) <= CONTROL_MEM_TO_REG_IN;
                           
                registers <= REG_WRITE_IN;
                
                values(31 downto 0) <= READ_DATA_IN;
                values(63 downto 32) <= ALU_ADDRESS_IN;
            end if;

        CONTROL_REG_WRITE_OUT <= control(0);
        CONTROL_MEM_TO_REG_OUT <= control(1);

        REG_WRITE_OUT <= registers;

        READ_DATA_OUT <= values(31 downto 0);
        ALU_ADDRESS_OUT <= values(63 downto 32);

end arch;
