		
		
		##################################################################################
		#										 #
		#			ENCS4370: COMPUTER ARCHITECTURE         	         #
		#			       Course Project 1 :				 #
		#			     Matrix down sampling                                #
		#										 #
		#				                        			 #
		#	Student Name: Najla Salameen	        		sec:2 	         #			      
		#	Student Name: Raneem Alqadi 				sec:2 	         #			      
		#                                                                                #
		#										 #
		##################################################################################	


.data
#matrix: .float 1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8
matrix: .float 2,5,10,11,7,4,7,12,4,1,20,7,7,2,4,8
fin: .asciiz "file.txt" #change the backslash in the oppsite direction 
store: .space 1024 # Declare an array
after:.space  1024
string:.space 11
result:.space 11
fileName: .asciiz "C:/Users/pc2/Desktop/RaneemFolders/output.txt"
#____________________________________________________Floating Numbers________________________________________________________________
float1: .float 0.0  
float2: .float 4.0  
float: .float 2.0  
float3: .float 0.5
float4: .float 1.5  
float5:.float 10
float6:.float 100
#____________________________________________________________________________________________________________________________________

#_______________________________________________________Messages_____________________________________________________________________

invalid1: .asciiz " Invalid Level, Please try again by re-running the program again"
invalidc: .asciiz " Invalid Choice, Please try again by re-running the program again" 
newline1: .asciiz "The size of the matrix is a square of type = " 
msg: .asciiz "Please choose (1) for Mean or (2) for Median " 
msg2: .asciiz "Please choose the level (1,2,3,....) "
maxlevel: .asciiz "Maximum Level can be generated is: " 
valid1: .asciiz " Valid Level "
meantxt: .asciiz "Mean: "
M: .asciiz "Median: "
newline: .asciiz "\n" 
space:.asciiz " "
#____________________________________________________________________________________________________________________________________


      
#__________________________________________________________Start Programming_________________________________________________________

.text
main:
   
#____________________________________________________Prepare the file for reading____________________________________________________
#Registers used:
               # $v0: 
                     #contain "13" for openning the file
                     #contain "14" for read from file
                     #contain "16" for closing the file
                     #It contain the file descriptor
                     
               # $a1:
                     #contain "0" which is a flags to read mode
                     #contain "store" which is the address of buffer from which to write
                     
               # $a0:
                     #contain "fin" which is contain the input file name 
                     #contain "store" which is the address of buffer from which to write
                     #contain the file descriptor (we move the file descriptor from $t0 to $a0 to saving it from changing
                     #                              ,we make this in reading and closing the file)
               
               # $t0: store the file descriptor
               
               # $a2: containt the hardcoded buffer length which is "1024"
               
#____________________________________________________________________________________________________________________________________
               	 
  li $v0, 13      
  la $a0, fin    
  li $a1, 0       
  syscall          

  move $t0,$v0 	   
     

  li $v0, 14       
  la $a1, store   	 
  li $a2, 1024   
  move $a0, $t0   		   
  syscall        


  li $v0, 16       
  move $a0, $t0    
  syscall          
  
#____________________________________________________Start the Reading Operation_____________________________________________________	
#Registers used:
               # $s0: contain the address of store 
               # $t0: represent the index of the array, initially we set it = 0
               # $a3: represent the counter, to count the number of rows, initially we set it = 0
               
#loopr1:
#Registers used:
               # $s1: represent the number before space, initially we set it = 0
               # $s6: represent the dot [.] counter, initially we set it = 0 
               
               
#loopr2:
#Registers used:
	       # $s2: 
	       #    1.contain the byte we read from the file
	       #    2. we subtract from it 48 to convert it to integer number
	       #    3. we add s2 after convert it to integer to s1 to use it in the next time util space comes
	       
	       # $s1: 
	       #    1.contain the final number so everytime until space will mutliplied by 10 
	       #    2.store the full number until space
	       
	       # $f2: store the number in it 
	       # $a3: contain number of rows 
	     
	       
