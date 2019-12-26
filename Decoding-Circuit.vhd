LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decodingCircuit IS  
PORT (F7 :  IN STD_LOGIC_VECTOR(31 DOWNTO 0);--OR Enable
F8 :  IN STD_LOGIC_VECTOR(6 DOWNTO 0); --next address
IR :  IN STD_LOGIC_VECTOR(15 DOWNTO 0); --IR
carryFlag,zeroFlag: IN STD_LOGIC;
microAR: OUT  STD_LOGIC_VECTOR(6 DOWNTO 0));-- new next address   
END ENTITY decodingCircuit;


--F7(0) NO OPERATION
--F7(1) OR_OPERAND
--F7(2) OR_2_OPERAND
--F7(3) OR_BRANCH
--F7(4) OR_DSTMOD
--F7(5) OR_EXMOV
--F7(6) OR_SRCIND
--F7(7) OR_DSTIND
--F7(8) OR_STOR
--F7(9) OR_EXOP
--F7(10) OR_EX2OP
--F7(11) OR_EX1OP
--F7(12) OR_CMP
--F7(13) OR_BEQ
--F7(14) OR_BNE
--F7(15) OR_BLO
--F7(16) OR_BLS
--F7(17) OR_BHI
--F7(18) OR_BHS
--F7(19) OR_HLT

ARCHITECTURE decodingCircuit_arch OF decodingCircuit IS
BEGIN
microAR(3)<=F8(3) or (F7(11) and IR(9));


microAR(4)<=F8(4) 
or (F7(15) and Not(carryFlag)) 
or(F7(13) and zeroFlag)
or(F7(14) and Not(zeroFlag))
or (F7(17) and carryFlag)
or(F7(18) and (carryFlag or zeroFlag ))
or(F7(16) and (not(carryFlag) or zeroFlag ))
or (F7(5) and (IR(15) or IR(14)Or not(IR(13))  or not(IR(12)) ) );

microAR(5)<=F8(5)
or (F7(5) and (IR(15) or IR(14)Or not(IR(13))  or not(IR(12)) ) )
or (F7(13) and not(zeroFlag) )
or (F7(14) and zeroFlag)
or (F7(17) and carryFlag)
or (F7(16) and Not(zeroFlag) and carryFlag)
or (F7(18) and not(zeroFlag) and Not(carryFlag) );

microAR(6)<=F8(6)
or (F7(15) and Not(carryFlag)) 
or(F7(13) and zeroFlag)
or(F7(14) and Not(zeroFlag))
or (F7(17) and carryFlag)
or(F7(18) and (carryFlag or zeroFlag ))
or(F7(16) and (not(carryFlag) or zeroFlag ))
or (F7(5) and not(IR(15)) and not(IR(14)) and IR(13) and IR(12));


microAR(0)<=F8(0)
or (  F7(1) and ( not(IR(15)) or IR(13) ) )
or ( F7(6) and not(IR(11))     )
or ( F7(19) and IR(12) )
or(  F7(7) and not(IR(5))   )
or( F7(2) and (IR(9)) )
or( F7(4) and IR(3) )
or( F7(3) and IR(8) )
or( F7(8) and ( IR(5) or IR(4) or IR(3) ) )
or( F7(9) and IR(15) and IR(14) )
or( F7(10) and IR(12) )
or( F7(11) and IR(6) )
or( F7(12) and not(IR(15)) );


microAR(1)<=F8(1)
or( F7(10) and IR(13) )
or( F7(1) and IR(15) and IR(14)  )
or( F7(19) and IR(12) )
or( F7(11) and IR(7) )
or( F7(2) and IR(10) )
or( F7(4) and IR(4) )
or( F7(3) and IR(9) );



microAR(2)<=F8(2)
or( F7(2) and IR(11) and not(IR(10)) and not(IR(9)) )
or( F7(10) and IR(14) )
or( F7(11) and IR(8) )
or( F7(4) and IR(5) and not(IR(4)) and not(IR(3)) )
or( F7(3) and IR(10) );

END decodingCircuit_arch;