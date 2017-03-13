library IEEE;

use ieee.std_logic_1164.all;

entity EX_STAGE is

port(

A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
ALU_CONTROL: in std_logic_vector(2 downto 0);
SELECTOR1, SELECTOR2: in std_logic;
BRANCH: out std_logic;
R,FB,FIns: out std_logic_vector(31 downto 0)

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

ALU_unit : ALU port map(MUX1_OUT,MUX2_OUT,ALU_CONTROL,R,STATUS(0),STATUS(1));
MUX1 : MUX port map(A,PC,SELECTOR1,MUX1_OUT);
MUX2 : MUX port map(B,I,SELECTOR2,MUX2_OUT);

FB <= B;
FIns <= Ins;


end architecture;