#Branches:
	 #check: 
	 #     1.In this branch we compare with the space (32 is the ascii code of the space) to store the prevoious number 
	 #       Example: 12 3 when space comes the value 12 will store
	 
	 #     2.Convert stored number in $s1 to float  
	 #     3.We check if the number is float we go to floatNum branch to handel it
	 #     4.If the number is signle or multi digit we store it here 
	 
	 #ret1:In this branch we compare with new line (10 & 13 is the ascii code of the new line)
	 
	 #ret2:In this branch we start count the number from dot until space (46 is the ascii code of the dot)
	 
	 #exitloop: In this branch we check if the number is invalid
	 
	 #inc: If the number is float, count the numbers after dot
	 
	 #count: Count number of newlines to get the number of rows 
	 
	 #retFloat: Store float number in the array
	 
	 #floatNum: Prepare float number by passing the number in a loop each time divide by 10 (the number stored in $f2)
#____________________________________________________________________________________________________________________________________

  la $s0,store  		
  addi $t0,$0,0 		
  li $a3,0               
  li $s6,0


loopr1:
  li $s1,0                
  li $s6,0  
             
loopr2:
  lb $s2,0($s0)
  addi $s0,$s0,1
  beq  $s2,0,exitLoop
  beq  $s2,32,check       
  beq  $s2,10,ret1        
  beq  $s2,13,ret1
  beq  $s2,46,ret2        
  blt  $s2,48,exitLoop    
  bgt  $s2,57,exitLoop
  mul  $s1,$s1,10         
  subi $s2,$s2,48         
  add $s1,$s1,$s2         
  bgt $s6,0,inc         


j loopr2

check :

  sw $s1,-88($fp) 
  lwc1 $f1,-88($fp)
  cvt.s.w $f2,$f1	

  bgt   $s6,0,floatNum    
  mov.s $f12,$f2
  li $v0,2
  syscall
  li $v0, 4
  la $a0, newline
  syscall

  swc1  $f2,after($t0)	#store the value
  addi $t0,$t0,4		


  j loopr1

ret1 :
  beq $s2,10,count

  j loopr1


count:
  addi $a3,$a3,1
  j loopr1
#start counting after finding dot
ret2 :
  addi $s6,$s6,1
  j loopr2


retFloat:
  mov.s $f12,$f2
  li $v0,2
  syscall
  li $v0, 4
  la $a0, newline
  syscall
  swc1   $f2,after($t0)	#store the value
  addi $t0,$t0,4		

  j loopr1



inc:
  addi $s6,$s6,1
  j loopr2


floatNum:

  l.s $f10,float5

prepareFloat:
  beq $s6,1,retFloat
  div.s $f2,$f2,$f10
  subi $s6,$s6,1
  j prepareFloat

exitLoop:
  li $v0, 4
  la $a0, newline1
  syscall
	
  move $a0,$a3   
  li $v0,1
  syscall 
        
  li $v0, 4
  la $a0, newline 
  syscall
	 
#_____________________________________________________Strat calculation_________________________________________________________________
#Registers used:
                # $s1: contain the number of rows,cols 
                # $s4: contain data size
                # $t2: contain base address of the matrix
                # $s5: store "2" as integer in this reg to use it in division
                # $f0: store "0.0" in this reg to use it as sum=0
                # $f5: store "4.0" in this reg which is number of elements in the square 
                # $f11: store "2.0" as float in this reg for division
                # $f14: store "0.5" in this reg to use it in the window for odd/even levels
                # $f15: store "1.5" in this reg to use it in the window for odd/even levels
                # $s6: contain the initial value of the level 
                # $t8: contain the number of rows and columns in each level
#____________________________________________________________________________________________________________________________________ 
                
   add  $s1,$0,$a3            
   li  $s4,4             
   la  $t2,after       
   li  $s5,2              
   l.s $f0,float1         
   l.s $f5,float2         
   l.s $f11,float
   l.s $f14,float3        
   l.s $f15,float4       
   li  $s6,0              #L=0
   add $t8,$0,$a3                
    
#____________________________________Max level can be generated (depends on the number of rows)______________________________________
#Registers used:
	       # $t1: store "2" for division (to divide num of rows by 2)
	       # $t3: store "0" to make count=0 --- and so the count in t3 will represent the maximum level
	       # $t7: store the level (integer read from user)
	       # $t4: store the number of rows in this reg insted of $s1 to make operation on it
	       # $a3:store the reminder,if the reminder is zero we increment the counter by 1, else we stop and get the maximum level
	       # $v0: 
	            #contain "4" to print string
	            #contain "5" to read an integer from user
	            #contain "1" to print an integer
	            #contain "2" to print float number 
	           
