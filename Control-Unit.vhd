LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 


ENTITY controlUnit IS
	PORT(IR: IN std_logic_vector(15 downto 0);
	carryFlag,zeroFlag,reset,clock:IN std_logic;
	IR_OFFSET: out std_logic_vector(15 downto 0);
	F1: INOUT std_logic_vector(7 downto 0);
	F2: INOUT std_logic_vector(7 downto 0);
	F3: out std_logic_vector(3 downto 0);
	F4: out std_logic_vector(3 downto 0);
	F5: out std_logic_vector(31 downto 0);
	F6: INOUT std_logic_vector(3 downto 0);
	addressNow:inout  STD_LOGIC_VECTOR(6 DOWNTO 0);
	Reg_out: out std_logic_vector(7 downto 0);
	Reg_in: out std_logic_vector(7 downto 0)
); 
END ENTITY controlUnit;

--F3 4 bits
--F3(0) No transfer
--F3(1) MAR_IN
--F3(2) MDR_IN
--F1,F2,F4,F5,F6 like F3, to get what you want check phase 1 Doc




ARCHITECTURE controlUnit_arch OF controlUnit IS
COMPONENT rom128x29 IS
port(address: in std_logic_vector(6 downto 0);
data: out std_logic_vector(28 downto 0));
END COMPONENT;


COMPONENT masterSlave is 
	PORT( Clk,Rst : IN std_logic;
	      d : IN std_logic_vector(6 DOWNTO 0);
	      q : OUT std_logic_vector(6 DOWNTO 0));
end COMPONENT ;


COMPONENT Decoder3To8 IS
   port(din : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(7 downto 0));
END COMPONENT;


COMPONENT Decoder2To4 IS
   port(din : in std_logic_vector(1 downto 0);
        dout : out std_logic_vector(3 downto 0));
END COMPONENT;


COMPONENT Decoder5To32 IS
   port(din : in std_logic_vector(4 downto 0);
        dout : out std_logic_vector(31 downto 0));
END COMPONENT;



COMPONENT DecoderSrcDst IS
   port(RegIn,RegOut : in std_logic;
	din : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(15 downto 0));
END COMPONENT;


COMPONENT decodingCircuit IS
PORT (F7 :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);--OR Enable
F8 :  IN STD_LOGIC_VECTOR(6 DOWNTO 0); --next address
IR :  IN STD_LOGIC_VECTOR(15 DOWNTO 0); --IR
carryFlag,zeroFlag: IN STD_LOGIC;
microAR: OUT  STD_LOGIC_VECTOR(6 DOWNTO 0));-- new next address 
END COMPONENT;


SIGNAL microAr_in,microAr_out  :std_logic_vector(6 downto 0);
SIGNAL F7  :std_logic_vector(31 downto 0);
SIGNAL rom_out  :std_logic_vector(28 downto 0);
SIGNAL src  :std_logic_vector(15 downto 0);
SIGNAL dst  :std_logic_vector(15 downto 0);




BEGIN
addressNow<=microAr_out;
decoding_Circuit: decodingCircuit PORT MAP(F7,rom_out(6 downto 0),IR,carryFlag,zeroFlag,microAr_in);

rom: rom128x29 PORT MAP(microAr_out,rom_out);

microAr: masterSlave PORT MAP(clock,reset,microAr_in,microAr_out);

F1_decoder: Decoder3To8 PORT MAP(rom_out(28 downto 26),F1);
F2_decoder: Decoder3To8 PORT MAP(rom_out(25 downto 23),F2);
F3_decoder: Decoder2To4 PORT MAP(rom_out(22 downto 21),F3);
F4_decoder: Decoder2To4 PORT MAP(rom_out(20 downto 19),F4);
F5_decoder: Decoder5To32 PORT MAP(rom_out(18 downto 14),F5);
F6_decoder: Decoder2To4 PORT MAP(rom_out(13 downto 12),F6);
F7_decoder: Decoder5To32 PORT MAP(rom_out(11 downto 7),F7);

src_decoder: DecoderSrcDst PORT MAP(F2(4),F1(4),IR(8 downto 6),src);
dst_decoder: DecoderSrcDst PORT MAP(F2(5),F1(5),IR(2 downto 0),dst);

Reg_out<=src(7 downto 0) or dst(7 downto 0);
Reg_in<=src(15 downto 8) or dst(15 downto 8);

IR_OFFSET(7 downto 0)<=IR(7 downto 0) when F6(3)='1' else
(others => 'Z');

IR_OFFSET(15 downto 8)<=(others => '0') when F6(3)='1' and IR(7)='0' else
(others => '1')  when F6(3)='1' and IR(7)='1' else
(others => 'Z');
 
END controlUnit_arch;
