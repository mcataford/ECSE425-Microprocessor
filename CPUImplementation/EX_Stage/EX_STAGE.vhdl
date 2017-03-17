library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE is

port(

A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
ALU_CONTROL: in std_logic_vector(2 downto 0);
SELECTOR1, SELECTOR2: in std_logic;
BRANCH: out std_logic;
R,FB,FIns: out std_logic_vector(31 downto 0);
R_64: out std_logic_vector(63 downto 0)

);

end entity;

architecture EX_STAGE_Impl of EX_STAGE is

signal STATUS: std_logic_vector(2 downto 0) := "000";
signal MUX1_OUT, MUX2_OUT: std_logic_vector(31 downto 0);

component ALU

port(
	--Inputs
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(2 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	OUTPUT_64: out std_logic_vector(63 downto 0);
	ZERO, OVERFLOW: out std_logic
);

end component;

component MUX

port(
	A,B: in std_logic_vector(31 downto 0);
	SELECTOR: in std_logic;
	OUTPUT: out std_logic_vector(31 downto 0) 
);

end component;

begin

--ALU Unit
ALU_unit : ALU port map(MUX1_OUT,MUX2_OUT,ALU_CONTROL,R,R_64,STATUS(0),STATUS(1));

--Multiplexers gating the ALU input
MUX1 : MUX port map(A,PC,SELECTOR1,MUX1_OUT);
MUX2 : MUX port map(B,I,SELECTOR2,MUX2_OUT);

--Forwarding
FB <= B;
FIns <= Ins;

BRANCH <= '1' when to_integer(unsigned(A)) = 0 else
	'0';

end architecture;