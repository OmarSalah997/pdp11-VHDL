two_operand_instructions={'MOV':'0011','ADD': '0001',
'ADC': '0000',
'SUB':'0010',
'SBC':'0100',
'AND': '0101',
'OR':'0110',
'XNOR':'0111' ,
'CMP':'1010' 
}
one_operand_instructions={'INC':'1100000000','DEC':'1100000001','CLR':'1100000010','INV':'1100000011','LSR':'1100000100',
'LSL':'1100001000','ROR':'1100000101','ROL':'1100001001','RRC':'1100000110','RLC':'1100001010','ASR':'1100000111'}

Branch={'BR':'11110000','BEQ':'11110001','BNE':'11110010','BLO':'11110011','BLS':'11110100','BHI':'11110101','BHS':'11110110'}
src={'R0':'000000','R1':'000001','R2':'000010','R3':'000011','R4':'000100','R5':'000101','R6':'000110','R7':'000111',
'(R0)+':'001000','(R1)+':'001001','(R2)+':'001010','(R3)+':'001011','(R4)+':'001100','(R5)+':'001101','(R6)+':'001110','(R7)+':'001111',
'-(R0)':'010000','-(R1)':'010001','-(R2)':'010010','-(R3)':'010011','-(R4)':'010100','-(R5)':'010101','-(R6)':'010110','-(R7)':'010111', 
'X(R0)':'011000','X(R1)':'011001','X(R2)':'011010','X(R3)':'011011','X(R4)':'011100','X(R5)':'011101','X(R6)':'011110','X(R7)':'011111', 

'@R0':'100000','@R1':'100001','@R2':'100010','@R3':'100011','@R4':'100100','@R5':'100101','@R6':'100110','@R7':'100111',
'@(R0)+':'101000','@(R1)+':'101001','@(R2)+':'101010','@(R3)+':'101011','@(R4)+':'101100','@(R5)+':'101101','@(R6)+':'101110','@(R7)+':'101111',
'@-(R0)':'110000','@-(R1)':'110001','@-(R2)':'110010','@-(R3)':'110011','@-(R4)':'110100','@-(R5)':'110101','@-(R6)':'110110','@-(R7)':'110111', 
'@X(R0)':'111000','@X(R1)':'111001','@X(R2)':'111010','@X(R3)':'111011','@X(R4)':'111100','@X(R5)':'111101','@X(R6)':'111110','@X(R7)':'111111'      
}
Dist={'R0':'000000','R1':'000001','R2':'000010','R3':'000011','R4':'000100','R5':'000101','R6':'000110','R7':'000111',
'(R0)+':'001000','(R1)+':'001001','(R2)+':'001010','(R3)+':'001011','(R4)+':'001100','(R5)+':'001101','(R6)+':'001110','(R7)+':'001111',
'-(R0)':'010000','-(R1)':'010001','-(R2)':'010010','-(R3)':'010011','-(R4)':'010100','-(R5)':'010101','-(R6)':'010110','-(R7)':'010111', 
'X(R0)':'011000','X(R1)':'011001','X(R2)':'011010','X(R3)':'011011','X(R4)':'011100','X(R5)':'011101','X(R6)':'011110','X(R7)':'011111', 

'@R0':'100000','@R1':'100001','@R2':'100010','@R3':'100011','@R4':'100100','@R5':'100101','@R6':'100110','@R7':'100111',
'@(R0)+':'101000','@(R1)+':'101001','@(R2)+':'101010','@(R3)+':'101011','@(R4)+':'101100','@(R5)+':'101101','@(R6)+':'101110','@(R7)+':'101111',
'@-(R0)':'110000','@-(R1)':'110001','@-(R2)':'110010','@-(R3)':'110011','@-(R4)':'110100','@-(R5)':'110101','@-(R6)':'110110','@-(R7)':'110111', 
'@X(R0)':'111000','@X(R1)':'111001','@X(R2)':'111010','@X(R3)':'111011','@X(R4)':'111100','@X(R5)':'111101','@X(R6)':'111110','@X(R7)':'111111'      
}
variables={}
variablesvalues={}
lables={}
readfile="final_test3.txt"
outfile="aaaaa.txt"
import os
# Handle errors while calling os.remove()
#debugging purpose
try:
    os.remove(outfile)
except:
    print("Error while deleting file ", outfile)
    
