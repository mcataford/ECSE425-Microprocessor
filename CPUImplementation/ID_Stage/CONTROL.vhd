library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CONTROL is

    port(
        ---Inputs---
        INSTRUCTION_OP: in std_logic_vector(31 downto 26);
        INSTRUCTION_FUNC : in std_logic_vector(5 downto 0);
        ---Outputs---
        REG_DEST : out std_logic;
        BRANCH : out std_logic;
        MEM_READ : out std_logic;
        MEM_TO_REG : out std_logic;
        MEM_WRITE : out std_logic;
        ALU_SRC : out std_logic;
        REG_WRITE : out std_logic;
        ALU_OP : out std_logic_vector(3 downto 0);
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
        control_logic : process (INSTRUCTION_OP)
            begin
                getHi <= '0';
                getLo <= '0';
                controlLink <= '0';
                case INSTRUCTION_OP is
                    --R type--
                    when "000000" =>
                        --ADD--
                        if INSTRUCTION_FUNC = "000001" then
                            output <= "1000001";
                            opOut <= "0000";
                        --SUB--
                        elsif INSTRUCTION_FUNC = "100010" then
                            output <= "1000001";
                            opOut <= "0000";
                        --Mult--
                        elsif INSTRUCTION_FUNC = "011000" then
                            output <= "1000001";
                            opOut <= "0101";
                        --DIV--
                        elsif INSTRUCTION_FUNC = "011010" then
                            output <= "1000001";
                            opOut <= "0110";
                        --SLT--
                        elsif INSTRUCTION_FUNC = "101010" then
                            output <= "1000001";
                            opOut <= "0000";
                        --AND--
                        elsif INSTRUCTION_FUNC = "100100" then
                            output <= "1000001";
                            opOut <= "0001";
                        --OR--
                        elsif INSTRUCTION_FUNC = "100101" then
                            output <= "1000001";
                            opOut <= "0010";
                        --NOR--
                        elsif INSTRUCTION_FUNC = "100111" then
                            output <= "1000001";
                            opOut <= "0100";
                        --XOR--
                        elsif INSTRUCTION_FUNC = "100110" then
                            output <= "1000001";
                            opOut <= "0011";
                        --MFHI--
                        elsif INSTRUCTION_FUNC = "010000" then
                            output <= "1000001";
                            opOut <= "0000";
                            getHi <= '1';
                        --MFLO--
                        elsif INSTRUCTION_FUNC = "010010" then
                            output <= "1000001";
                            opOut <= "0000";
                            getLo <= '1';
                        --SLL--
                        elsif INSTRUCTION_FUNC = "000000" then
                            output <= "1000001";
                            opOut <= "0101";
                        --SRL--
                        elsif INSTRUCTION_FUNC = "000010" then
                            output <= "1000001";
                            opOut <= "0101";
                        --SRA--
                        elsif INSTRUCTION_FUNC = "000011" then
                            output <= "1000001";
                            opOut <= "0101";
                       --JR--
                        elsif INSTRUCTION_FUNC = "001000" then
                            output <= "0100010";
                            opOut <= "0000";
                        else
                            output <= "0000000";
                            opOut <= "1111";
                        end if;
                        --R Type End--
                --ADDI--
                when "001000" =>
                    output <= "0000011";
                    opOut <= "0000";
                --SLTI--
                when "001010" =>
                    output <= "0000011";
                    opOut <= "0000";
                --ANDI--
                when "001100" =>
                    output <= "0000011";
                    opOut <= "0001";
                --ORI--
                when "001101" =>
                    output <= "0000011";
                    opOut <= "0010";
                --XORI--
                when "100110" =>
                    output <= "0000011";
                    opOut <= "0011";
                --LUI--
                when "001111" =>
                    output <= "0000011";
                    opOut <= "0000";
                --LW--
                when "100011" =>
                    output <= "0011011";
                    opOut <= "0000";
                --SW--
                when "101011" =>
                    output <= "0000110";
                    opOut <= "0000";
                --BEQ--
                --FIX ALU_OP for branches
                when "000100" =>
                    output <= "0100010";
                    opOut <= "0000";
                --BNE--
                when "000101" =>
                    output <= "0100011";
                    opOut <= "0000";
                --J--
                when "000010" =>
                    output <= "1100010";
                    opOut <= "0000";                    
                --JAL--
                when "000011" =>
                    output <= "0100010";
                    opOut <= "0000";
                    controlLink <= '1';
                when others =>
                    output <= "0000000";
                    opOut <= "1111";
                end case;

            CONTROL_JAL <= controlLink;
            GET_HI <= getHi;
            GET_LO <= getLo;


            REG_DEST <= output(6);
            BRANCH <= output(5);
            MEM_READ <= output(4);
            MEM_TO_REG <= output(3);
            MEM_WRITE <= output(2);
            ALU_SRC <= output(1);
            REG_WRITE <= output(0);
            ALU_OP <= opOut;
        end process control_logic;



end arch;