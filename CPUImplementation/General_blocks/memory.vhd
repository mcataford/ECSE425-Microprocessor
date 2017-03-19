--Adapted from Example 12-15 of Quartus Design and Synthesis handbook
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

use std.textio.all;

ENTITY memory IS
	GENERIC(
		ram_size : INTEGER := 32768;
		mem_delay : time := 10 ns;
		clock_period : time := 1 ns;
		from_file : boolean := false;
		file_in : string := "input.txt";
		to_file : boolean := true;
		file_out : string := "output.txt";
		sim_limit : time := 10000 ns
	);

	PORT (
		clock: IN STD_LOGIC;
		writedata: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		address: IN INTEGER RANGE 0 TO (ram_size/4)-1;
		memwrite: IN STD_LOGIC;
		memread: IN STD_LOGIC;
		readdata: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		waitrequest: OUT STD_LOGIC
	);
END memory;

ARCHITECTURE rtl OF memory IS
	TYPE MEM IS ARRAY(ram_size-1 downto 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ram_block: MEM;
	SIGNAL read_address_reg: INTEGER RANGE 0 to (ram_size)/4-1;
	SIGNAL write_waitreq_reg: STD_LOGIC := '1';
	SIGNAL read_waitreq_reg: STD_LOGIC := '1';

      	file file_input : text;
	file file_output : text;
	


BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)

        variable line_content : string(32 downto 1);
      	variable line_num : line;
	variable line_count : integer := 0;
	variable INSTR_READ : std_logic_vector(31 downto 0);
	variable INSTR_WRITE : string (32 downto 1);
	variable MEM_LOOKUP : std_logic_vector(31 downto 0);
	

	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			if not from_file then
				For i in 0 to (ram_size/4)-1 LOOP
					ram_block(i) <= std_logic_vector(to_unsigned(0,32));
				END LOOP;
			else  
				file_open(file_input,file_in,READ_MODE); 

      				while not endfile(file_input) loop
					
      					readline (file_input,line_num);
      					READ (line_num,line_content);
			       	
					for idx in 1 to 32 loop

						if character'pos(line_content(idx)) = 49 then
							INSTR_READ(idx-1) := '1';
						else
							INSTR_READ(idx-1) := '0';
						end if;
					end loop;	

					
					ram_block(line_count) <= INSTR_READ;	
				
					line_count := line_count + 1;

			      end loop;

			      for idx in line_count to (ram_size/4)-1 loop

					ram_block(idx) <= (others => '0');

			      end loop;

			      file_close(file_input);
			end if;

		elsif now >= sim_limit then

			file_open(file_output, file_out, WRITE_MODE);

			for mem_index in 0 to (ram_size / 4)-1 loop
				
				MEM_LOOKUP := ram_block(mem_index);

				for idx in 1 to 32 loop
					if MEM_LOOKUP(idx-1) = '1' then
						INSTR_WRITE(idx) := '1';
					else
						INSTR_WRITE(idx) := '0';
					end if;
				end loop;

				write(line_num, INSTR_WRITE);
				writeline(file_output,line_num);

			end loop;

			file_close(file_output);
			
		end if;

		--This is the actual synthesizable SRAM block
		IF (clock'event AND clock = '1') THEN
			IF (memwrite = '1') THEN
				ram_block(address) <= writedata;
			END IF;
		read_address_reg <= address;
		END IF;
	END PROCESS;
	readdata <= ram_block(read_address_reg);


	--The waitrequest signal is used to vary response time in simulation
	--Read and write should never happen at the same time.
	waitreq_w_proc: PROCESS (memwrite)
	BEGIN
		IF(memwrite'event AND memwrite = '1')THEN
			write_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;

		END IF;
	END PROCESS;

	waitreq_r_proc: PROCESS (memread)
	BEGIN
		IF(memread'event AND memread = '1')THEN
			read_waitreq_reg <= '0' after mem_delay, '1' after mem_delay + clock_period;
		END IF;
	END PROCESS;
	waitrequest <= write_waitreq_reg and read_waitreq_reg;

END rtl;
