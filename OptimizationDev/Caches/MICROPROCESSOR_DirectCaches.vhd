library IEEE;

use ieee.std_logic_1164.all;

entity MICROPROCESSOR is
	
	port(
		CLOCK: in std_logic
	);

end entity;

architecture MICROPROCESSOR_Impl of MICROPROCESSOR is

	--Intermediate signals : IF STAGE--
	
	signal IF_RESET, IF_PC_SRC: std_logic := '0';
	signal IF_ALU_PC, IF_PC_OUT, IF_INSTR_OUT: std_logic_vector(31 downto 0) := (others => '0');

	--Intermediate signals : ID STAGE--
	
	signal ID_CONTROL_REG_WRITE : std_logic := '0';
	signal ID_PC_IN, ID_INSTR_IN, ID_WRITE_DATA,ID_INSTR_OUT,ID_PC_OUT,ID_SIGN_OUT,ID_REGA_OUT, ID_REGB_OUT: std_logic_vector(31 downto 0) := (others => '0');
	signal ID_WRITE_HILO : std_logic_vector(63 downto 0) := (others => '0');
	signal ID_READ_OUT, ID_WRITE_REG : std_logic_vector(4 downto 0) := (others => '0');
	signal ID_CONTROL_OUT : std_logic_vector(9 downto 0) := (others => '0');
	
	--Intermediate signals : EX STAGE--
	
	signal EX_CONTROL_IN: std_logic_vector(9 downto 0);
	signal EX_PC_IN, EX_SIGN_IN, EX_REGA_IN, EX_REGB_IN, EX_INSTR_IN, EX_R32_OUT, EX_B_OUT, EX_INSTR_OUT: std_logic_vector(31 downto 0);
	signal EX_R64_OUT : std_logic_vector(63 downto 0);
	signal EX_SELA_IN,EX_SELB_IN,EX_BRANCH_OUT : std_logic := '0';
	
	--Intermediate signals : MEM STAGE--
	
	signal MEM_B_IN, MEM_R32_IN, MEM_INSTR_IN: std_logic_vector(31 downto 0);
	signal MEM_R64_IN: std_logic_vector(63 downto 0);
	signal MEM_BRANCH_IN: std_logic;
	signal MEM_DATA_OUT, MEM_INSTR_OUT, MEM_B_OUT: std_logic_vector(31 downto 0);
	signal MEM_CONTROL : std_logic_vector(1 downto 0) := (others => '0');
	signal MEM_CONTROL_IN : std_logic_vector(9 downto 0);
	
	--Intermediate signals : WB STAGE--
	signal WB_DATA_IN,WB_INSTR_IN,WB_B_IN,WB_OUT: std_logic_vector(31 downto 0);
	signal WB_R64_IN: std_logic_vector(63 downto 0);	
	signal WB_CONTROL_OUT: std_logic_vector(9 downto 0);
	
	--Intermediate signals : Caches--
  constant ram_size: integer := 32768;
  constant icache_size: integer := 512;
  constant dcache_size: integer := 256;
  
  signal s_readdata_i, s_readdata_d : std_logic_vector (31 downto 0);
  signal s_waitrequest_i, s_waitrequest_d: std_logic;

 	signal m_addr_i : integer range 0 to (icache_size*8*8-1);
 	signal m_addr_d : integer range 0 to (dcache_size*8*8-1);
	signal m_read_i, m_read_d : std_logic;
	signal m_readdata_i, m_readdata_d : std_logic_vector (7 downto 0);
	signal m_write_i, m_write_d : std_logic;
	signal m_writedata_i, m_writedata_d : std_logic_vector (7 downto 0);
	signal m_waitrequest_i, m_waitrequest_d : std_logic;
	
	component Cache_DirectMapped
	  port(
	    clock : in std_logic;
	    reset : in std_logic;
	
	    s_addr : in std_logic_vector (31 downto 0);
	    s_read : in std_logic;
	    s_readdata : out std_logic_vector (31 downto 0);
	    s_write : in std_logic;
	    s_writedata : in std_logic_vector (31 downto 0);
	    s_waitrequest : out std_logic; 
    
	    m_addr : out integer range 0 to (icache_size*8*8)-1;
	    m_read : out std_logic;
	    m_readdata : in std_logic_vector (7 downto 0);
	    m_write : out std_logic;
	    m_writedata : out std_logic_vector (7 downto 0);
	    m_waitrequest : in std_logic
);
  end component;
	
	component IF_STAGE

		port(
			--INPUT--
			--Clock signal--
			CLOCK: in std_logic;
			--Reset signal--
			RESET: in std_logic;
			--PC MUX select signal--
			PC_SRC: in std_logic;
			--Feedback from ALU for PC calc.--
			ALU_PC: in std_logic_vector(31 downto 0);
			--OUTPUT--
			--PC output--
			PC_OUT,
			--Fetched instruction--
			INSTR: out std_logic_vector(31 downto 0) := (others => '0')
		);

	end component;

	component IF_ID_REGISTER
	
    port(
        --Inputs--
				CLOCK: in std_logic; 
        PC_IN,
        INSTR_IN : in std_logic_vector(31 downto 0);
        --Outputs--
        PC_OUT,
        INSTR_OUT : out std_logic_vector(31 downto 0):= (others => '0')
    );
		
	end component;
	
	component ID
	
	    port(
        ---Inputs---
        CLOCK : in std_logic;
        INSTRUCTION_IN : in std_logic_vector (31 downto 0);
        PC_IN : in std_logic_vector (31 downto 0);
        WRITE_REG : std_logic_vector (4 downto 0);
        WRITE_DATA : in std_logic_vector (31 downto 0);
        WRITE_HILO : in std_logic_vector(63 downto 0);
        --Control Signals In--
        CONTROL_REG_WRITE_IN : in std_logic;
        ---Control Signals Out---
        CONTROL_VECTOR : out std_logic_vector(9 downto 0);
        ---Data Outputs---
        INSTRUCTION_OUT : out std_logic_vector(31 downto 0);
        PC_OUT : out std_logic_vector (31 downto 0);
        RD_OUT : out std_logic_vector(4 downto 0);
        SIGN_EXTENDED_OUT : out std_logic_vector (31 downto 0);
        REG_OUT1 : out std_logic_vector (31 downto 0);
        REG_OUT2 : out std_logic_vector (31 downto 0)
    );
	
	end component;
	
	component ID_EX_REGISTER
	 port(
						--Inputs--
						
			--CLOCK SIGNAL--
						CLOCK: in std_logic;

			--CONTROL SIGNALS IN--
			CONTROL_IN: in std_logic_vector(9 downto 0);
		--
						--PROGRAM COUNTER IN--
			PC_IN,

						--SIGN EXTENDER IN--
			SIGN_EXTENDER_IN,

						--REGISTER DATA IN--
			REG_IN1,
						REG_IN2 : in std_logic_vector(31 downto 0);
			
			--INSTRUCTION IN--
			INSTR_IN: in std_logic_vector(31 downto 0);

						--Outputs--
						--CONTROL SIGNALS OUT--
			CONTROL_OUT: out std_logic_vector(9 downto 0);

			--PROGRAM COUNTER OUT--
						PC_OUT,
			
			--SIGN EXTENDER OUT--
						SIGN_EXTENDER_OUT,

			--REGISTER DATA OUT--
						REG_OUT1,
						REG_OUT2 : out std_logic_vector(31 downto 0) := (others => '0');
			
			--INSTRUCTION OUT--
			INSTR_OUT: out std_logic_vector(31 downto 0)

    );
	end component;
	
	component EX_STAGE
	
		port(
			--INPUT--
			--ALU operands
			A,B,
			--Immediate--
			IMM,
			--Instruction forward--
			INSTR_IN,
			--PC forward--
			PC_IN: in std_logic_vector(31 downto 0);
			--Control signal ALUOP--
			ALU_CONTROL: in std_logic_vector(3 downto 0);
			--Multiplexer control--
			SELECTOR1, 
			SELECTOR2: in std_logic;
			--OUTPUT--
			--Branch Taken--
			BRANCH: out std_logic;
			--ALU 32b out--
			R,
			--Operand B forward--
			B_OUT,
			--Instruction forward--
			INSTR_OUT: out std_logic_vector(31 downto 0);
			--ALU 64b out--
			R_64: out std_logic_vector(63 downto 0)
		);
		
	end component;
	
	component EX_MEM_REGISTER
		port(
		--INPUT--
		--Clock signal--
		CLOCK: in std_logic;
		--Branch selection--
		BRANCH_IN: in std_logic;
		--ALU 32b out--
		R_IN,
		--Operand B forward--
		B_FORWARD_IN,
		--Instruction forward--
		INSTR_IN: in std_logic_vector(31 downto 0);
		--ALU 64b out--
		R_64_IN: in std_logic_vector(63 downto 0);
		--OUTPUT--
		--Branch selection--
		BRANCH_OUT: out std_logic := '0';
		--ALU 32b out--
		R_OUT,
		--Operand B forward--
		B_FORWARD_OUT,
		--Instruction forward--
		INSTR_OUT: out std_logic_vector(31 downto 0) := (others => '0');
		--Alu 64b out--
		R_64_OUT: out std_logic_vector(63 downto 0) := (others => '0');
		CONTROL_IN: in std_logic_vector(9 downto 0);
		CONTROL_OUT: out std_logic_vector(9 downto 0)
		
	);
	end component;
	
	component MEM_STAGE
		port (
			--INPUT--
			--Clock signal--
			CLOCK: in std_logic;
			--Data to register--
			DATA_IN,
			--Write addr.
			DATA_ADDR,
			--Instruction in--
			INSTR_IN : in std_logic_vector(31 downto 0);
			MEM_CONTROL: in std_logic_vector(1 downto 0);
			--OUTPUT--
			--Data output--
			DATA_OUT,
			--Data forward--
			DATA_FORWARD_OUT,
			--Instruction forward--
			INSTR_OUT : out std_logic_vector(31 downto 0)
		);
	end component;
	
	component MEM_WB_REGISTER
	
		port (
			CLOCK: in std_logic;
			DATA_IN, INSTR_IN, B_FORWARD_IN : in std_logic_vector(31 downto 0);
			DATA_OUT, INSTR_OUT, B_FORWARD_OUT : out std_logic_vector(31 downto 0);
			DATA64_IN: in std_logic_vector(63 downto 0);
			DATA64_OUT: out std_logic_vector(63 downto 0);
			CONTROL_IN: in std_logic_vector(9 downto 0);
			CONTROL_OUT: out std_logic_vector(9 downto 0)
		);
	
	end component;
	
	component WB_STAGE
	
		port( 
			--Inputs
			MUX_SELECT: in std_logic; --Selector for the multiplexer
			READ_DATA, FORWARD_DATA: in std_logic_vector(31 downto 0); --Data from memory instruction
			--Outputs
			WRITE_DATA: out std_logic_vector(31 downto 0)	-- Outputs either data from fetch or memory instructions
		);

	
	end component;
	
