library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REG_tb is
end entity;

architecture ID_EX_REG_tst of ID_EX_REG_tb is

signal CLOCK: std_logic;
signal CONTROL_IN,CONTROL_OUT: std_logic_vector(10 downto 0);
signal PC_IN,SIGN_EXTENDER_IN,REG_IN1,REG_IN2,INSTR_IN,PC_OUT,SIGN_EXTENDER_OUT,REG_OUT1,REG_OUT2,INSTR_OUT: std_logic_vector(31 downto 0);

constant CLK_PERIOD: time := 1 ns;

component ID_EX_REGISTER

    port(
        --Inputs--
        
	--CLOCK SIGNAL--
        CLOCK: in std_logic;

	--CONTROL SIGNALS IN--
	CONTROL_IN: in std_logic_vector(10 downto 0);
--
        --PROGRAM COUNTER IN--
	PC_IN,

        --SIGN EXTENDER IN--
	SIGN_EXTENDER_IN,

        --REGISTER DATA IN--
	REG_IN1,
        REG_IN2 : in std_logic_vector(31 downto 0);
	
	--INSTRUCTION IN--
	INSTR_IN: in std_logic_vector(31 downto 0);

        --Outputs--
       	--CONTROL SIGNALS OUT--
	CONTROL_OUT: out std_logic_vector(10 downto 0);

	--PROGRAM COUNTER OUT--
        PC_OUT,
	
	--SIGN EXTENDER OUT--
        SIGN_EXTENDER_OUT,

	--REGISTER DATA OUT--
        REG_OUT1,
        REG_OUT2 : out std_logic_vector(31 downto 0);
	
	--INSTRUCTION OUT--
	INSTR_OUT: out std_logic_vector(31 downto 0)

    );

end component;

begin

ID_EX_REG : ID_EX_REGISTER port map(CLOCK,CONTROL_IN,PC_IN,SIGN_EXTENDER_IN,REG_IN1,REG_IN2,INSTR_IN,CONTROL_OUT,PC_OUT,SIGN_EXTENDER_OUT,REG_OUT1,REG_OUT2,INSTR_OUT);

process

begin

CLOCK <= '0';
wait for 0.5 * CLK_PERIOD;
CLOCK <= '1';
wait for 0.5 * CLK_PERIOD;

end process;

process

begin

wait for 0.5 * CLK_PERIOD;

CONTROL_IN <= std_logic_vector(to_unsigned(15,11));
PC_IN <= std_logic_vector(to_unsigned(1,32));
SIGN_EXTENDER_IN <= std_logic_vector(to_unsigned(10,32));
REG_IN1 <= std_logic_vector(to_unsigned(100,32));
REG_IN2 <= std_logic_vector(to_unsigned(110,32));
INSTR_IN <= std_logic_vector(to_unsigned(1101,32));

wait for 1 * CLK_PERIOD;

assert CONTROL_OUT = CONTROL_IN and PC_OUT = PC_IN and SIGN_EXTENDER_OUT = SIGN_EXTENDER_IN and REG_OUT1 = REG_IN1 and REG_OUT2 = REG_IN2 and INSTR_OUT = INSTR_IN report "Failed to propagate.";

wait;

end process;

end architecture;