library IEEE;

use ieee.std_logic_1164.all;

entity ID_EX_REGISTER is
    port(
        --Inputs--
        
	--CLOCK SIGNAL--
        CLOCK,

	--CONTROL SIGNALS IN--
	CONTROL_IN: in std_logic_vector(10 downto 0);
--
        --PROGRAM COUNTER IN--
	PC_IN,

        --SIGN EXTENDER IN--
	SIGN_EXTENDED_IN,

        --REGISTER DATA IN--
	REG_IN1,
        REG_IN2 : in std_logic_vector(31 downto 0);
	
	--INSTRUCTION IN--
	INTR_IN: in std_logic_vector(31 downto 0);

        --Outputs--
       	--CONTROL SIGNALS OUT--
	CONTROL_OUT: out std_logic_vector(10 downto 0);

	--PROGRAM COUNTER OUT--
        PC_OUT,
	
	--SIGN EXTENDER OUT--
        SIGN_EXTENDED_OUT,

	--REGISTER DATA OUT--
        REG_OUT1,
        REG_OUT2 : out std_logic_vector(31 downto 0);
	
	--INSTRUCTION OUT--
	INSTR_OUT: out std_logic_vector(31 downto 0);

    );

end ID_EX_REGISTER;


architecture arch of ID_EX_REGISTER is
    


    begin



end arch;