begin
  
   --Cache instantiation--
  iCache : Cache_DirectMapped port map(
      Clock, --Clock
      '0',   --Reset
      
      IF_PC_OUT,  --s_addr
      IF_PC_SRC, --s_read
      s_readdata_i, --s_readdata
      IF_PC_SRC, --s_write
      IF_INSTR_OUT, --s_writedata
      s_waitrequest_i, --s_waitrequest
    
	    m_addr_i, --m_addr
	    m_read_i, --m_read
	    m_readdata_i, --m_readdata
	    m_write_i, --m_write
	    m_writedata_i, --m_writedata
	    m_waitrequest_i --m_waitrequest
  );
  
  dCache : Cache_DirectMapped port map(
      Clock, --Clock
      '0',   --Reset
      
      IF_PC_OUT,  --s_addr
      IF_PC_SRC, --s_read
      s_readdata_d, --s_readdata
      IF_PC_SRC, --s_write
      IF_INSTR_OUT, --s_writedata
      s_waitrequest_d, --s_waitrequest
    
	    m_addr_d, --m_addr
	    m_read_d, --m_read
	    m_readdata_d, --m_readdata
	    m_write_d, --m_write
	    m_writedata_d, --m_writedata
	    m_waitrequest_d --m_waitrequest
  );  

	--IF STAGE instantiation--
	IF_ST : IF_STAGE port map(
		CLOCK,
		IF_RESET,
		IF_PC_SRC,
		IF_ALU_PC,
		IF_PC_OUT,
		IF_INSTR_OUT
	);
	
	--IF-ID interstage register--
	IF_ID_REG : IF_ID_REGISTER port map(
		CLOCK,
		IF_PC_OUT,
		IF_INSTR_OUT,
		ID_PC_IN,
		ID_INSTR_IN
	);
	
	ID_ST : ID port map(
		CLOCK,
		ID_INSTR_IN,
		ID_PC_IN,
		WB_INSTR_IN(25 downto 21),
		WB_OUT,
		WB_R64_IN,
		ID_CONTROL_REG_WRITE,
		ID_CONTROL_OUT,
		ID_INSTR_OUT,
		ID_PC_OUT,
		ID_READ_OUT,
		ID_SIGN_OUT,
		ID_REGA_OUT,
		ID_REGB_OUT
	);
	
	ID_EX_REG : ID_EX_REGISTER port map(
		CLOCK,
		ID_CONTROL_OUT,
		ID_PC_OUT,
		ID_SIGN_OUT,
		ID_REGA_OUT,
		ID_REGB_OUT,
		ID_INSTR_OUT,
		EX_CONTROL_IN,
		EX_PC_IN,
		EX_SIGN_IN,
		EX_REGA_IN,
		EX_REGB_IN,
		EX_INSTR_IN
	);
	
	EX_ST : EX_STAGE port map(
		EX_REGA_IN,
		EX_REGB_IN,
		EX_SIGN_IN,
		EX_INSTR_IN,
		EX_PC_IN,
		EX_CONTROL_IN(9 downto 6),
		EX_SELA_IN,
		EX_SELB_IN,
		EX_BRANCH_OUT,
		EX_R32_OUT,
		EX_B_OUT,
		EX_INSTR_OUT,
		EX_R64_OUT
	);
	
	EX_MEM_REG : EX_MEM_REGISTER port map(
		CLOCK,
		EX_BRANCH_OUT,
		EX_R32_OUT,
		EX_B_OUT,
		EX_INSTR_OUT,
		EX_R64_OUT,
		MEM_BRANCH_IN,
		MEM_R32_IN,
		MEM_B_IN,
		MEM_INSTR_IN, 
		MEM_R64_IN,
		EX_CONTROL_IN,
		MEM_CONTROL_IN
	);
	
	MEM_ST : MEM_STAGE port map(
		CLOCK,
		MEM_R32_IN,
		MEM_B_IN,
		MEM_INSTR_IN,
		MEM_CONTROL,
		MEM_DATA_OUT,
		MEM_B_OUT,
		MEM_INSTR_OUT
	);
	
	MEM_WB_REG : MEM_WB_REGISTER port map(
		CLOCK,
		MEM_DATA_OUT,
		MEM_INSTR_OUT,
		MEM_B_OUT,
		WB_DATA_IN,
		WB_INSTR_IN,
		WB_B_IN,
		MEM_R64_IN,
		WB_R64_IN,
		MEM_CONTROL_IN,
		WB_CONTROL_OUT
	);
	
	WB_ST : WB_STAGE port map(
		WB_CONTROL_OUT(3),
		WB_DATA_IN,
		WB_B_IN,
		WB_OUT
	);
	
	
	EX_SELA_IN <= '0';
	EX_SELB_IN <= EX_CONTROL_IN(4);
	
	ID_WRITE_REG <= ID_INSTR_IN(15 downto 11);
	
	

end architecture;