########################################################################
def fix_length_16(assembledline: str) -> str:
    diff = 16 - len(assembledline)
    if(diff == 0):
        return assembledline
    fixed = ''
    for i in range (diff):
        fixed += '0'
    fixed+= assembledline
    return fixed

def fix_length_8(assembledline: str) -> str:
    diff = 8 - len(assembledline)
    if(diff == 0):
        return assembledline
    fixed = ''
    for i in range (diff):
        fixed += '0'
    fixed+= assembledline
    return fixed
#################################################################################################################33
########################################## reading variables and storing their values
for line in reversed(list(open(readfile))):   
    line=line.rstrip()
    if('HLT' in line):
        break
    if('Define' in line):
        define,var,value=line.split()
        if(define=='Define'):
            variables.update({var.upper():-1})#here i store the binary value but i discard it LATER ,HOW TO STORE IT? 
#################################################################################
######lables
count=0        
for line in list(open(readfile)):   
    line=line.rstrip()
    if(line.upper()=='HLT' or line.upper()=='NOP'):
        count+=1
        continue 
#    if('.='in line):
#        line = line[2:]
#        count=int(line)
#        continue
    if('Define'in line):
        define,var,value=line.split()
        variables.update({var.upper():count})
        variablesvalues.update({var.upper():value})
        count+=1
        continue
    if(line[-1:]==':'):
        lables.update({line.upper()[:-1]:count})
        #count+=1
        continue
    instruction,operands=line.split()
    for v in variables.items():
        if(v[0] in operands.upper()):
            count+=1
    if(operands.find(',')!=-1): #this means 2 operand instruction,need to separate the operands
        operand1,operand2=operands.split(',')
        if('#' in operand1):
           count+=1
        else:
            tstforidxsrc=''
            i=0
            if('@'in operand1):
                i=1
            while operand1[i] != '(' and i < len(operand1)-1:
               tstforidxsrc+=operand1[i]
               i+=1
            if(tstforidxsrc.isdigit()):
                count+=1
        if('#' in operand2):
           count+=1
        else:
            tstforidxdist=''
            i=0
            if('@'in operand2):
                i=1
            while operand2[i] != '(' and( i < len(operand2)-1):
               tstforidxdist+=operand2[i]
               i+=1
            if(tstforidxdist.isdigit()):
                count+=1  
    elif(operands.find(',')==-1): #this means 1 operand instruction
            if('#' in operands):
               count+=1
            else:
                tstforidxdist=''
                i=0
                if('@'in operands):
                    i=1
                while operands[i] != '(' and i < len(operands)-1:
                   tstforidxdist+=operands[i]
                   i+=1
                if(tstforidxdist.isdigit()):
                    count+=1   
    count+=1           
#####################################################################################
#reading from top till HLT
#this code handles only 2 operand instructions with different addressing modes included in the above dictionaries
f= open(readfile, "r")
out = open(outfile, "w")
flag2operand=False
flag1operand=False
flagbranch=False
flag1stoperand=False
flag2ndoperand=False
indexedsrc=False
indexeddist=False
valueforindexedsrc=0
valueforindexeddist=0
variableflag1=False
variableflag2=False
line=f.readline()
assembledline=''
count=0
immediate=False
#print('before loop  ',line)
while(f and line.upper()!='HLT'):
    line=line.rstrip()
    if('.='in line):
        line = line[2:]
        count=int(line)
        line=f.readline()
        continue
    if(line[-1:]==':'):#means that`s a label
        line=f.readline()
        continue
    if(line.upper()=='HLT'):
        
        break
    if(line.upper()=='NOP'):
        out.write("\"1000000000000000\""+",")
        line=f.readline()
        continue
    count+=1
    flag2operand=False #reset flags
    flag1operand=False
    flagbranch=False
    flag1stoperand=False
    flag2ndoperand=False
    indexedsrc=False
    indexeddist=False
    valueforindexedsrc=0
    valueforindexeddist=0
    variableflag1=False
    variableflag2=False
    assembledline=''
    value1=0
    value2=0
    immediate=False
    immediatevalue=0
    if(' ' in line):#check if there is a space,then it`s one or 2 operands
        instruction,operands=line.split()
        for x in two_operand_instructions.items():
            if(x[0]==instruction.upper()):
                #out = open("assembled.txt", "w")
                assembledline+=x[1]
                flag2operand=True
                break
        if(flag2operand and operands.find(',')!=-1 ):#here if the flag is true,and the value of the check isn`t -1,then im sure there will be 2 operands
            operand1,operand2=operands.split(',')
            for y in src.items():
                if(y[0]==operand1.upper()):
                    #need to check if it`s indexed
