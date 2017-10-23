# Towers of Hanoi
# Spring Quarter, 2014
# Due Thursday, June 5th, 17:00 (5:00 pm)
#
# Partner 1: Replace with your full name plus PID (A12345678)
# Partner 2: Replace with your full name plus PID (A12345678)
#
# Comment thoroughly and carefully! 
# Do not change anything about the program specifications!
# We should be able to swap out any of your functions for 
# someone elses, and have it work the same.
#
# Avoid any collaboration or help that might be considered 
# an integrity violation. Do your own work and you'll be
# perfectly okay. It's to your own benefit! Any integrity 
# violations will be assessed on BOTH PARTNERS regardless
# of the culpable partner.
#

.data

prompt_height:
	.asciiz "Please enter height of the tower from 1 to 1023 (or zero to quit):\n"
prompt_start_column:
	.asciiz "Please enter the initial column of the tower (1, 2 or 3):\n"
prompt_end_column:
	.asciiz "Please enter the final column of the tower (1, 2 or 3):\n"
move_disc_text:
	.asciiz "Move disc from "
str_to:
	.asciiz " to "
newline:
	.asciiz "\n"
state_str:
	.asciiz "Current tower heights are: "
comma:
	.asciiz ","
sepline:
	.asciiz "==============================\n\n"
goodbye:
	.asciiz "==========\nGoodbye!\n"

.globl get_end_column
.globl get_initial_height
.globl get_initial_state
.globl get_start_column
.globl main
.globl print_current_state
.globl print_move
.globl solve_hanoi

.text

main:	
	# Initializing main procedure:
	addiu $sp, $sp, -24	# Allocate space for stack-frame
	sw 	$ra, 4($sp) 	# Store return address
	sw 	$fp, 8($sp) 	# Store frame pointer
	sw	$s0, 12($sp)	# Store s0 (we will use this register for total height)
	sw	$s1, 16($sp)	# Store s1 (we will use this register for starting column)
	sw	$s2, 20($sp)	# Store s2 (we will use this register for end column)
	sw	$s3, 24($sp)	# Store s3 (we will use this register for state variable) 
	addiu $fp, $sp, 24 	# Update the current frame pointer

main_loop:
	# Get tower height from user:
	jal	get_initial_height
	# Should we quit?
	beq	$v0, $0, end_game	# If input "height" is zero, quit

	# Not quitting, go about rest of program
	move 	$s0, $v0	# Save initial height in s0

	# Get the "starting" column from user:
	jal	get_start_column
	move 	$s1, $v0	# Save the start column in s1

	# Get the "end" column from user:
	move    $a0, $s1	# the start column
	jal	get_end_column
	move 	$s2, $v0	# Save the end column in s2

	# Calculate the initial state representation:
	move	$a0, $s0	# initial tower height
	move	$a1, $s1	# "start" column number
	jal	get_initial_state
	# Now v0 should hold the 32-bit representation of the initial state
	move	$s3, $v0	# Save state variable in s3
	
	# Print the initial state of the towers:
	move	$a0, $v0	# Prepare the full-state argument

	jal	print_current_state 

	# Call the hanoi recursive solver:
	move	$a0, $s0	# Set the total height of the tower
	move	$a1, $s1	# "start" column
	move	$a2, $s2	# "end" column
	move	$a3, $s3	# state variable
	jal	solve_hanoi	# hanoi(height,start,end,helper)

	# Print line separator:
	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, sepline	#
	syscall			# Print line separator

	# Return back to loop:
	j	main_loop	# Jump to top of main_loop

end_game:
	# Say goodbye:
	li	$v0, 4	    	# syscall type 4 (print string)
	la	$a0, goodbye	#
	syscall			# Print goodbye

	# Finalizing main procedure:
	lw	$ra, 4($sp) 	# Load previous return address
	lw 	$fp, 8($sp) 	# Load previous frame pointer
	lw	$s0, 12($sp)	# Restore previous s0
	lw	$s1, 16($sp)	# Restore previous s1
	lw	$s2, 20($sp)	# Restore previous s2
	lw	$s3, 24($sp)	# Restore previous s3
	addiu $sp, $sp, 24	# Pop the frame from the stack
	jr	$ra		# Jump back to return address

# END OF main


get_initial_height:
# This procedure asks the user for the height of the tower,
# and prompts for user input.
#
# It returns the read user-input in v0.

	jr	$ra	        # Return to caller function

# END OF get_intial_height


