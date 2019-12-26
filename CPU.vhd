LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE ieee.numeric_std.all; 
ENTITY CPU IS
	generic(ALU_n: integer:=16);
	PORT( bidir: INOUT std_logic_vector(ALU_n-1 downto 0);
	     Global_Clk,Rst:IN std_logic); 
END ENTITY CPU;

ARCHITECTURE Data_flow OF CPU IS
COMPONENT my_nDFF IS
	GENERIC ( n : integer := 16);
	PORT( E,Clk,Rst : IN std_logic;
	      d : IN std_logic_vector(n-1 DOWNTO 0);
	      q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;
component ALU is
PORT(A,B: IN std_logic_vector(15 downto 0);
	     S: IN std_logic_vector(31 downto 0);
	     Rst,flag_en:IN std_logic;
	     F: INOUT  std_logic_vector(15 downto 0);
	     flagReg_out: INOUT std_logic_vector(4 downto 0)); 
end component;
component ram is 
PORT(
		clk : IN std_logic;
		Wr  : IN std_logic;	
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END component ;

component controlUnit is
	PORT(IR: IN std_logic_vector(15 downto 0);
	carryFlag,zeroFlag,reset,clock:IN std_logic;
	IR_OFFSET: out std_logic_vector(15 downto 0);
	F1: INOUT std_logic_vector(7 downto 0);
	F2: INOUT std_logic_vector(7 downto 0);
	F3: out   std_logic_vector(3 downto 0);
	F4: out   std_logic_vector(3 downto 0);
	F5: out   std_logic_vector(31 downto 0);
	F6: INOUT std_logic_vector(3 downto 0);
	addressNow:inout  STD_LOGIC_VECTOR(6 DOWNTO 0);
	Reg_out: out std_logic_vector(7 downto 0);
	Reg_in: out std_logic_vector(7 downto 0)
); 
END component ;
COMPONENT tbuf is 
	GENERIC ( n : integer := 32);
	port (d : in std_logic_vector (n-1 downto 0) ;
	     q : out std_logic_vector (n-1  downto 0) ;
	      en : in std_logic) ;
end COMPONENT ;

COMPONENT latch IS
	GENERIC ( n : integer := 16);
	PORT( E,Clk,Rst : IN std_logic;
	      d : IN std_logic_vector(n-1 DOWNTO 0);
	      q : OUT std_logic_vector(n-1 DOWNTO 0));
end COMPONENT ;

SIGNAL r0_out,r1_out,r2_out,r3_out,r4_out,r5_out,r6_out,r7_out,src_out,dist_out,Y_out,Z_out_data,Z_in_data,Ir_out,data_out,mdr_out,mar_out :std_logic_vector(ALU_n-1 downto 0);
constant ZVector:   std_logic_vector(ALU_n-1  downto 0) := (others => 'Z');
signal flag_out : std_logic_vector(4 downto 0);
signal F1:  std_logic_vector(7 downto 0);
signal F2:std_logic_vector(7 downto 0);
signal F3: std_logic_vector(3 downto 0);
signal F4:  std_logic_vector(3 downto 0);
signal F5:  std_logic_vector(31 downto 0);
signal F6:std_logic_vector(3 downto 0);
signal Reg_out: std_logic_vector(7 downto 0);
signal Reg_in: std_logic_vector(7 downto 0) ;
signal marA: std_logic_vector(6 downto 0) ;
SIGNAL enableMDR,pc_in,pc_out :std_logic;
SIGNAL mdr_in :std_logic_vector(ALU_n-1 downto 0);
BEGIN
   enableMDR<=F3(2) or F6(1);
   pc_in<=Reg_in(7) or F2(1);
   pc_out<=Reg_out(7) or F1(1);
   mdr_in<=data_out when F6(1)='1' else bidir; 
   r0: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(0) ,Global_Clk,Rst,bidir,r0_out);  
   r1: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(1) ,Global_Clk,Rst,bidir,r1_out);  
   r2: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(2) ,Global_Clk,Rst,bidir,r2_out);  
   r3: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(3) ,Global_Clk,Rst,bidir,r3_out);
   r4: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(4) ,Global_Clk,Rst,bidir,r4_out);  
   r5: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(5) ,Global_Clk,Rst,bidir,r5_out);  
   r6: my_nDFF generic map(ALU_n) PORT MAP (Reg_in(6) ,Global_Clk,Rst,bidir,r6_out);  
   r7: my_nDFF generic map(ALU_n) PORT MAP (pc_in ,Global_Clk,Rst,bidir,r7_out);
   src_temp:my_nDFF generic map(ALU_n) PORT MAP (F4(2) ,Global_Clk,Rst,bidir,src_out);
   dist_temp:my_nDFF generic map(ALU_n) PORT MAP (F4(3) ,Global_Clk,Rst,bidir,dist_out);
   Ir_out<=bidir when F2(2)='1' else
   (OTHERS=>'0') when Rst='1' ;
   Z_out_data<=Z_in_data when F2(3)='1' else
   (OTHERS=>'0') when Rst='1';
   Y: my_nDFF generic map(ALU_n) PORT MAP (F4(1) ,Global_Clk,Rst,bidir,Y_out);
  mdr_reg: latch generic map(ALU_n) PORT MAP (enableMDR,Global_Clk ,Rst,mdr_in,mdr_out); 
   mar: my_nDFF generic map(ALU_n) PORT MAP (F3(1) ,Global_Clk,Rst,bidir,mar_out); 
   t0: tbuf generic map(ALU_n) PORT MAP (r0_out,bidir,	Reg_out(0)); 
   t1: tbuf generic map(ALU_n) PORT MAP (r1_out,bidir,	Reg_out(1)); 
   t2: tbuf generic map(ALU_n) PORT MAP (r2_out,bidir,	Reg_out(2)); 
   t3: tbuf generic map(ALU_n) PORT MAP (r3_out,bidir,	Reg_out(3)); 
   t4: tbuf generic map(ALU_n) PORT MAP (r4_out,bidir,	Reg_out(4)); 
   t5: tbuf generic map(ALU_n) PORT MAP (r5_out,bidir,	Reg_out(5)); 
   t6: tbuf generic map(ALU_n) PORT MAP (r6_out,bidir,	Reg_out(6)); 
   t7: tbuf generic map(ALU_n) PORT MAP (r7_out,bidir,	pc_out); 
   tsrc: tbuf generic map(ALU_n) PORT MAP (src_out,bidir,F1(6)); 
   tdist: tbuf generic map(ALU_n) PORT MAP (dist_out,bidir,F1(7));
   t_mdr: tbuf generic map(ALU_n) PORT MAP (mdr_out,bidir,F1(2)); 
   tZ: tbuf generic map(ALU_n) PORT MAP (Z_out_data,bidir,F1(3));                                                                                        
   ALU_C:ALU generic map(ALU_n) PORT MAP (Y_out,bidir,F5,Rst,F1(6),Z_in_data,flag_out);
   MY_control_unit: controlUnit port map (Ir_out,flag_out(0),flag_out(1),Rst,Global_Clk,bidir,F1,F2,F3,F4,F5,F6,marA,Reg_out,Reg_in);
   my_ram: ram generic map(ALU_n) PORT MAP(Global_Clk,F6(2),mar_out,mdr_out,data_out);
     
END Data_flow;
