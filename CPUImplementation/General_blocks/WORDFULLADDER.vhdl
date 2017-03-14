library IEEE;

use ieee.std_logic_1164.all;

entity WORDFULLADDER is

port(
	A,B: in std_logic_vector(31 downto 0);
	S: out std_logic_vector(31 downto 0);
	Cout: out std_logic
);

end entity;

architecture WORDFULLADDER_Impl of WORDFULLADDER is

signal IN_CARRY1, IN_CARRY2, IN_CARRY3: std_logic;
signal IN_SUM1, IN_SUM2, IN_SUM3, IN_SUM4: std_logic_vector(7 downto 0);

component BYTEFULLADDER

port(
	A,B: in std_logic_vector(7 downto 0);
	Cin: in std_logic;
	Cout: out std_logic;
	S: out std_logic_vector(7 downto 0)
	
);

end component;

begin

BFA1: BYTEFULLADDER port map(A(7 downto 0),B(7 downto 0),'0',IN_CARRY1,IN_SUM1);
BFA2: BYTEFULLADDER port map(A(15 downto 8),B(15 downto 8),IN_CARRY1,IN_CARRY2,IN_SUM2);
BFA3: BYTEFULLADDER port map(A(23 downto 16),B(23 downto 16),IN_CARRY2,IN_CARRY3,IN_SUM3);
BFA4: BYTEFULLADDER port map(A(31 downto 24),B(31 downto 24),IN_CARRY3,Cout,IN_SUM4);

S <= IN_SUM4 & IN_SUM3 & IN_SUM2 & IN_SUM1;

end architecture;