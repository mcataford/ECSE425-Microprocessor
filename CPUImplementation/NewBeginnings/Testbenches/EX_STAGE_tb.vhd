library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE_tb is
end entity;

architecture EX_STAGE_tst of EX_STAGE_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal PC: std_logic_vector(31 downto 0);
	
	signal A,B,Imm: std_logic_vector(31 downto 0);
	signal CONTROL_VECTOR: std_logic_vector(7 downto 0);
	signal INSTR: std_logic_vector(31 downto 0);
	signal R: std_logic_vector(63 downto 0);
	signal CLOCK: std_logic;

	component EX_STAGE
	
		port(
			--INPUT
			--Program counter
			PC: in std_logic_vector(31 downto 0);
			--Operand A
			A: in std_logic_vector(31 downto 0);
			--Operand B
			B: in std_logic_vector(31 downto 0);
			--Immediate
			Imm: in std_logic_vector(31 downto 0);
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(7 downto 0);
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Results
			R: out std_logic_vector(63 downto 0)
		);
		
	end component;
	
begin

	EX_ST: EX_STAGE port map(
		--INPUT
		PC,
		--Operand A
		A,
		--Operand B
		B,
		--Immediate
		Imm,
		--Control signals
		CONTROL_VECTOR,
		--Instruction
		INSTR,
		
		--OUTPUT
		--Results
		R
	);
	
	CLK: process
	
	begin
	
		CLOCK <= '0';
		wait for 0.5 * CLK_PERIOD;
		CLOCK <= '1';
		wait for 0.5 * CLK_PERIOD;
	
	end process;
	
	TST: process
	
	begin
	
		A <= (others => '0');
		B <= (others => '0');
		Imm <= (others => '0');
		INSTR <= (others => '0');
	
		CONTROL_VECTOR <= (others => '0');
	
		wait for 0.5 * CLK_PERIOD;
	
		A <= std_logic_vector(to_unsigned(50,32));
		B <= std_logic_vector(to_unsigned(50,32));
		INSTR <= "00100000000000010000001111101000";
		
		wait for 1 * CLK_PERIOD;
		
		A <= std_logic_vector(to_unsigned(66,32));
		B <= std_logic_vector(to_unsigned(10,32));
		INSTR <= "00100000001000010000000000000000";
		
		wait for 1 * CLK_PERIOD;

		INSTR <= "00000000001000010000000000100010";
		
		wait for 1 * CLK_PERIOD;
		
		INSTR <= "00000000001000010000000000011000";
		
		wait for 1 * CLK_PERIOD;

		INSTR <= "00000000001000010000000000011010";
		
		wait;
		
	end process;

end architecture;