#____________________________________________________________________________________________________________________________________

   li $t1,2      
   li $t3,0      
   
   li $v0, 4
   la $a0, msg2
   syscall
	
   li $v0, 4
   la $a0, newline
   syscall
	
   li $v0,5
   syscall
	
   move $t7,$v0 
   move $t4,$s1 
   
   beq $t7,$0,invalid
   
#________________________________________________start working on maximum level_______________________________________________________

looplevel:
   		
	div $t4,$t1
	mflo $t4
	mfhi $a3
	beq $a3,0,incr
	bne $a3,0,stop
	
	
incr:

	addi $t3,$t3,1 	#count = count +1
	j looplevel

stop:

	li $v0, 4
	la $a0, maxlevel
	syscall
	
	li $v0,1
	addi $t3,$t3,1
	addi $a0 , $t3 ,0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	
	 

bgt $t7,$t3,invalid
ble $t7,$t3,valid



	
invalid:
	li $v0, 4
	la $a0, invalid1
	syscall
	li $v0, 4
        la $a0, newline
        syscall
	j exit2
exit2:   

	li $v0 , 10	
  	syscall
  	
valid:
	li $v0, 4
	la $a0, valid1
	syscall
	li $v0, 4
   	la $a0, newline
   	syscall
  
#___________________________________________Ask user about Mean(1) or Median(2)______________________________________________________ 
#Registers used:
               # $t6: store the choice(integer) from user 
#____________________________________________________________________________________________________________________________________

      li $v0, 4
      la $a0, msg
      syscall
		
      li $v0, 4
      la $a0, newline
      syscall
		
      li $v0,5
      syscall
	
      move $t6,$v0
   
  #subi $t7,$t7,1   # level form user + 1
   
 

   
#_____________________________________________________Working on level_______________________________________________________________
#Registers used:
	       # $s2: store the integer "0" to represent i=0, i represent the rows in the matrix
	       # $s3: store the integer "0" to represent j=0, j represent the columns in the matrix
	       # $t4: contain the value in reg $t2 to save the value in $t2 from changing
	       # $f12: contain the reg which has the float number we want to prints 
	
	          
#loop: Represent the work on levels
	       
#loop1: Represent the loop on "i", we compare if i>[value of $t8], we break,
        #so we compare the current row with total rows

#loop2: 1. Represent the loop on "j", we compare if j>[value of $t8], we break,
           #we use this loop in order to get the elements in the square(4 elements)
        
#	2. We check if the user choice (mean or median) is valid or not

#	3. To get the address of the matrix we use the following formula[1]:
#          Address = base address + (row_index * col_size + col_index) * data_size

#	4. We check if the user choice mean or median:
#          if Mean we branch to mean1
#          if Median we branch to loopm
#____________________________________________________________________________________________________________________________________
 
 
subi $t7,$t7,1   # level form user + 1
move $s7,$t8   
loop:
   
   beq $s6,$t7,end     
   li  $s2, 0             
   move $t4,$t2           
   
   

loop1:
   beq  $s2, $t8, end1    
   li   $s3, 0            


        

loop2:

   beq  $s3, $t8, end2   



   bgt $t6,2,invalidC
   blt $t6,1,invalidC
   
#________________________________________________To get the index of matrix__________________________________________________________

   mul  $t0,$s2,$s1       #(row_index*col_size
   add  $t0,$t0,$s3       #                   +col_index)
   mul  $t1,$t0,$s4       #                              *data_Size
   add  $t1,$t1,$t2       #                                         +base_address
   
#____________________________________________________________________________________________________________________________________
   
#To get the first element in square, which is a[i][j]  and we store it in $f1

   lwc1 $f1,($t1)
     
   li     $v0, 2
   mov.s $f12,$f1
   syscall

#To get the second element in square,we add datasize to $t1 for getting a[i][j+1],and we store it in $f2
    
   add $t1,$t1,$s4         
   lwc1   $f2,($t1)        
     
   li     $v0, 2
   mov.s $f12,$f2
   syscall
    

