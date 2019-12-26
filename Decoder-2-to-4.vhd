
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity Decoder2To4 is
   port(din : in std_logic_vector(1 downto 0);
        dout : out std_logic_vector(3 downto 0));
end Decoder2To4;
 
architecture Decoder2To4_arch of Decoder2To4 is
begin
   
   dout <="0001" when din="00" else
          "0010" when din="01" else
          "0100" when din="10" else
          "1000" when din="11";

end Decoder2To4_arch;