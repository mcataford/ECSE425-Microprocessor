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
		from_file : boolean := true
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
BEGIN
	--This is the main section of the SRAM model
	mem_process: PROCESS (clock)
	BEGIN
		--This is a cheap trick to initialize the SRAM in simulation
		IF(now < 1 ps)THEN
			if not from_file then
				For i in 0 to (ram_size/4)-1 LOOP
					ram_block(i) <= std_logic_vector(to_unsigned(0,32));
				END LOOP;
			else
				

			end if;

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

	--FILE IO reading the program into memory as needed.--
	process
      file file_pointer : text;
        variable line_content : string(1 to 4);
      variable line_num : line;
        variable j : integer := 0;
        variable char : character :='0';
   begin
        --Open the file read.txt from the specified location for reading(READ_MODE).
      file_open(file_pointer,"C:\read.txt",READ_MODE);   
      while not endfile(file_pointer) loop --till the end of file is reached continue.
      readline (file_pointer,line_num);  --Read the whole line from the file
        --Read the contents of the line from  the file into a variable.
      READ (line_num,line_content);
        --For each character in the line convert it to binary value.
        --And then store it in a signal named 'bin_value'.
        for j in 1 to 4 loop       
            char := line_content(j);
            if(char = '0') then
               --
            else
               -- bin_value(4-j) <= '1';
            end if;
        end loop;  
        wait for 10 ns; --after reading each line wait for 10ns.
      end loop;
      file_close(file_pointer);  --after reading all the lines close the file. 
        wait;
    end process;


END rtl;
