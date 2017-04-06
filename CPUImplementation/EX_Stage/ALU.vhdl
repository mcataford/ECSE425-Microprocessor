library IEEE;

use ieee.std_logic_1164.all;

entity ALU is

port(
	--INPUT--
	--Operands--
	A,B: in std_logic_vector(31 downto 0);
	--Control signal--
	ALU_CONTROL: in std_logic_vector(3 downto 0);
	--OUTPUT--
	--32b output--
	OUTPUT: out std_logic_vector(31 downto 0) := (others => '0');
	--64b output--
	OUTPUT_64: out std_logic_vector(63 downto 0) := (others => '0');
	--Status flags--
	ZERO, OVERFLOW: out std_logic := '0'
);

end entity;

architecture ALU_impl of ALU is

--Intermediate signals--

--Intermediate signals, WFA interactions.
signal WFA_S: std_logic_vector(31 downto 0) := (others => '0');
signal WFA_Cout: std_logic := '0';

--Intermediate signals, LC interactions
signal LC_OUTPUT: std_logic_vector(31 downto 0) := (others => '0');
signal LC_MODE: std_logic_vector(1 downto 0) := "00";

--Intermediate signals, MC interactions
signal MC_OUTPUT: std_logic_vector(63 downto 0) := (others => '0');

--Intermediate signals, DC interactions
signal DC_QUOTIENT, DC_REMAINDER: std_logic_vector(31 downto 0) := (others => '0');
signal DC_STATUS: std_logic := '0';

signal STATUS_FLAGS: std_logic_vector(1 downto 0) := (others => '0');

--Component definition--

component WORDFULLADDER

port(
	A,B: in std_logic_vector(31 downto 0);
	Cout: out std_logic := '0';
	S: out std_logic_vector(31 downto 0) := (others => '0')
);

end component;

component LOGICCELL

port(
	A,B: in std_logic_vector(31 downto 0);
	MODE: in std_logic_vector(1 downto 0);
	OUTPUT: out std_logic_vector(31 downto 0) := (others => '0')
);

end component;

component MULTIPLIERCELL

port(
	A,B: in std_logic_vector(31 downto 0);
	OUTPUT: out std_logic_vector(63 downto 0) := (others => '0')
);

end component;

component DIVIDERCELL

port (
	A,B: in std_logic_vector(31 downto 0);
	STATUS: out std_logic := '0';
	QUOTIENT, REMAINDER: out std_logic_vector(31 downto 0) := (others => '0')
);

end component;

begin

--Word-width full adder component instance.
WFA: WORDFULLADDER port map(A,B,WFA_Cout,WFA_S);

--Word-width multiplier component instance.
MC: MULTIPLIERCELL port map(A,B,MC_OUTPUT);

--Word-width divider component instance.
DC: DIVIDERCELL port map(A,B,DC_STATUS,DC_QUOTIENT,DC_REMAINDER);

--Logic cell component instance
LC: LOGICCELL port map(A,B,LC_MODE,LC_OUTPUT);

LC_MODE <= "00" when ALU_CONTROL = "0001" else
	"01" when ALU_CONTROL = "0010" else
	"10" when ALU_CONTROL = "0011" else
	"11" when ALU_CONTROL = "0100" else
	"00";

OUTPUT <= WFA_S when ALU_CONTROL = "0000" else
	LC_OUTPUT when ALU_CONTROL = "0001" or ALU_CONTROL = "0010" or ALU_CONTROL = "0011" or ALU_CONTROL = "0100" else
	(others => '0') when ALU_CONTROL = "0101" or ALU_CONTROL = "0110" else
	(others => 'Z');  

OUTPUT_64 <= MC_OUTPUT when ALU_CONTROL = "0101" else
		DC_QUOTIENT & DC_REMAINDER when ALU_CONTROL = "0110" else
		(others => 'Z');

OVERFLOW <= STATUS_FLAGS(0);
ZERO <= STATUS_FLAGS(1);

end architecture;