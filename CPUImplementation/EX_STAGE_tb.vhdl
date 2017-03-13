library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_STAGE_tb is
end entity;

architecture EX_STAGE_tst of EX_STAGE_tb is

signal A,B,I,Ins,PC,R,FB,FIns: std_logic_vector(31 downto 0);
signal BRANCH: std_logic;
signal ALU_CONTROL: std_logic_vector(2 downto 0);
signal SELECTOR1, SELECTOR2: std_logic;

component EX_STAGE

port(

A,B,I,Ins,PC: in std_logic_vector(31 downto 0);
SELECTOR1, SELECTOR2: in std_logic;
ALU_CONTROL: in std_logic_vector(2 downto 0);
BRANCH: out std_logic;
R,FB,FIns: out std_logic_vector(31 downto 0)

);

end component;

begin

EX : EX_STAGE port map(A,B,I,Ins,PC,SELECTOR1,SELECTOR2,ALU_CONTROL,BRANCH,R,FB,FIns);

process

begin 

A <= std_logic_vector(to_unsigned(50,32));
B <= std_logic_vector(to_unsigned(60,32));

SELECTOR1 <= '0';
SELECTOR2 <= '0';

I <= (others => '0');
Ins <= (others => '0');
PC <= (others => '0');
ALU_CONTROL <= "000";

wait;

end process;

end architecture;