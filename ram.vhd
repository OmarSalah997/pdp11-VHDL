LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all; 
ENTITY ram IS
	PORT(
		clk : IN std_logic;
		Wr  : IN std_logic;	
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE syncrama OF ram IS
	TYPE ram_type IS ARRAY(0 TO 65535) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type := (
"0011101111000011",
"0000000000010011",
"1100000001000011",
"0011000011000100",
"0011001111000101",
"0000000000010100",
"0011001101000001",
"1010000001100101",
"1111010000000101",
"0011000001000010",
"0011100101000000",
"0011000000010101",
"1100000000000101",
"0011000010100101",
"1100000001000100",
"1111001011110110",
"1100000001000011",
"1111001011110001",
"1001000000000000",
"0000000000000101",
"0000000001000110",
"1111111111111101",
"0000000000001101",
"0000000001000100",
"0000001100000000",



OTHERS => "1000000000000000"
	);
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) and Wr ='1' THEN  
						ram(to_integer(unsigned(address))) <= datain;
				END IF;
		END PROCESS;
		dataout <= ram(to_integer(unsigned(address)));
END syncrama;
