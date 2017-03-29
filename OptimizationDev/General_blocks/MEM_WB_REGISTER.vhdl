library IEEE;

use ieee.std_logic_1164.all;

entity MEM_WB_REGISTER is

	port (
		CLOCK: in std_logic;
		DATA_IN, INSTR_IN, B_FORWARD_IN : in std_logic_vector(31 downto 0);
		DATA_OUT, INSTR_OUT, B_FORWARD_OUT : out std_logic_vector(31 downto 0);
		DATA64_IN: in std_logic_vector(63 downto 0);
		DATA64_OUT: out std_logic_vector(63 downto 0);
		CONTROL_IN: in std_logic_vector(9 downto 0);
		CONTROL_OUT: out std_logic_vector(9 downto 0)
	);

end entity;

architecture MEM_WB_REGISTER_Impl of MEM_WB_REGISTER is

signal MEM_DATA, MEM_INSTR, MEM_B_FORWARD: std_logic_vector(31 downto 0);
signal MEM_DATA64: std_logic_vector(63 downto 0);
signal MEM_CONTROL: std_logic_vector(9 downto 0);

begin

	process(CLOCK)

	begin
		if rising_edge(CLOCK) then

			DATA_OUT <= MEM_DATA;
			INSTR_OUT <= MEM_INSTR;
			B_FORWARD_OUT <= MEM_B_FORWARD;
			DATA64_OUT <= MEM_DATA64;
			CONTROL_OUT <= MEM_CONTROL;

			MEM_DATA <= DATA_IN;
			MEM_INSTR <= INSTR_IN;
			MEM_B_FORWARD <= B_FORWARD_IN;
			MEM_DATA64 <= DATA64_IN;	
			MEM_CONTROL <= CONTROL_IN;
		end if;

	end process;

end architecture;