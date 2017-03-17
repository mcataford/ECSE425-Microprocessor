library IEEE;

use ieee.std_logic_1164.all;

entity ID_EX_REGISTER is
    port(
        --Inputs--
        --Change as required--
        CLOCK,
        CONTROL_REG_DEST_IN,
        CONTROL_ALU_SRC_IN, 
        CONTROL_BRANCH_IN, 
        CONTROL_MEM_READ_IN,
        CONTROL_MEM_WRITE_IN, 
        CONTROL_MEM_TO_REG_IN : in std_logic;

        CONTROL_ALU_OP_IN : in std_logic_vector(3 downto 0);

        PC_IN,
        SIGN_EXTENDED_IN,
        REG_IN1,
        REG_IN2 : in std_logic_vector(31 downto 0);
        
        RT_IN,
        RD_IN : in std_logic_vector(4 downto 0);

        --Outputs--
        --Change as required--
        CONTROL_REG_DEST_OUT,
        CONTROL_ALU_SRC_OUT,
        CONTROL_BRANCH_OUT,
        CONTROL_MEM_READ_OUT,
        CONTROL_MEM_WRITE_OUT,
        CONTROL_MEM_TO_REG_OUT : out std_logic;

        CONTROL_ALU_OP_OUT : out std_logic_vector(3 downto 0);

        PC_OUT,
        SIGN_EXTENDED_OUT,
        REG_OUT1,
        REG_OUT2 : out std_logic_vector(31 downto 0);

        RT_OUT,
        RD_OUT : out std_logic_vector(4 downto 0)

    );

end ID_EX_REGISTER;


architecture arch of ID_EX_REGISTER is
    
    signal control : std_logic_vector(5 downto 0);
    signal registers : std_logic_vector(9 downto 0);
    signal values : std_logic_vector(127 downto 0);
    signal op : std_logic_vector(3 downto 0);

    begin

        pipeline_buffer : process(CLOCK)
            if(falling_edge(CLOCK)) then
                control(0) <= CONTROL_REG_DEST_IN;
                control(1) <= CONTROL_ALU_SRC_IN;
                control(2) <= CONTROL_BRANCH_IN;
                control(3) <= CONTROL_MEM_READ_IN;
                control(4) <= CONTROL_MEM_WRITE_IN;
                control(5) <= CONTROL_MEM_TO_READ_IN;
            
                op <= CONTROL_ALU_OP_IN;

                registers(4 downto 0) <= RT_IN;
                registers(9 downto 5) <= RD_IN;

                values(31 downto 0) <= PC_IN;
                values(63 downto 32) <= SIGN_EXTENDED_IN;
                values(95 downto 63) <= REG_IN1;
                values(127 downto 96) <= REG_IN2;
            end if;

        CONTROL_REG_DEST_OUT <= control(0);
        CONTROL_ALU_SRC_OUT <= control(1);
        CONTROL_BRANCH_OUT <= control(2);
        CONTROL_MEM_READ_OUT <= control(3);
        CONTROL_MEM_WRITE_OUT <= control(4);
        CONTROL_MEM_TO_READ_OUT <= control(5);

        CONTROL_ALU_OP_OUT <= op;

        RT_OUT <= values(4 downto 0);
        RD_OUT <= values(9 downto 5);

        PC_OUT <= values(31 downto 0);
        SIGN_EXTENDED_OUT <= values(63 downto 32);
        REG_OUT1 <= values(95 downto 63);
        REG_OUT2 <= values(127 downto 96);

end arch;