#To get the third element in square, which is a[i+1][j] we apply formula[1] on i+1, and we store it in $f3 

   add  $t5,$s2,1        # i=i+1
   mul  $t0,$t5,$s1      #(row_index*col_size)
   add  $t0,$t0,$s3      #                   +col_index
   mul  $t1,$t0,$s4      #                             *data_Size
   add  $t1,$t1,$t2      #                                       +base_address
   
   lwc1   $f3,($t1)        
        
   li     $v0, 2
   mov.s $f12,$f3
   syscall
   
#To get the fourth element in square, we add datasize to $t1 for getting a[i+1][j+1], and we store it in $f4

   add $t1,$t1,$s4        
   lwc1   $f4,($t1)       
        
   li     $v0, 2
   mov.s $f12,$f4
   syscall
    
   
   addi $s3, $s3, 2       # j+2
     

   li $v0, 4
   la $a0, newline  
   syscall



beq $t6,2,loopm
beq $t6,1,mean1 
  
  
#____________________________________________________Preparing for Median____________________________________________________________

#loopm: Represent the sorting operation
#median: Represent the median formula:
#        median($f1,$f2,$f3,$f4) =  ($f2 + $f3)/2    , since the number of elements is even

#Registers used in median:
			 # $f8: contain the summation of the middle two numbers  
			 # $f13: contain the division of summation by 2

#____________________________________________________________________________________________________________________________________
loopm:
 
	c.lt.s $f1,$f2
	bc1f cmpeq2       
	bc1t cmp2         

	
swap1:
	mov.s $f9,$f1   
	mov.s $f1,$f2
	mov.s $f2,$f9
 	
 	j loopm
 	
cmpeq2: 
	c.eq.s $f1,$f2
	
	bc1f swap1
	bc1t cmp2
 	
cmp2:
	c.lt.s $f2,$f3
	bc1f cmpeq3
	bc1t cmp3
 	
swap2:
	mov.s $f6,$f0
	mov.s $f6,$f2
	mov.s $f2,$f3
	mov.s $f3,$f6
	 	
 	j loopm
 	
cmpeq3: 
	c.eq.s $f2,$f3
	
	bc1f swap2
	bc1t cmp3
 		
cmp3:
 
 	c.lt.s $f3,$f4
	bc1f cmpeq4         
	bc1t median
 	
 	
 	 
swap3:

	mov.s $f7,$f3
	mov.s $f3,$f4
	mov.s $f4,$f7
	
	j loopm 
	
	
cmpeq4: 
	c.eq.s $f3,$f4
	
	bc1f swap3
	bc1t median
	
	
median:

	add.s $f8,$f2,$f3     
	div.s $f13,$f8,$f11    
		
	li $v0, 4
	la $a0, M
	syscall
	
	mov.s  $f12, $f13
	li $v0, 2
	syscall
	
	
	li $v0, 4
	la $a0, newline
	syscall	
	
	 
#store the median in certain index 

       s.s    $f13, 0($t4)
      
       li $v0, 4
       la $a0, newline
       syscall
	    
       addi $t4,$t4,4
        
       j  loop2
      

#____________________________________________________Preparing for Mean______________________________________________________________
#In mean1: we check if the level number is even or odd by dividing the current level by 2 and check the reminder
#Registers used in mean1:
			# $a2: contain the integer "2" for division 
			# $s6: represent the current level
			# $a1: contain the answer of the division
			# $t9: contain the reminder of the division
			
# Even branch: 
#              1. we multiply the square of 4 elements [f1,f2,f3,f4] by the elements of the even matrix
#                                                                                                       1.5   0.5         
#                                                                                                       0.5   1.5

#              2. we add the 4 elements [f1,f2,f3,f4] after multiplication, and store the summation in $f0
#              3.divide the summation by 4, and store it in $f0

#Registers used:
		# $f14: store the floating number 0.5   
		# $f15: store the floating number 1.5
		# $f0: store the mean result
#Note: After we store the mean in certain index we make the sum=0, which is $f0=0

# Odd branch: 
#              1. we multiply the square of 4 elements [f1,f2,f3,f4] by the elements of the odd  matrix
#                                                                                                       0.5   1.5         
#                                                                                                       1.5   0.5

