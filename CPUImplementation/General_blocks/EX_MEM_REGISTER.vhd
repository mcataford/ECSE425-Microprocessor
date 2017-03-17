library IEEE;

use ieee.std_logic_1164.all;

entity EX_MEM_REGISTER is
    port(
        --Inputs--
        --Change as required--
        CLOCK,
        CONTROL_BRANCH_IN,
        CONTROL_ZERO_IN,
        CONTROL_MEM_READ_IN,
        CONTROL_MEM_WRITE_IN,  
        CONTROL_MEM_TO_REG_IN : in std_logic;

        PC_IN,
        ALU_RESULT_IN,
        WRITE_DATA_IN : in std_logic_vector(31 downto 0);
        
        REG_WRITE_IN: in std_logic_vector(4 downto 0);

        --Outputs--
        --Change as required--
        CONTROL_BRANCH_OUT,
        CONTROL_ZERO_OUT,
        CONTROL_MEM_READ_OUT,
        CONTROL_MEM_WRITE_OUT,
        CONTROL_MEM_TO_REG_OUT : out std_logic;

        PC_OUT,
        ALU_RESULT_OUT,
        WRITE_DATA_OUT : out std_logic_vector(31 downto 0);

        REG_WRITE_OUT : out std_logic_vector(4 downto 0)

    );

end EX_MEM_REGISTER;


architecture arch of EX_MEM_REGISTER is
    
    signal control : std_logic_vector(4 downto 0);
    signal registers : std_logic_vector(4 downto 0);
    signal values : std_logic_vector(95 downto 0);

    begin

        pipeline_buffer : process(CLOCK)
            if(falling_edge(CLOCK)) then
                control(0) <= CONTROL_BRANCH_IN;
                control(1) <= CONTROL_ZERO_IN;
                control(2) <= CONTROL_MEM_READ_IN;
                control(3) <= CONTROL_MEM_WRITE_IN;
                control(4) <= CONTROL_MEM_TO_REG_IN;
            
                registers <= REG_WRITE_IN;
                
                values(31 downto 0) <= PC_IN;
                values(63 downto 32) <= ALU_RESULT_IN;
                values(95 downto 63) <= WRITE_DATA_IN;
            end if;

        CONTROL_BRANCH_OUT <= control(0);
        CONTROL_ZERO_OUT <= control(1);
        CONTROL_MEM_READ_OUT <= control(2);
        CONTROL_MEM_WRITE_OUT <= control(3);
        CONTROL_MEM_TO_READ_OUT <= control(4);

        REG_WRITE_OUT <= registers;

        PC_OUT <= values(31 downto 0);
        ALU_RESULT_OUT <= values(63 downto 32);
        WRITE_DATA_IN <= values(95 downto 63);

end arch;
