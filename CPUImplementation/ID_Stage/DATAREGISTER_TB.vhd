
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DATAREGISTER_TB is
end DATAREGISTER_TB;

architecture behavior of DATAREGISTER_TB is

component DATAREGISTER is

 port(
         ---Inputs---
        CLOCK : in std_logic;
        READ_REG1 : in std_logic_vector (4 downto 0);
        READ_REG2 : in std_logic_vector (4 downto 0);
        WRITE_REG : in std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        WRITE_HILO : in std_logic_vector (63 downto 0);
        
        ---Internal Signals---
        PC_IN : in std_logic_vector (31 downto 0);

        ---Control Signals---
        CONTROL_LINK : in std_logic;
        CONTROL_REG_WRITE : in std_logic;
        CONTROL_GET_HI : in std_logic;
        CONTROL_GET_LO : in std_logic;

        ---Outputs---

        READ_DATA_OUT1 : out std_logic_vector (31 downto 0);
        READ_DATA_OUT2 : out std_logic_vector (31 downto 0)
    );

end component;
	
-- test signals 
CONSTANT clk_period : time := 1 ns;
SIGNAL clk: STD_LOGIC := '0';
signal ri1, ri2, wr : std_logic_vector(4 downto 0);
signal wd : std_logic_vector(31 downto 0);
signal pcin : std_logic_vector(31 downto 0);
signal cl, crw, cgh, cgl : std_logic;
signal rdo1, rdo2 : std_logic_vector(31 downto 0);

begin

dr : DATAREGISTER 
port map(
	clk,
    ri1,
    ri2,
    wr,
    wd,
    pcin,
    cl,
    crw,
    cgh,
    cgl,
    rdo1,
    rdo2  
);
 

clk_process : PROCESS
BEGIN
	clk <= '0';
	WAIT FOR clk_period/2;
	clk <= '1';
	WAIT FOR clk_period/2;
END PROCESS;
 


test : PROCESS 
BEGIN

wait for clk_period;

ri1 <="00001";
ri2 <="00010";
wr  <="00001";
wd  <="00000000000000000000001111111111";
pcin<="00000000000000000000000000000101";
crw <='0';
cgh <='0';
cgl <='0';

wait for clk_period;

ri1 <="00001";
ri2 <="00010";
wr  <="00001";
wd  <="00000000000000000000001111111111";
pcin<="00000000000000000000000000000110";
cl  <='1';
crw <='1';
cgh <='0';
cgl <='0';

wait for clk_period;

ri1 <="00001";
ri2 <="00010";
wr  <="00001";
wd  <="00000000000000000000001111111111";
pcin<="00000000000000000000000000000110";
cl  <='1';
crw <='1';
cgh <='0';
cgl <='0';

wait for clk_period;

ri1 <="00001";
ri2 <="00010";
wr  <="00000";
wd  <="00000000000000000000001111111111";
pcin<="00000000000000000000000000000111";
cl  <='1';
crw <='1';
cgh <='0';
cgl <='0';

wait for clk_period;

ri1 <="00000";
ri2 <="00010";
pcin<="00000000000000000000000000001000";
cl  <='1';
crw <='0';
cgh <='0';
cgl <='0';


wait for clk_period;

ri1 <="00000";
ri2 <="00010";
wr  <="00001";
wd  <="00000000000000000000001110001111";
pcin<="00000000000000000000000000001001";
cl  <='0';
crw <='0';
cgh <='0';
cgl <='0';

wait for clk_period;

ri1 <="00001";
ri2 <="00010";
pcin<="00000000000000000000000000001010";
cl  <='0';
crw <='0';
cgh <='0';
cgl <='0';

end process;
end behavior;