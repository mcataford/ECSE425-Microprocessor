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


        --Output
        ENABLE_OUT : out std_logic;
        DATA_OUT : out std_logic

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



                        when REQUEST =>
                        when SERVICE =>


                end case;
        end process arbitrate;





end arch;