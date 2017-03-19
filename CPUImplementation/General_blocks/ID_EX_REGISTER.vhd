library IEEE;

use ieee.std_logic_1164.all;

entity ID_EX_REGISTER is
    port(
        --Inputs--
        
	--CLOCK SIGNAL--
        CLOCK: in std_logic;

	--CONTROL SIGNALS IN--
	CONTROL_IN: in std_logic_vector(9 downto 0);
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
	CONTROL_OUT: out std_logic_vector(9 downto 0);

	--PROGRAM COUNTER OUT--
        PC_OUT,
	
	--SIGN EXTENDER OUT--
        SIGN_EXTENDER_OUT,

	--REGISTER DATA OUT--
        REG_OUT1,
        REG_OUT2 : out std_logic_vector(31 downto 0) := (others => '0');
	
	--INSTRUCTION OUT--
	INSTR_OUT: out std_logic_vector(31 downto 0)

    );

end ID_EX_REGISTER;


architecture ID_EX_REGISTER_Impl of ID_EX_REGISTER is

signal CONTROL_MEM: std_logic_vector(9 downto 0);
signal PC_MEM,SIGN_MEM,REG1_MEM,REG2_MEM,INSTR_MEM: std_logic_vector(31 downto 0) := (others => '0');

begin

process(CLOCK)

begin

if rising_edge(CLOCK) then

CONTROL_OUT <= CONTROL_MEM;
PC_OUT <= PC_MEM;
SIGN_EXTENDER_OUT <= SIGN_MEM;
REG_OUT1 <= REG1_MEM;
REG_OUT2 <= REG2_MEM;
INSTR_OUT <= INSTR_MEM;

CONTROL_MEM <= CONTROL_IN;
PC_MEM <= PC_IN;
SIGN_MEM <= SIGN_EXTENDER_IN;
REG1_MEM <= REG_IN1;
REG2_MEM <= REG_IN2;
INSTR_MEM <= INSTR_IN;

end if;

end process;

end architecture;