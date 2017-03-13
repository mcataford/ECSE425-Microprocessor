library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL is

    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION : in std_logic_vector(31 downto 26);
        ---Outputs---
        REG_DEST : out std_logic;
        BRANCH : out std_logic;
        MEM_READ : out std_logic;
        MEM_TO_REG : out std_logic;
        ALU_OP : out std_logic_vector(3 downto 0);
        MEM_WRITE : out std_logic;
        ALU_SRC : out std_logic;
        REG_WRITE : out std_logic;
        GET_HI : out std_logic;
        GET_LO : out std_logic;
        CONTROL_LINK : out std_logic
    )
end CONTROL;

architecture arch of CONTROL is
    signal output : std_logic_vector(6 downto 0);
    signal opOut : std_logic_vector(3 downto 0);
    signal getHi : std_logic := '0';
    signal getLo : std_logic := '0';
    signal controlLink : std_logic := '0';
    begin
        control_logic : process (INSTRUCTION)
            begin
                --ADD--
                if INSTRUCTION <= "100000" then
                    output <= "1000001"
                    opOut <= "0000";
                --SUB--
                elsif INSTRUCTION <= "100010" then
                    output <= "1000001"
                    opOut <= "0000";
                --ADDI--
                elsif INSTRUCTION <= "001000" then
                    output <= "0000011";
                    opOut <= "0000";
                --MULT--
                elsif INSTRUCTION <= "011000" then
                    output <= "1000001";
                    opOut <= "0101";
                --DIV--
                elsif INSTRUCTION <= "011010" then
                    ouput <= "1000001";
                    opOut <= "0110";
                --SLT--
                elsif INSTRUCTION <= "101010" then
                    ouput <= "1000001";
                    opOut <= "0000";
                --SLTI--
                elsif INSTRUCTION <= "001010" then
                    output <= "0000011";
                    opOut <= "0000";
                --AND--
                elsif INSTRUCTION <= "100100" then
                    ouput <= "1000001";
                    opOut <= "0001";
                --OR--
                elsif INSTRUCTION <= "100101" then
                    output <= "1000001";
                    opOut <= "0010";
                --NOR--
                elsif INSTRUCTION <= "100111" then
                    output <= "1000001";
                    opOut <= "0100";
                --XOR--
                elsif INSTRUCTION <= "100110" then
                    output <= "1000001";
                    opOut <= "0011";
                --ANDI--
                elsif INSTRUCTION <= "001100" then
                    output <= "0000011";
                    opOut <= "0001";
                --ORI--
                elsif INSTRUCTION <= "001101" then
                    output <= "0000011";
                    opOut <= "0010";
                --XORI--
                elsif INSTRUCTION <= "100110" then
                    output <= "0000011";
                    opOut <= "0011";
                --MFHI--
                elsif INSTRUCTION <= "010000" then
                    output <= "1000001";
                    opOut <= "0000";
                    getHi <= '1';
                --MFLO--
                elsif INSTRUCTION <= "010010" then
                    output <= "1000001";
                    opOut <= "0000";
                    getLo <= '1';
                --LUI--
                elsif INSTRUCTION <= "001111" then
                    output <= "0000011";
                    opOut <= "0000";
                --SLL--
                elsif INSTRUCTION <= "000000" then
                    output <= "1000001";
                    opOut <= "0101";
                --SRL--
                elsif INSTRUCTION <= "000010" then
                    output <= "1000001";
                    opOut <= "0101";
                --SRA--
                elsif INSTRUCTION <= "000011" then
                    output <= "1000001";
                    opOut <= "0101";
                --LW--
                elsif INSTRUCTION <= "100011" then
                    output <= "0011011";
                    opOut <= "0000";
                --SW--
                elsif INSTRUCTION <= "101011" then
                    output <= "0000110";
                    opOut <= "0000"
                --BEQ--
                --FIX ALU_OP for branches
                elsif INSTRUCTION <= "000100" then
                    output <= "0100010";
                    opOut <= "0000";
                --BNE--
                elsif INSTRUCTION <= "000101" then
                    output <= "01000110";
                    opOut <= "0000";
                --J--
                elsif INSTRUCTION <= "000010" then
                    output <= "1100010";
                    opOut <= "0000";
                --JR--
                elsif INSTRUCTION <= "001000" then
                    output <= "0100010";
                    opOut <= "0000";
                --JAL--
                elsif INSTRUCTION <= "000011" then
                    output <= "0100010";
                    opOut <= "0000";
                    controlLink <= '1';
                else
                    output <= "0000000";
                    opOut <= "1111";
                end if;

                REG_DEST <= output(0);
                BRANCH <= output(1);
                MEM_READ <= output(2);
                MEM_TO_REG <= output(3);
                MEM_WRITE <= output(4);
                ALU_SRC <= output(5);
                REG_WRITE <= output(6);
                ALU_OP <= opOut;

                CONTROL_LINK <= controlLink;
                GET_HI <= getHi;
                GET_LO <= getLo;
        end process control_logic;

end arch;