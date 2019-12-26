library ieee ;
use ieee.std_logic_1164.all ;
entity tbuf is 
	GENERIC ( n : integer := 32);
	port (d : in std_logic_vector (n-1 downto 0) ;
	      q : out std_logic_vector (n-1  downto 0) ;
	      en : in std_logic
) ;
end tbuf ;

architecture rtl of tbuf is
constant ZVector:   std_logic_vector(n-1  downto 0) := (others => 'Z');
	begin
		q <= d when en = '1' else ZVector ;
end rtl ;