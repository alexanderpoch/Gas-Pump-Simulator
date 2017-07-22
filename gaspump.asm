.data 	#the data section creates outputs that are to be used in the main part of the program.It also provides prompts for user input
prompt1: .asciiz "Enter a valid gas code: "			
prompt2: .asciiz "Enter the amount of gallons: "
type:	.asciiz "Gas Type: "
reg:	.asciiz " Regular\n"
pre:	.asciiz	" Premium\n"
ult:	.asciiz	" Ultra\n"
endl:	.asciiz "\n"
.text
main:
	li	$v0, 4
	la	$a0, prompt1
	syscall		#these three lines call the user to enter a gas code
	
	li	$v0, 5	
	syscall # user inputs gas code
	move $v1,$v0 # I move the gas code temporarily to v1 so I can use a0 for more outputs
	
	blt	$v1, 1, end 
	bgt	$v1, 3, end
	# IF the gas code is greater than 3 or less than 1, the program will end
	li	$v0, 4 
	la	$a0, type
	syscall		# the gas type output is shown
	
	beq	$v1, 1, r
	beq	$v1, 2, p
	beq	$v1, 3, u
	# These branches will send each gas code to its respective section so it can be outputted properly
r:	
	li	$v0, 4
	la	$a0, reg
	syscall
	j procedure1
	#this outputs regular gas type and sends the program to the procedure1 area 
p:
	li	$v0, 4
	la	$a0, pre
	syscall
	j procedure1
	#this outputs premium gas type and sends the program to the procedure1 area
u:
	li	$v0, 4
	la	$a0, ult
	syscall
	j procedure1
	#this outputs ultra gas type and sends the program to the procedure1 area
procedure1: 
	move $a0, $v1 # I move the gas code from v0 to a0 to help the register cross over in the function
	jal codetocost #the program jumps to the function

p2:
	li	$v0, 4 
	la	$a0, prompt2
	syscall	#prompts the user to enter the amount of gallons
	
	li	$v0, 5
	syscall		#user inputs the amount of gallons
	move $a2, $v0 	#amount of gallons is moved to the a2 register
	
	jal	totalcost # program jumps to totalcost procedure
	
	li	$v0, 4	
	la	$a0, endl
	syscall	#creates an empty line
	beq 	$zero, $zero, main #this will cause the program to loop
	
end:	
	li	$v0,10
	syscall	 #this causes the program to end
	
#*****************************
# FIRST PROCEDURE: GAS CODE TO PRICE PER GALLON
#*****************************
.data
cost1: .asciiz "Price per gallon: 559\n"
cost2: .asciiz "Price per gallon: 587\n"
cost3: .asciiz "Price per gallon: 625\n"
.text
codetocost:
	move $v1, $a0	# I move the gas code to v1 because I use $a0 for outputting
	beq 	$v1, 1, costr
	beq	$v1, 2, costp
	beq	$v1, 3, costu
	#These branches send the respective gas codes to their cost per gallon
costr:
	li	$v0, 4
	la	$a0, cost1	
	syscall	#this outputs the cost per gallon
	li 	$a1, 559 #sets cost per gallon to register so it can be used later
	move $a0,$v1 # the gas code is moved back to a0, just in case we need it there again
	jr	$ra # jumps back to where we left off in the main part of the code
costp:
	li	$v0, 4 #this outputs the cost per gallon
	la	$a0, cost2
	syscall
	li 	$a1, 587 #sets cost per gallon to register so it can be used later
	move $a0,$v1 # the gas code is moved back to a0, just in case we need it there again
	jr	$ra # jumps back to where we left off in the main part of the code
costu:
	li	$v0, 4 #this outputs the cost per gallon
	la	$a0, cost3
	syscall
	li 	$a1, 625 #sets cost per gallon to register so it can be used later
	move $a0,$v1	# the gas code is moved back to a0, just in case we need it there again 
	jr 	$ra # jumps back to where we left off in the main part of the code
	
#*****************************
# SECOND PROCEDURE: TOTAL COST
#*****************************
.data
total: .asciiz "The total cost is: "
.text
totalcost:
	li 	$v0, 4
	la	$a0, total
	syscall #outputs the total part in data section
	
	mult $a1,$a2 #takes the cost per gallon and the amount of gallons and multiplies them
	mflo $a0 #the answer is stored in here
	
	li 	$v0,1
	syscall #the amount of money is outputted here
	
	jr	$ra #jumps back to where we left off in the main part of the program
	