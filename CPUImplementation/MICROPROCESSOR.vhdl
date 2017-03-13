library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR is
	port(
	CLOCK: in std_logic
	);

end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR is

signal EX_A,EX_B,EX_I,EX_Ins,EX_PC,EX_R,EX_FB,EX_FIns: std_logic_vector(31 downto 0);
signal EX_ALUCTRL: std_logic_vector(3 downto 0);
signal EX_SEL1, EX_SEL2, EX_BRANCH: std_logic;

component EX_STAGE

port(

A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
ALU_CONTROL: in std_logic_vector(3 downto 0);
SELECTOR1, SELECTOR2: in std_logic;
BRANCH: out std_logic;
R,FB,FIns: out std_logic_vector(31 downto 0)

);

end component;

begin

EX : EX_STAGE port map(EX_A,EX_B,EX_I,EX_Ins,EX_PC,EX_ALUCTRL,EX_SEL1,EX_SEL2,EX_BRANCH,EX_R,EX_FB,EX_FIns);

process(CLOCK)

begin

end process;

end architecture;