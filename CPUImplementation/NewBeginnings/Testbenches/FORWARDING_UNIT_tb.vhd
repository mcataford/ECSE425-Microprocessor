library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FORWARDING_UNIT_tb is
end entity;

architecture arch of FORWARDING_UNIT_tb is

signal ex_mem_rw : std_logic;
signal mem_wb_rw : std_logic;
signal IDEX_RS, IDEX_RT, EXMEM_RD, MEMWB_RD : std_logic_vector(4 downto 0);

signal MX_A, MX_B : std_logic_vector(1 downto 0);



component FORWARDING_UNIT 
    port(
        EX_MEM_REGWRITE : in STD_LOGIC;
        MEM_WB_REGWRITE : in STD_LOGIC;
        ID_EX_RS : in STD_LOGIC_VECTOR(4 downto 0);
        ID_EX_RT : in STD_LOGIC_VECTOR(4 downto 0);
        EX_MEM_RD : in STD_LOGIC_VECTOR(4 downto 0);
        MEM_WB_RD : in STD_LOGIC_VECTOR(4 downto 0);

        MUX_A : out STD_LOGIC_VECTOR(1 downto 0);
        MUX_B : out STD_LOGIC_VECTOR(1 downto 0)
    );

end component;

begin

    fwd : FORWARDING_UNIT port map (
        ex_mem_rw,
        mem_wb_rw,
        IDEX_RS,
        IDEX_RT,
        EXMEM_RD,
        MEMWB_RD,
        MX_A,
        MX_B
    );

test_process : process
begin


ex_mem_rw <= '0';
mem_wb_rw <= '0';
IDEX_RS <= "00000";
IDEX_RT <= "00000";
EXMEM_RD <= "00000";
MEMWB_RD <= "00000";

wait for 1 ns;

IDEX_RS <= "00010";
IDEX_RT <= "00100";
EXMEM_RD <= "11000";
MEMWB_RD <= "01000";

wait for 1 ns;

EXMEM_RD <= "00010";

wait for 1 ns;

EXMEM_RD <= "11000";

wait for 1 ns;

ex_mem_rw <= '1';
IDEX_RS <= "11000";

wait for 1 ns;

IDEX_RS <= "01010";
IDEX_RT <="11000";

wait for 1 ns;

ex_mem_rw <= '0';
mem_wb_rw <= '1';
MEMWB_RD <= "00110";
EXMEM_RD <= "00010";
IDEX_RS <= "00110";

wait for 1 ns;

IDEX_RS <= "00111";

wait for 1 ns;

IDEX_RT <= "00110";



wait;

end process test_process;


end arch;