get_start_column:
# This procedure asks the user for the initial column of the tower,
# and prompts for user input. Checks for valid column number.
#
# It returns the read user-input in v0.

	jr	$ra		# Return to caller function

#END OF get_start_column


get_end_column:
# This procedure asks the user for the final column of the tower,
# and prompts for user input. Checks for valid column number 
# and that the end column does not match the start column.
#
# a0: the "start" column (should be either 1, 2 or 3)
# v0: returns the end column.

	jr	$ra		# Return to caller function

#END OF get_end_column


get_initial_state:
# This procedure calculates the 32-bit representation of the initial state of the towers,
# assuming there is only one tower - the "start" tower (the other two have height 0).
# This procedure assumes input arguments are:
#
# a0: height of the initial tower
# a1: the "start" column - the position of the initial tower (either 1, 2 or 3)
# v0: returns the state variable

	# The height register already has the 10-bit representation of the tower heigh,
	# we just might need to shift it to the correct 10-bit position:
	# if start==1, shift by ?
	# if start==2, shift by ?
	# if start==3, shift by ?

	jr	$ra		# Return to caller function

#END OF get_initial_state


solve_hanoi:
# This procedure assumes input arguments are set:
# a0: height. 	Tower height to move
# a1: start.	column to move tower from
# a2: end.      column to move tower to
# a3: state.	The current state of the 3 towers
#
# Return value:
# v0: state.	The updated state of the 3 towers

	# Is this the base case of the recursion:
	li	$t0, 1		# Value of 1
	beq	$a0, $t0, base_case	# If height of tower is 1 - base case

	# It is not base case, handle general case (height>1):

base_case:

#END OF solve_hanoi 


print_move:
# This procedure assumes input arguments are set:
# a1: start.	column to move single disc from
# a2: end.	column to move single disc to
	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, move_disc_text	# Place move_disc_text string in argument 0
	syscall		       	# Print the string in move_disc_text

	li	$v0, 1		# syscall type 1 (print int)
	move	$a0, $a1    	# Place the "start" column in argument 0
	syscall			# Print the "start" column

	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, str_to	# Place str_to string in argument 0
	syscall			# Print the string in str_to

	li	$v0, 1		# syscall type 1 (print int)
	move	$a0, $a2    	# Place the "end" column in argument 0
	syscall			# Print the "end" column
    
	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, newline	# Place newline string in argument 0
	syscall			# Print the string in newline

	jr	$ra		# Return to caller function

#END OF print_move


print_current_state:
# This procedure assumes input arguments are set:
# a0: state.	Contains the current state of the three towers,
#			meaning the heights of the towers:
#			[junk (2 bits),tower 3,tower 2,tower 1].
#			for each tower 10 bits are dedicated
#			(and the remaining 2 bits are disregarded).
	# move a0 to t3, since a0 needed for syscalls
	move 	$t3, $a0
	
	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, state_str	# Place state_str in argument 0
	syscall		    	# Print the string in state_str

	# State of tower 1:
	move	$t0, $t3	# Copy the full state value
	li	$t1,	1023	# Mask for the 10 least significant bits
	and	$t0, $t0, $t1	# Keep only tower 1 state
	
	li	$v0, 1	    	# syscall type 1 (print int)
	move    $a0, $t0	# Place state of tower 1
	syscall	    		# Print height of tower 1
	li	$v0, 4	    	# syscall type 4 (print string)
	
	la	$a0, comma  	# Comma string
	syscall		    	# Print comma

	# State of tower 2:
	move	$t0, $t3	# Copy the full state value
	sll	$t1,	$t1, 10	# Mask for the "second" 10 bits
	and	$t0, $t0, $t1	# Keep only tower 2 state
	srl	$t0, $t0, 10	# shift 10 bits to right
	
	li	$v0, 1		# syscall type 1 (print int)
	move	$a0, $t0	# Place state of tower 2
	syscall		    	# Print height of tower 2
	
	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, comma  	# Comma string
	syscall			# Print comma

	# State of tower 3:
	move	$t0, $t3	# Copy the full state value
	sll	$t1,	$t1, 10	# Mask for the "third" 10 bits
	and	$t0, $t0, $t1	# Keep only tower 3 state
	srl	$t0, $t0, 20	# shift 20 bits to right

	li	$v0, 1	    	# syscall type 1 (print int)
	move	$a0, $t0	# Place state of tower 3
	syscall			# Print height of tower 3

	li	$v0, 4		# syscall type 4 (print string)
	la	$a0, newline	# Newline string
	syscall	    		# Print newline

	jr	$ra		# Return to caller function

#END OF print_current_state
