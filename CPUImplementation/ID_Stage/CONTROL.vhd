library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL is

    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION_OP: in std_logic_vector(31 downto 26);
        INSTRUCTION_FUNC : in std_logic_vector(5 downto 0);
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
        CONTROL_JAL : out std_logic
    );
end CONTROL;

architecture arch of CONTROL is
    signal output : std_logic_vector(6 downto 0);
    signal opOut : std_logic_vector(3 downto 0);
    signal getHi : std_logic := '0';
    signal getLo : std_logic := '0';
    signal controlLink : std_logic := '0';
    begin
        control_logic : process (CLOCK)
            begin
                --R type--
                if INSTRUCTION_OP <= "000000" then
                    --ADD--
                    if INSTRUCTION_FUNC <= "000001"
                        output <= "1000001";
                        opOut <= "0000";
                    --SUB--
                    elsif INSTRUCTION_FUNC <= "100010" then
                        output <= "1000001";
                        opOut <= "0000";
                    --Mult--
                    elsif INSTRUCTION_FUNC <= "011000" then
                        output <= "1000001";
                        opOut <= "0101";
                    --DIV--
                    elsif INSTRUCTION_FUNC <= "011010" then
                        output <= "1000001";
                        opOut <= "0110";
                    --SLT--
                    elsif INSTRUCTION_FUNC <= "101010" then
                        output <= "1000001";
                        opOut <= "0000";
                    --AND--
                    elsif INSTRUCTION_FUNC <= "100100" then
                        output <= "1000001";
                        opOut <= "0001";
                    --OR--
                    elsif INSTRUCTION_FUNC <= "100101" then
                        output <= "1000001";
                        opOut <= "0010";
                    --NOR--
                    elsif INSTRUCTION_FUNC <= "100111" then
                        output <= "1000001";
                        opOut <= "0100";
                     --XOR--
                    elsif INSTRUCTION_FUNC <= "100110" then
                        output <= "1000001";
                        opOut <= "0011";
                    --MFHI--
                    elsif INSTRUCTION_FUNC <= "010000" then
                        output <= "1000001";
                        opOut <= "0000";
                        getHi <= '1';
                    --MFLO--
                    elsif INSTRUCTION_FUNC <= "010010" then
                        output <= "1000001";
                        opOut <= "0000";
                        getLo <= '1';
                    --SLL--
                    elsif INSTRUCTION_FUNC <= "000000" then
                        output <= "1000001";
                        opOut <= "0101";
                    --SRL--
                    elsif INSTRUCTION_FUNC <= "000010" then
                        output <= "1000001";
                        opOut <= "0101";
                    --SRA--
                    elsif INSTRUCTION_FUNC <= "000011" then
                        output <= "1000001";
                        opOut <= "0101";
                    else
                        output <= "0000000";
                        opOut <= "1111";
                    end if;
                    --R Type End--
                --ADDI--
                elsif INSTRUCTION_OP <= "001000" then
                    output <= "0000011";
                    opOut <= "0000";
                --SLTI--
                elsif INSTRUCTION_OP <= "001010" then
                    output <= "0000011";
                    opOut <= "0000";
                --ANDI--
                elsif INSTRUCTION_OP <= "001100" then
                    output <= "0000011";
                    opOut <= "0001";
                --ORI--
                elsif INSTRUCTION_OP <= "001101" then
                    output <= "0000011";
                    opOut <= "0010";
                --XORI--
                elsif INSTRUCTION_OP <= "100110" then
                    output <= "0000011";
                    opOut <= "0011";
                --LUI--
                elsif INSTRUCTION_OP <= "001111" then
                    output <= "0000011";
                    opOut <= "0000";
                --LW--
                elsif INSTRUCTION_OP <= "100011" then
                    output <= "0011011";
                    opOut <= "0000";
                --SW--
                elsif INSTRUCTION_OP <= "101011" then
                    output <= "0000110";
                    opOut <= "0000";
                --BEQ--
                --FIX ALU_OP for branches
                elsif INSTRUCTION_OP <= "000100" then
                    output <= "0100010";
                    opOut <= "0000";
                --BNE--
                elsif INSTRUCTION_OP <= "000101" then
                    output <= "01000110";
                    opOut <= "0000";
                --J--
                elsif INSTRUCTION_OP <= "000010" then
                    output <= "1100010";
                    opOut <= "0000";
                --JR--
                elsif INSTRUCTION_OP <= "001000" then
                    output <= "0100010";
                    opOut <= "0000";
                --JAL--
                elsif INSTRUCTION_OP <= "000011" then
                    output <= "0100010";
                    opOut <= "0000";
                    controlLink <= '1';
                else
                    output <= "0000000";
                    opOut <= "1111";
                end if;
        end process control_logic;
        REG_DEST <= output(0);
        BRANCH <= output(1);
        MEM_READ <= output(2);
        MEM_TO_REG <= output(3);
        MEM_WRITE <= output(4);
        ALU_SRC <= output(5);
        REG_WRITE <= output(6);
        ALU_OP <= opOut;

        CONTROL_JAL <= controlLink;
        GET_HI <= getHi;
        GET_LO <= getLo;
end arch;