#              2. we add the 4 elements [f1,f2,f3,f4] after multiplication, and store the summation in $f0
#              3.divide the summation by 4, and store it in $f0

#Registers used are the same as in Even branch

#____________________________________________________________________________________________________________________________________
mean1:

	li $a2,2     
 
 	div $s6,$a2   
	mflo $a1       
	mfhi $t9      
	
			
	beq $t9,0,even
	bne $t9,0,odd
 	

even:

	mul.s $f1,$f1,$f15
	mul.s $f2,$f2,$f14
	mul.s $f3,$f3,$f14
	mul.s $f4,$f4,$f15
	
	add.s $f0,$f0,$f1
	add.s $f0,$f0,$f2
	add.s $f0,$f0,$f3
	add.s $f0,$f0,$f4
	
	div.s $f0,$f0,$f5
	
 
          
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, meantxt
	syscall
	
	li     $v0, 2        
        mov.s $f12,$f0
        syscall
        
        
#store the mean in certain index 
       s.s    $f0, 0($t4)
      
       li $v0, 4
       la $a0, newline
       syscall
	
       l.s $f0,float1         
        
    
       addi $t4,$t4,4
        
       j  loop2
	  
	  
odd:

	mul.s $f1,$f1,$f14         
	mul.s $f2,$f2,$f15
	mul.s $f3,$f3,$f15
	mul.s $f4,$f4,$f14
	
	
	
	add.s $f0,$f0,$f1
	add.s $f0,$f0,$f2
	add.s $f0,$f0,$f3
	add.s $f0,$f0,$f4
	
	div.s $f0,$f0,$f5
	

          
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, meantxt
	syscall
	
	li     $v0, 2         
        mov.s $f12,$f0
        syscall
        

#store the mean in certain index 
       s.s   $f0, 0($t4) 
      
       li $v0, 4
       la $a0, newline
       syscall
	
       l.s $f0,float1         
        
       addi $t4,$t4,4
        
       j  loop2
	

    
end2:

# Increment i by 2 (i+2)
     addi $s2, $s2, 2     
    
#transfer from row to another row 
    
    
     
     move $t3,$t8
     div  $t3,$s5
     mflo $t3
     sub $t3,$s7,$t3
     mul  $t3,$t3,4
     add $t4,$t4,$t3
  
  

     
     j    loop1
     
     
end1:

     addi $s6,$s6,1


     li $v0, 4
     la $a0, newline
     syscall
	
	
     div $t8,$s5
     mflo $t8
	

     li $v0, 4
     la $a0, newline
     syscall
	
     move $a0,$t8
     li $v0,1
     syscall
           
     li $v0, 4
     la $a0, newline
     syscall
		
j loop 


invalidC:
	li $v0, 4
	la $a0, invalidc
	syscall
end:


#________________________________________Convert from Float to String and write on the file__________________________________________

#In this part we will move on the loop to take the float numbers and convert them to string then print them into file
#Registers used:
               # $t8: contain the size of the output array from certain level
               # $s1: contain the column size
               # $t0: store the integer "0" to represent i=0 , i represent the rows index in the output matrix
               # $t1: store the integer "0" to represent j=0 , j represent the columns index in the output matrix
               # $t3: contain the base address of the array "after"
               # $s4: contain the data size of float which is "4"
               # $f1: contain float number = 100, to start the conversion from float to string by multiplying the float number by 100
               # $t4: contain the address of the output matrix which we calculated using this formula
                      #Address = base address + (row_index * col_size + col_index) * data_size
               # $f3: contain a float number from the output matrix
               # $f0: contain the result from converting the float number to integer number
               # $a0: contain a copy of $f0 reg value to $a0
               # $t5: store the integer "10", because we want move on the string in backward way,
                      #so we want divide by 10 and check the reminder
                      
               # $t5: conyain the length (strlen) of the string  
               # $t7: contain the size of the string, which is 11
               # $s5: this reg is a counter to count the number of characters
               # $s7: contain the address of the result string
               # $s6: contain the value of reg $s5, in order to save the value from changing
               
