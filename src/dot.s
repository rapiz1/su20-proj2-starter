.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:

    # Prologue
    add t0, x0, x0 # sum
    add t1, x0, x0 # counter

loop_start:
    beq t1, a2, loop_end

    addi t2, x0, 4
    mul t2, t2, t1
    mul t2, t2, a3
    add t2, t2, a0
    lw t4, 0(t2)

    addi t2, x0, 4
    mul t2, t2, t1
    mul t2, t2, a4
    add t2, t2, a1
    lw t5, 0(t2)

    mul t4, t4, t5

    add t0, t0, t4

    addi t1, t1, 1
    jal x0, loop_start
loop_end:
    add a0, t0, x0

    # Epilogue

    
    ret
