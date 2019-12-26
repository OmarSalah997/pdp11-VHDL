
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY latch IS
	GENERIC ( n : integer := 16);
	PORT( E,Clk,Rst : IN std_logic;
	      d : IN std_logic_vector(n-1 DOWNTO 0);
	      q : OUT std_logic_vector(n-1 DOWNTO 0));
END latch;




ARCHITECTURE a_latch OF latch IS
BEGIN
PROCESS (Clk,Rst,E)
BEGIN
	IF Rst = '1' THEN q <= (OTHERS=>'0');
	ELSIF E = '1'   THEN q <= d;
	END IF;
END PROCESS;
END a_latch;