library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_MEM_REG is
	
	port(
		--INPUT
		--Clock signal
		CLOCK: in std_logic;
		--Results
		EX_R1: in integer;
		EX_R2: in integer;
		--Operand B forwarding
		EX_B_FW: in integer;
		--Instruction
		EX_INSTR: in std_logic_vector(31 downto 0);
		--Control signals
		EX_CONTROL_VECTOR: in std_logic_vector(7 downto 0);
		
		--OUTPUT
		--Results
		MEM_R1: out integer;
		MEM_R2: out integer;
		--Operand B forwarding
		MEM_B_FW: out integer;
		--Instruction
		MEM_INSTR: out std_logic_vector(31 downto 0);
		--Control signals
		MEM_CONTROL_VECTOR: out std_logic_vector(7 downto 0);
	);
	
end entity;