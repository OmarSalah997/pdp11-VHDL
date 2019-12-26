library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity Decoder3To8 is
   port(din : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(7 downto 0));
end Decoder3To8;
 
architecture Decoder3To8_arch of Decoder3To8 is
begin
   
   dout <="00000001" when din="000"else
	  "00000010" when din="001"else
	  "00000100" when din="010"else
	  "00001000" when din="011"else
	  "00010000" when din="100"else
	  "00100000" when din="101"else
	  "01000000" when din="110"else
	  "10000000" when din="111";

end Decoder3To8_arch;