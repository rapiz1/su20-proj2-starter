.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue

    # body
    add t0, x0, x0 # counter

loop_start:
    beq t0, a1, loop_end    # if i == n, break loop
    addi t1, x0, 4          # prepare immdiate 4
    mul t1, t1, t0          # get address offset
    add t1, t1, a0          # get element address
    lw t2, 0(t1)            # load the element
    bge t2, x0, pos
    add, t2, x0, x0
pos:
    sw t2, 0(t1)







loop_continue:
    addi t0, t0, 1
    jal x0, loop_start



loop_end:


    # Epilogue

    
	ret
