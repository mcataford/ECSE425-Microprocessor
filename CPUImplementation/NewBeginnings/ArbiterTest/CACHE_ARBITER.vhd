library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CACHE_ARBITER is
    port(
        --Input Pipeline
        CLOCK : in std_logic;
        IF_ADDRESS, MEM_ADDRESS : in std_logic_vector(31 downto 0);
        IF_DATA_IN,MEM_DATA_IN : in std_logic_vector(31 downto 0);
				IF_RD: in std_logic;
        IF_WR : in std_logic;
				MEM_RD: in std_logic;
				MEM_WR: in std_logic;


        --Input Memory
        WAITREQUEST : in std_logic;

<<<<<<< HEAD

        --Output TO Pipeline
        ENABLE_OUT : out std_logic;
        DATA_OUT : out std_logic
=======
        --Output
        ENABLE : out std_logic;
				IF_DATA_OUT, MEM_DATA_OUT: out std_logic_vector(31 downto 0);
				
				CACHE_ADDR,CACHE_WRITEDATA: out std_logic_vector(31 downto 0);
				CACHE_WRITE,CACHE_READ: out std_logic;
				CACHE_READDATA: in std_logic_vector(31 downto 0)
>>>>>>> 26d66bc56e9c605a611addfbdd363953dc9b58d4

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
signal current_state, next_state: state_type := READY;

    begin
<<<<<<< HEAD

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
=======
		
			FSM: process(CLOCK)
			
				begin
			
				current_state <= next_state;
				
				if current_state = READY then
				
					if IF_RD = '1' or IF_WR = '1' or MEM_RD = '1' or MEM_WR = '1' then
					
						ENABLE <= '0';
						
						if IF_WR = '1' or IF_RD = '1' then
						
							CACHE_ADDR <= IF_ADDRESS;
							
						else
						
							CACHE_ADDR <= MEM_ADDRESS;
							
						end if;
						
						if IF_WR = '1' or MEM_WR = '1' then
						
							if IF_WR = '1' then
							
								CACHE_WRITEDATA <= IF_DATA_IN;
							
							else
							
								CACHE_WRITEDATA <= MEM_DATA_IN;
								
							end if;
							
							CACHE_WRITE <= '1';
							
						else
						
							CACHE_READ <= '1';
						
						end if;
						
						next_state <= REQUEST;
					
					end if;
					
				
				elsif current_state = REQUEST then
				
					if WAITREQUEST = '0' then
					
						if IF_WR = '1' or MEM_WR = '1' then
							CACHE_WRITE <= '0';
							
							if IF_WR = '1' then
								IF_DATA_OUT <= CACHE_READDATA;
							else
								MEM_DATA_OUT <= CACHE_READDATA;
							
							end if;
							
						else
							CACHE_READ <= '0';
						end if;
						
						ENABLE <= '1';
						next_state <= READY;
					
					end if;
				
				else
				
				end if;
					
			end process;

        -- state_transitions : process(clock)
            -- begin
            -- if(rising_edge(clock)) then
                -- current_state <= next_state;
            -- end if;
        -- end process state_transitions;

        -- -- arbitrate : process(clock)
            -- -- begin
                -- -- case current_state is
                        -- -- when READY =>



                        -- -- when REQUEST =>
                        -- -- when SERVICE =>


                -- -- end case;
        -- -- end process arbitrate;
				
			
>>>>>>> 26d66bc56e9c605a611addfbdd363953dc9b58d4



end arch;