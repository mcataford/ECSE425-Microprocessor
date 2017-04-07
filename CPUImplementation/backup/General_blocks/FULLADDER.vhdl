library IEEE;

use ieee.std_logic_1164.all;

entity FULLADDER is

port(
	A,B,Cin: in std_logic;
	S,Cout: out std_logic
);

end entity;

architecture FULLADDER_Impl of FULLADDER is

begin

S <= A xor B xor Cin;
Cout <= (Cin and (A or B)) or (A and B);

end architecture;