#Branches:
               #endOut: In this branch, we close the file in order to update the file
               #endJ: In this branch, we increment i and write the data(new line) on the file
               #addDot:In this branch, we add the dot character (which 46 in ascii code)to the number and store it in "result" string
               #exitstr:In this branch, we write the result on the file 

#loops:

               #L2: In this branch, we convert from integer to character, by adding "48" to the number
               #loopstr: In this loop, we check the following:
               						     # 1. check when length of string = 2 , to put the dot character
               						     # 2. check when we reach the null character 
               						     
               						     
               						     
#Write On File:
	      # $v0: contain the write-file syscall code which is "15"
	      # $a0: contain the file descriptor
	      # $a1: contain the string that will be written
	      # $a2: contain the length of the string to be written

#Close File:
            # $v0: contain the close-file syscall code which is "16"   
            # $a0: contain the file descriptor
               						    
#____________________________________________________________________________________________________________________________________

        move $s3,$s1

    	
    	#open file 
    	li $v0,13           	
    	la $a0,fileName     	
    	li $a1,1           	
    	syscall
    	move $s1,$v0        	
    	
    	
    	li $t0,0             #i=0
    	la $t3,after        
        li $s4,4           
        l.s $f1,float6     
        
    	loopOutI:
    	beq $t0,$t8,endOut
    	li $t1,0             #j=0
    	loopOutJ:
    	beq $t1,$t8,endJ
    	
    	mul  $t2,$t0,$s3       #(row_index*col_size
        add  $t2,$t2,$t1       #                   +col_index)
        mul  $t4,$t2,$s4       #                              *data_Size
        add  $t4,$t4,$t3       #                                         +base_address
   
    	 lwc1   $f3,($t4)
    	     
    	
      # remove the dot by multiply the number with 100 
    	mul.s $f3,$f3,$f1
    	cvt.w.s $f0, $f3         
    	mfc1 $a0, $f0 
    	
    	#convert integer to string 
    	move $a1,$a0
        la $v1,string
        li $t5,10   
        addi $v1,$v1,11
        sb $zero,($v1)
        li $s5,0     
        
     L2:
        addi $s5,$s5,1
        div $a1,$t5
        mflo $a1
        mfhi $t6    
        addi $t6,$t6,48
        subi $v1,$v1,1
        sb   $t6,0($v1)
        bnez $a1,L2
        
        
     # strlen of string 
        move $t5,$s5 
        
     # prepare float string (result string)
        
        li $t7,11   #t5
        sub $t7,$t7,$s5
        la $a1, string
        add $a1,$a1,$t7
        move $s6,$s5
        la $s7,result
       
        
           loopstr:
  
       lb   $t9,0($a1)    
       beq  $s6,2,addDot  
       beq   $s6,-1,exitStr
       move $a0,$s6
       li $v0,1
       syscall 
       
        li $v0, 4
        la $a0, newline
        syscall
         
       beqz $t9, exitStr   # check for the null character
       addi $a1, $a1, 1    # increment the string pointer
       
       move $a0,$t9
       li $v0,1
       syscall
       li $v0, 4
       la $a0, newline
       syscall
    
       sb $t9,0($s7)
       addi $s7,$s7,1
       subi $s6,$s6,1
       
       j loopstr
       
        addDot:
        li $t9,46
        li $v0, 1
        move $a0, $t9
        syscall
        sb   $t9,0($s7)
        addi $s7,$s7,1
        subi $s6,$s6,1
        j loopstr
      
       
       
        exitStr:
        
        #Write the file
    	li $v0,15		
    	move $a0,$s1		
    	la $a1,result		
    	addi $a2,$s5,1		
    	syscall
        
        li $v0,15		
    	move $a0,$s1		
    	la $a1,space		
    	la $a2,1		
    	syscall
        
    	addi $t1,$t1,1
    	j loopOutJ
    	endJ:
    	addi $t0,$t0,1
    	 li $v0,15		
    	move $a0,$s1		
    	la $a1,newline		
    	la $a2,1		
    	syscall
    	j loopOutI
    	
    	
    	endOut:
    	
    	
    	#MUST CLOSE FILE IN ORDER TO UPDATE THE FILE
    	li $v0,16         		
    	move $a0,$s1      		
    	syscall