#                    if(operand1[0].upper()=='X'):
#                        valueforindexedsrc="{0:b}".format(int(f.readline()))
#                        indexedsrc=True
                    assembledline+=y[1]
                    flag1stoperand=True
                    break
            if(flag1stoperand==False):#i didn`t find it in the registers,so maybe it`s a variable?
                for v in variables.items():
                    if(v[0] in operand1.upper()):
                        count+=1
                        if('@' in operand1.upper()):
                            if('#' in operand1.upper()):
                               assembledline+=src['@(R7)+']
                            else:
                                assembledline+=src['@X(R7)']
                        else:
                            assembledline+=src['X(R7)']
                        flag1stoperand=True
                        variableflag1=True
                        value1=int(v[1])-count
                        value1=str(bin(value1 if int(value1)>0 else value1+(2**16)))
                        value1 = value1[2:]
                        break
            if(flag1stoperand==False):#here we search for #value
                if('#' in operand1.upper() and( ('R' in operand1.upper())==False)):
                   assembledline+=src['(R7)+']
                   immediate=True
                   immediatevalue=operand1[1:]
                   flag1stoperand=True
                   count+=1
            if(flag1stoperand==False):#here we handle indexed
                idx=''
                i=0
                if('@'in operand1):
                    i=1
                while operand1[i] != '(' and i < len(operand1)-1:
                   idx+=operand1[i]
                   i+=1
                operand1=operand1.replace(idx, 'X')   
                for y in src.items():
                    if(y[0]==operand1.upper()): 
                        assembledline+=y[1]
                        indexedsrc=True
                        flag1stoperand=True
                        count+=1
            if(flag1stoperand):   #if i found the 1st operand i will continue searching for the 2nd,else i will write an error message      
                for z in Dist.items():
                    if(z[0]==operand2.upper()):
#                        if(operand2[0].upper()=='X'):
#                            valueforindexeddist="{0:b}".format(int(f.readline()))
#                            indexeddist=True
                        assembledline=assembledline+z[1]
                        flag2ndoperand=True
                        break
                if(flag2ndoperand==False):#i didn`t find it in the registers,so maybe it`s a variable?
                    for v in variables.items():
                        if(v[0] in operand2.upper()):
                            count+=1
                            if('@' in operand2.upper()):
                                if('#' in operand2.upper()):
                                   assembledline+=src['@(R7)+']
                                else:
                                    assembledline+=src['@X(R7)']
                            else:
                                assembledline+=src['X(R7)']
                            flag2ndoperand=True
                            variableflag2=True
                            value2=int(v[1])-count
                            value2=str(bin(value2 if int(value2)>0 else value2+(2**16)))
                            value2 = value2[2:]
                            break
            #elif(flag1stoperand==False):#now it might be  indexed register
                if(flag2ndoperand==False):
                    idx2=''
                    i=0
                    if('@'in operand2):
                        i=1
                    while operand2[i] != '(' and i < len(operand2)-1:
                       idx2+=operand2[i]
                       i+=1
                    operand2=operand2.replace(idx2, 'X')   
                    for y in src.items():
                        if(y[0]==operand2.upper()): 
                            assembledline+=y[1]
                            indexeddist=True
                            flag2ndoperand=True
                            count+=1
            assembledline=fix_length_16(assembledline)                
            out.write("\""+assembledline+"\""+","+"\n")        
            if(indexedsrc):#here we write the X value of the source in the next line
                valueforindexedsrc=int (idx)
                valueforindexedsrc=str(bin(valueforindexedsrc))
                valueforindexedsrc=valueforindexedsrc[2:]
                valueforindexedsrc=fix_length_16(valueforindexedsrc)
                out.write("\""+valueforindexedsrc+"\""+",")
                indexedsrc=False
                #line=f.readline()
            if(variableflag1):
                value1=fix_length_16(value1)
                out.write("\""+value1+"\""+",")
            if(immediate):
                immediatevalue=str(bin(int(immediatevalue)))[2:]
                immediatevalue=fix_length_16(immediatevalue)
                out.write("\""+immediatevalue+"\""+",")
            if(indexeddist):#here we write the X value of the destination in the next line
                valueforindexeddist=int (idx2)
                valueforindexeddist=str(bin(valueforindexeddist))
                valueforindexeddist=valueforindexeddist[2:]
                valueforindexeddist=fix_length_16(valueforindexeddist)
                out.write("\""+valueforindexeddist+"\""+",") 
                indexeddist=False
                #line=f.readline()
            if(variableflag2):
               value2=fix_length_16 (str(value2))
               out.write("\""+value2+"\""+",")    
            elif(flag1stoperand==False):
                out.write("error in assembling code\n")
                line=f.readline()
                continue
        #here if flag2operand and the check  is false,that means it`s 1 operand OR BRANCH  
        elif(flag2operand==False ):# here i didn`t find the instruction in two operand dict,so i will search in 1 operand dict
            for x in one_operand_instructions.items():
                if(x[0]==instruction.upper()):
                    #out = open("assembled.txt", "w")
                    assembledline+=x[1]
                    flag1operand=True
                    break
            if(flag1operand):#now im sure it`s a 1 operand word,so i just search for the dist
                for z in Dist.items():
                    if(z[0]==operands.upper()):
