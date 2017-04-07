library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_CONTROL_UNIT is
	
	port (
		--INPUT
		--Opcode segment
		OPCODE: in std_logic_vector(5 downto 0);
		--Funct segment
		FUNCT: in std_logic_vector(5 downto 0);
		
		--OUTPUT
		--Control signals
		CONTROL_VECTOR: out std_logic_vector(6 downto 0);
		--ALU control signals
		ALU_CONTROL_VECTOR: out std_logic_vector(6 downto 0)
	);
	
end entity;