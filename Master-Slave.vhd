LIBRARY IEEE;
USE IEEE.std_logic_1164.all;


ENTITY masterSlave IS
	PORT( Clk,Rst : IN std_logic;
	      d : IN std_logic_vector(6 DOWNTO 0);
	      q : OUT std_logic_vector(6 DOWNTO 0));
END masterSlave;




ARCHITECTURE masterSlave_arch OF masterSlave IS
SIGNAL masterOut :std_logic_vector(6 downto 0);
BEGIN
PROCESS (Clk,Rst)
BEGIN
	IF Rst = '1' THEN q <= (OTHERS=>'0'); masterOut<= (OTHERS=>'0');
	ELSIF rising_edge(Clk)  THEN masterOut <= d;
	ELSIF falling_edge(Clk)  THEN q <= masterOut;
	END IF;
END PROCESS;
END masterSlave_arch;