#                        if(operands[0].upper()=='X'):
#                            valueforindexeddist="{0:b}".format(int(f.readline()))
#                            indexeddist=True
                        assembledline=assembledline+z[1]
                        flag2ndoperand=True
                        break
                if(flag2ndoperand==False):# #i didn`t find it in the registers,so maybe it`s a variable?
                    for v in variables.items():
                        if(v[0] in operands.upper()):
                            count+=1
                            if('@' in operands.upper()):
                                if('#' in operands.upper()):
                                   assembledline+=src['@(R7)+']
                                else:
                                    assembledline+=src['@X(R7)']
                            else:
                                assembledline+=src['X(R7)']
                            flag2ndoperand=True
                            variableflag2=True
                            value2=int(v[1])-count
                            value2=str(bin(value2 if int(value2)>0 else value2+(2**16)))
                            value2 = value2[2:]
                            break
                if(flag2ndoperand==False):
                    idx3=''
                    i=0
                    if('@'in operands):
                        i=1
                    while operands[i] != '(' and i < len(operands)-1:
                       idx3+=operands[i]
                       i+=1
                    operands=operands.replace(idx3, 'X')   
                    for y in src.items():
                        if(y[0]==operands.upper()): 
                            assembledline+=y[1]
                            indexeddist=True
                            flag2ndoperand=True
                            count+=1
                assembledline=fix_length_16(assembledline)            
                out.write("\""+assembledline+"\""+",")
                if(variableflag2):
                    value2=fix_length_16(value2)  
                    out.write("\""+value2+"\""+","+"\n")
                if(indexeddist):#here we write the X value of the destination in the next line
                    valueforindexeddist=int (idx3)
                    valueforindexeddist=str(bin(valueforindexeddist))
                    valueforindexeddist=valueforindexeddist[2:]
                    valueforindexeddist=fix_length_16(valueforindexeddist)
                    out.write("\""+valueforindexeddist+"\""+","+"\n") 
                    indexeddist=False
            if(flag1operand==False):#couldn`t find it in 1 operand,so it maybe a branch?
               for B in Branch.items(): 
                   if(B[0]==instruction.upper()):
                    #out = open("assembled.txt", "w")
                    assembledline+=B[1]
                    flagbranch=True
                    break
               if(flagbranch):
                   offset=int (lables[operands.upper()])-count
                   offset=str(bin(offset if int(offset)>0 else offset+(2**8)))
                   offset = offset[2:]
                   offset=fix_length_8(offset)
                   assembledline+=offset
                   out.write("\""+assembledline+"\""+","+"\n")
        #here check for flag1operand,if it`s false then we search for branch            
    else: 
         out.write("error in assembling code\n")
    line=f.readline()        
    #here if no space in the line, i guess it should be nop instruction
out.write("\""+"1001000000000000"+"\""+","+"\n")
#if(variablesvalues.empt)
if(len (variablesvalues)>0):
    out.write("\n")
for v in range( len (variablesvalues)):
    intv=int(list(variablesvalues.values())[v])
    binary= str(bin(intv if intv>=0 else intv+(2**16)))
   # binary=str(bin(int(list(variablesvalues.values())[v])))
    binary=binary[2:]
    binary=fix_length_16(binary)
    if(v==len(variablesvalues)-1):
         out.write("\""+binary+"\""+",")
    else:     
        out.write("\""+binary+"\""+",")  
f.close()
out.close()