library IEEE;

use ieee.std_logic_1164.all;

entity EX_STAGE is

port(

A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
ALU_CONTROL: in std_logic_vector(2 downto 0);
BRANCH: out std_logic;
R,FB,FIns: out std_logic_vector(31 downto 0)

);

end entity;

architecture EX_STAGE_Impl of EX_STAGE is

signal STATUS: std_logic_vector(2 downto 0) := "000";


component ALU

port(
	--Inputs
	A,B: in std_logic_vector(31 downto 0);
	ALU_CONTROL: in std_logic_vector(2 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0);
	ZERO, OVERFLOW: out std_logic
);

end component;

begin

ALU_unit : ALU port map(A,B,ALU_CONTROL,R,STATUS(0),STATUS(1));

FB <= B;
FIns <= Ins;


end architecture;