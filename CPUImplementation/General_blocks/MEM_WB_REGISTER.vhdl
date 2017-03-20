library IEEE;

use ieee.std_logic_1164.all;

entity MEM_WB_REGISTER is

	port (
		CLOCK: in std_logic;
		DATA_IN, INSTR_IN, B_FORWARD_IN, : in std_logic_vector(31 downto 0);
		DATA_OUT, INSTR_OUT, B_FORWARD_OUT : out std_logic_vector(31 downto 0)
	);

end entity;

architecture MEM_WB_REGISTER_Impl of MEM_WB_REGISTER is

begin

end architecture;