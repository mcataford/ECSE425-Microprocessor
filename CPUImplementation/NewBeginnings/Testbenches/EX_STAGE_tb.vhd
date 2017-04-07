library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE_tb is
end entity;

architecture EX_STAGE_tst of EX_STAGE_tb is

	constant CLK_PERIOD: time := 1 ns;
	
	signal PC: integer range 0 to 1023;
	
	signal A,B,Imm,R1,R2: integer;
	signal CONTROL_VECTOR: std_logic_vector(8 downto 0);
	signal INSTR: std_logic_vector(31 downto 0);
	signal CLOCK: std_logic;

	component EX_STAGE
	
		port(
			--INPUT
			--Program counter
			PC: in integer range 0 to 1023;
			--Operand A
			A: in integer;
			--Operand B
			B: in integer;
			--Immediate
			Imm: in integer;
			--Control signals
			CONTROL_VECTOR: in std_logic_vector(8 downto 0);
			--Instruction
			INSTR: in std_logic_vector(31 downto 0);
			
			--OUTPUT
			--Results
			R1,R2: out integer
		);
		
	end component;
	
begin

	EX_ST: EX_STAGE port map(
		--INPUT
		--Program counter
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
		R1,
		R2
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
	
		A <= 0;
		B <= 0;
		Imm <= 0;
	
		CONTROL_VECTOR <= (others => '0');
	
		wait for 1.5 * CLK_PERIOD;
	
		A <= 50;
		B <= 50;
		INSTR <= "00100000000000010000001111101000";
		
		wait for 1 * CLK_PERIOD;
		
		A <= 60;
		B <= 10;
		wait for 1 * CLK_PERIOD;
		INSTR <= "00100000001000010000000000000000";
		
	
		wait;
		
	end process;

end architecture;