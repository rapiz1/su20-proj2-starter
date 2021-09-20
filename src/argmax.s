.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue

    add t0, x0, x0 # counter
    add t3, x0, x0 # max index
    lw t4, 0(a0) # max value

loop_start:
    beq t0, a1, loop_end
    addi t1, x0, 4
    mul t1, t1, t0
    add t1, t1, a0 
    lw t2, 0(t1)
    bge t4, t2, loop_continue
    add t4, x0, t2
    add t3, x0, t0

loop_continue:
    addi t0, t0, 1
    jal x0, loop_start

loop_end:
    addi a0, t3, 0

    # Epilogue


    ret
