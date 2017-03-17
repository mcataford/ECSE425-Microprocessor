library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE is

	port(
		--INPUT--
		--ALU operands
		A,B,
		--Immediate--
		IMM,
		--Instruction forward--
		INSTR_IN,
		--PC forward--
		PC_IN: in std_logic_vector(31 downto 0);
		--Control signal ALUOP--
		ALU_CONTROL: in std_logic_vector(3 downto 0);
		--Multiplexer control--
		SELECTOR1, 
		SELECTOR2: in std_logic;
		--OUTPUT--
		--Branch Taken--
		BRANCH: out std_logic := '0';
		--ALU 32b out--
		R,
		--Operand B forward--
		B_OUT,
		--Instruction forward--
		INSTR_OUT: out std_logic_vector(31 downto 0) := (others => '0');
		--ALU 64b out--
		R_64: out std_logic_vector(63 downto 0) := (others => '0')
	
	);

end entity;

architecture EX_STAGE_Impl of EX_STAGE is

--Intermediate signals

signal STATUS: std_logic_vector(2 downto 0) := (others => '0');
--Multiplexer output--
signal MUX1_OUT, MUX2_OUT: std_logic_vector(31 downto 0) := (others => '0');

--Component definition--

component ALU

port(
	--INPUT
	--Operands--
	A,B: in std_logic_vector(31 downto 0);
	--Control signal ALUOP--	
	ALU_CONTROL: in std_logic_vector(3 downto 0);
	--OUTPUT--
	--ALU 32b out--
	OUTPUT: out std_logic_vector(31 downto 0) := (others => '0');
	--ALU 64b out--
	OUTPUT_64: out std_logic_vector(63 downto 0) := (others => '0');
	--Status flags--	
	ZERO, OVERFLOW: out std_logic := '0'
);

end component;

component MUX

port(
	--Operands--
	A,B: in std_logic_vector(31 downto 0);
	--Selector--
	SELECTOR: in std_logic;
	--Chosen signal--
	OUTPUT: out std_logic_vector(31 downto 0) := (others => '0')
);

end component;

begin

--ALU Unit--
ALU_unit : ALU port map(
	--INPUT--
	--Operands (from MUX)--
	MUX1_OUT,
	MUX2_OUT,
	--Control signal--
	ALU_CONTROL,
	--OUTPUT--
	--ALU 32b out--
	R,
	--ALU 64b out--
	R_64,
	--Status flags--
	STATUS(0),
	STATUS(1)
);

--Multiplexers gating the ALU input--
MUX1 : MUX port map(A,PC_IN,SELECTOR1,MUX1_OUT);
MUX2 : MUX port map(B,IMM,SELECTOR2,MUX2_OUT);

--Forwarding--
B_OUT <= B;
INSTR_OUT <= INSTR_IN;

--Branch signal - Operand A == 0--
BRANCH <= '1' when to_integer(unsigned(A)) = 0 else
	'0';

end architecture;