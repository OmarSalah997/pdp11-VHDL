LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
USE ieee.std_logic_misc.all;
--s1 add
--s2 sub
--s4 sbc
--s5 and
--s6 or
--s7 xnor
--s8 ADC
--s16 inc
--s17 dec
--s18 clr
--s19 inv
--s20 logic shift r 
--s21 ror
--s22 rrc
--s23 arithmetic shift right
--s24 logic shift l
--s25 rotate left
--s26 rotate left carry

ENTITY ALU IS
	PORT(A,B: IN std_logic_vector(15 downto 0);
	     S: IN std_logic_vector(31 downto 0);
	     Rst,flag_en:IN std_logic;
	     F: INOUT  std_logic_vector(15 downto 0);
	     flagReg_out: INOUT std_logic_vector(4 downto 0)); 
END ENTITY ALU;

ARCHITECTURE Data_flow OF ALU IS

component my_nadder is
GENERIC (n : integer := 16);
	PORT(a,b : IN std_logic_vector(n-1 DOWNTO 0);
	     cin : IN std_logic;
	     f : OUT std_logic_vector(n-1 DOWNTO 0);
	     cout : OUT std_logic);
end component;		 
SIGNAL flagReg_in :std_logic_vector(4 downto 0);
SIGNAL Cout,Z,O,N,P,EnableFlagReg,carry_artihmetic,carry_artihmetic_out :std_logic;
signal rotate_right_vector : std_logic_vector(16 downto 0);
signal sigA,sigB,fout : std_logic_vector (15 downto 0);
constant ONE:   UNSIGNED(15 downto 0) := (0 => '1', others => '0');
begin
nadder:  my_nadder generic map(16) port map(sigA,sigB,carry_artihmetic,fout,carry_artihmetic_out);
sigA<= A  when S(1) ='1' or S(2) ='1' or S(4) ='1' or S(8) ='1' or S(16)='1' or S(17)='1' else 
		(others => '0');


sigB<= B  when S(1) ='1' or S(8) ='1' else
       std_logic_vector(unsigned (not B) + ONE) when  S(2) ='1' or(flagReg_out(0) = '0'  and S(4) ='1') else 
	   not(B) when flagReg_out(0) = '1'  and S(4) ='1'else
	   (others => '1') when S(17)='1' else 
	   (others => '0');

carry_artihmetic<= '0' when S(1) ='1'  or S(2) ='1' or S(4) ='1' or S(17)='1' else 
					flagReg_out(0) when S(8) ='1' else '1';


rotate_right_vector<=STD_LOGIC_VECTOR(rotate_right(unsigned(A&flagReg_out(0)),1));
f<= fout when S(1)  = '1'  or S(2)='1'or S(4) ='1'or S(8) ='1'or S(16)='1'or S(17)='1' else
	STD_LOGIC_VECTOR(shift_right(unsigned(A), 1))  when  S(20) = '1' else
	STD_LOGIC_VECTOR(rotate_right(unsigned(A),1))  when  S(21) = '1' else
	rotate_right_vector(16 downto 1)   			   when  S(22) = '1' else
	STD_LOGIC_VECTOR(shift_right(signed(A), 1))    when  S(23) = '1' else 
	(A AND B) when S(5) = '1'  else 
	(A OR B) when S(6) = '1' else 
	(A XNOR B) when S(7) = '1' else 
	(NOT A) when S(19)='1'  else
	STD_LOGIC_VECTOR(shift_left(unsigned(A), 1)) when S(24)='1' else
	STD_LOGIC_VECTOR(rotate_left(unsigned(A),1)) when S(25)='1' else
	STD_LOGIC_VECTOR(rotate_left(unsigned(A),1)) when S(26)='1' else (others =>'0') ;
Cout<=carry_artihmetic_out when S(1) ='1'or S(8) ='1'or S(16)='1'or S(17)='1'  else
     (not carry_artihmetic_out) when  S(2) ='1'or S(4) ='1' else 
	A(0) when  S(22) = '1' or S(23) = '1' else 
	A(15) when S(26) ='1'
	else '0'; 	
--flage register
EnableFlagReg<=(S(1) or S(2)  or S(4)  or S(8) or S(16) or S(17) or S(18) or S(5)  or S(6)  or S(7)  or S(19) or S(20)   or S(21)  or S(22)   or S(23)) and flag_en ;
Z<= '1' when F="0000000000000000" else '0';
N<= '1' when F(15) = '1' else '0';
P<= '1' when F(0) = '0' else '0';
O<= '1' when A(15) = '0' and B(15)='0' and F(15)='1' and (S(1) ='1' or S(8) ='1') 
else'1' when A(15) = '1' and B(15)='1' and F(15)='0' and (S(1) ='1' or S(8) ='1')
else'1' when A(15) = '0' and B(15)='1' and F(15)='1' and (S(2) ='1' or S(4) ='1')
else'1' when A(15) = '1' and B(15)='0' and F(15)='0' and (S(2) ='1' or S(4) ='1')
else'0';
flagReg_in<= O & P & N & Z & Cout;
flagReg_out<= flagReg_in when falling_edge(EnableFlagReg) else
(OTHERS=>'0') when Rst='1';
end architecture;