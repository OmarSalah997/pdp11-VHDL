library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
 
entity DecoderSrcDst is
   port(RegIn,RegOut : in std_logic;
	din : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(15 downto 0));
end DecoderSrcDst;
 --fisrt 8bits for out R0_OUT,R1_OUT.......etc
 --second 8bits for in R0_in,R1_in.......etc
architecture DecoderSrcDst_arch of DecoderSrcDst is
begin
   
   dout <="0000000000000000" when (RegIn='0' and RegOut='0') or (RegIn='1' and RegOut='1') else
	  "0000000000000001" when RegIn='0' and RegOut='1' and din="000" else
	  "0000000000000010" when RegIn='0' and RegOut='1' and din="001"else
	  "0000000000000100" when RegIn='0' and RegOut='1' and din="010"else
	  "0000000000001000" when RegIn='0' and RegOut='1' and din="011"else
	  "0000000000010000" when RegIn='0' and RegOut='1' and din="100"else
	  "0000000000100000" when RegIn='0' and RegOut='1' and din="101"else
	  "0000000001000000" when RegIn='0' and RegOut='1' and din="110"else
	  "0000000010000000" when RegIn='0' and RegOut='1' and din="111"else
	  "0000000100000000" when RegIn='1' and RegOut='0' and din="000"else
	  "0000001000000000" when RegIn='1' and RegOut='0' and din="001"else
	  "0000010000000000" when RegIn='1' and RegOut='0' and din="010"else
	  "0000100000000000" when RegIn='1' and RegOut='0' and din="011"else
	  "0001000000000000" when RegIn='1' and RegOut='0' and din="100"else
	  "0010000000000000" when RegIn='1' and RegOut='0' and din="101"else
	  "0100000000000000" when RegIn='1' and RegOut='0' and din="110"else
	  "1000000000000000" when RegIn='1' and RegOut='0' and din="111";

end DecoderSrcDst_arch;