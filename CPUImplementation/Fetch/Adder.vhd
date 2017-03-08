library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity ADDER is   
	port(
		A: in std_logic_vector(31 downto 0);
		B: in std_logic_vector(31 downto 0);
		Cin: in std_logic;
		S: out std_logic_vector(31 downto 0);
		Cout: out std_logic
	);
end ADDER;

architecture arch of ADDER is

	signal Caux :	std_logic_vector (31 downto 0);

	component FULLADDER is
	    port(
			A: in std_logic;
			B: in std_logic;
			Cin: in std_logic;
			S: out std_logic;
			Cout: out std_logic
	    );
	end component FULLADDER;

begin
	FULLADDER_START:
		FULLADDER port map (
			A => A(0),
			B => B(0),
			Cin => Cin,
			S => S(0),
			Cout => Caux(0)
		);
		
	NORMAL_ADDER:
		for i in 1 to 31 generate
			FULLADDER_NEXT:
				FULLADDER port map (
					A	=> A(i),
					B	=> B(i),	
					Cin	=> Caux(i-1),
					S	=> S(i),
					Cout=> Caux(i)
				);
		end generate;
	Cout <= Caux(31);
end arch;