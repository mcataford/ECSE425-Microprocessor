library IEEE;

use ieee.std_logic_1164.all;

entity BYTEFULLADDER is

port(
	A,B: in std_logic_vector(7 downto 0);
	Cin: in std_logic;
	Cout: out std_logic;
	S: out std_logic_vector(7 downto 0)
);

end entity;

architecture BYTEFULLADDER_Impl of BYTEFULLADDER is

signal INTERNAL_CARRY: std_logic_vector(6 downto 0) := (others => '0');
signal INTERNAL_SUM: std_logic_vector(7 downto 0) := (others => '0');

component FULLADDER

port(
	A,B,Cin: in std_logic;
	Cout,S: out std_logic
);

end component;

begin

FA1: FULLADDER port map(A(0),B(0),Cin,INTERNAL_CARRY(0),INTERNAL_SUM(0));
FA2: FULLADDER port map(A(1),B(1),INTERNAL_CARRY(0),INTERNAL_CARRY(1),INTERNAL_SUM(1));
FA3: FULLADDER port map(A(2),B(2),INTERNAL_CARRY(1),INTERNAL_CARRY(2),INTERNAL_SUM(2));
FA4: FULLADDER port map(A(3),B(3),INTERNAL_CARRY(2),INTERNAL_CARRY(3),INTERNAL_SUM(3));
FA5: FULLADDER port map(A(4),B(4),INTERNAL_CARRY(3),INTERNAL_CARRY(4),INTERNAL_SUM(4));
FA6: FULLADDER port map(A(5),B(5),INTERNAL_CARRY(4),INTERNAL_CARRY(5),INTERNAL_SUM(5));
FA7: FULLADDER port map(A(6),B(6),INTERNAL_CARRY(5),INTERNAL_CARRY(6),INTERNAL_SUM(6));
FA8: FULLADDER port map(A(7),B(7),INTERNAL_CARRY(6),Cout,INTERNAL_SUM(7));

S <= INTERNAL_SUM;

end architecture;