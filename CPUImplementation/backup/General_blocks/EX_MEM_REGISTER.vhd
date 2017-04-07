library ieee;

use ieee.std_logic_1164.all;

entity EX_MEM_REGISTER is

	port(
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Branch selection--
		BRANCH_IN: in std_logic;
		--ALU 32b out--
		R_IN,
		--Operand B forward--
		B_FORWARD_IN,
		--Instruction forward--
		INSTR_IN: in std_logic_vector(31 downto 0);
		--ALU 64b out--
		R_64_IN: in std_logic_vector(63 downto 0);
		--OUTPUT--
		--Branch selection--
		BRANCH_OUT: out std_logic := '0';
		--ALU 32b out--
		R_OUT,
		--Operand B forward--
		B_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT: out std_logic_vector(31 downto 0) := (others => '0');
		--Alu 64b out--
		R_64_OUT: out std_logic_vector(63 downto 0) := (others => '0');
		CONTROL_IN: in std_logic_vector(9 downto 0);
		CONTROL_OUT: out std_logic_vector(9 downto 0)
		
	);

end entity;

architecture EX_MEM_REGISTER_Impl of EX_MEM_REGISTER is

signal BRANCH_MEM: std_logic := '0';
signal CONTROL_MEM: std_logic_vector(9 downto 0);
signal R_MEM,B_FORWARD_MEM,INSTR_MEM: std_logic_vector(31 downto 0) := (others => '0');
signal R_64_MEM: std_logic_vector(63 downto 0) := (others => '0');

begin

	process(CLOCK)
	
	begin
	
		if rising_edge(CLOCK) then
		
			BRANCH_OUT <= BRANCH_IN;
			R_OUT <= R_IN;
			B_FORWARD_OUT <= B_FORWARD_IN;
			INSTR_OUT <= INSTR_IN;
			R_64_OUT <= R_64_IN;
			CONTROL_OUT <= CONTROL_IN;
			

			-- BRANCH_MEM <= BRANCH_IN;
			-- R_MEM <= R_IN;
			-- B_FORWARD_MEM <= B_FORWARD_IN;
			-- INSTR_MEM <= INSTR_IN;
			-- R_64_MEM <= R_64_IN;
			-- CONTROL_MEM <= CONTROL_IN;

		end if;

	end process;

end architecture;
