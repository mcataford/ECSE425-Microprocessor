library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CACHE_ARBITER is
    port(
        --Input Pipeline
        CLOCK : in std_logic;
        ADDRESS : in std_logic_vector(31 downto 0);
        DATA_IN : in std_logic_vector(31 downto 0);
        RD: in std_logic;
        WR : in std_logic;


        --Input Memory
        WAITREQUEST : in std_logic;


        --Output TO Pipeline
        ENABLE_OUT : out std_logic;
        DATA_OUT : out std_logic

        --Output TO Cache
        C_ADDR : out std_logic_vector(31 downto 0);
        C_WRITEDATA : out std_logic_vector(31 downto 0);
        C_
        C_RD : out std_logic;
        C_WR : out std_logic;
        C_

    );

end entity;

architecture arch of CACHE_ARBITER is

type state_type is (READY,REQUEST,SERVICE);
signal current_state: state_type := READY;
signal next_state: state_type;

    begin

        state_transitions : process(clock)
            begin
            if(rising_edge(clock)) then
                current_state <= next_state;
            end if;
        end process state_transitions

        arbitrate : process(clock)
            begin
                case current_state is
                        when READY =>
                            if(RD = '1' OR WR = '1') then
                                ENABLE_OUT <= '0';
                                next_state <= REQUEST;
                            else
                                next_state <= READY;
                            end if;
                        when REQUEST =>

                        when SERVICE =>
                        when others =>
                    


                end case;
        end process arbitrate;



end arch;