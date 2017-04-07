library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--Reset
		RESET: in std_logic;
		--Program counter
		ID_PC: in integer range 0 to 1023;
		--Instruction
		ID_INSTR: in std_logic_vector(31 downto 0);
		--Register values
		ID_REG_A: in integer;
		ID_REG_B: in integer;
		--Immediate
		ID_IMMEDIATE: in integer;
		--Control signals
		ID_CONTROL_VECTOR: in std_logic_vector(8 downto 0);
		
		--OUTPUT
		EX_PC: out integer range 0 to 1023;
		--Instruction
		EX_INSTR: out std_logic_vector(31 downto 0);
		--Register values
		EX_REG_A: out integer;
		EX_REG_B: out integer;
		--Immediate
		EX_IMMEDIATE: out integer;
		--Control signals
		EX_CONTROL_VECTOR: out std_logic_vector(8 downto 0)
	);

end entity;

architecture ID_EX_REG_Impl of ID_EX_REG is

begin

	REG_BEHAVIOUR: process(CLOCK)
	
	begin
	
		if rising_edge(CLOCK) and RESET = '0' then
		
			EX_PC <= ID_PC;
			EX_INSTR <= ID_INSTR;
			EX_REG_A <= ID_REG_A;
			EX_REG_B <= ID_REG_B;
			EX_IMMEDIATE <= ID_IMMEDIATE;
			EX_CONTROL_VECTOR <= ID_CONTROL_VECTOR;
		
		end if;
	
	end process;

end architecture;