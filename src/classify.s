.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    li t0 5
    bne a0, t0, bad_arg

    addi sp, sp, -60
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2

	# =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    lw a0, 4(s1)
    addi a1, sp, 36
    addi a2, sp, 40
    jal read_matrix
    mv s3 a0


    # Load pretrained m1
    lw a0, 8(s1)
    addi a1, sp, 44
    addi a2, sp, 48
    jal read_matrix
    mv s4 a0
    

    # Load input matrix
    lw a0, 12(s1)
    addi a1, sp, 52
    addi a2, sp, 56
    jal read_matrix
    mv s5 a0
    

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    lw t0, 36(sp)
    lw t1, 56(sp)
    mul a0, t0, t1
    li t0, 4
    mul a0, a0, t0
    jal malloc
    mv s7 a0 # make d1 as s7
    
    mv a0 s3
    lw a1, 36(sp)
    lw a2, 40(sp)
    mv a3 s5
    lw a4, 52(sp)
    lw a5, 56(sp)
    mv a6 s7
    jal matmul # d1 = matmul(m0, input)

    mv a0 s7
    lw t0, 36(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal relu # d1 = relu(d1)


    lw t0, 44(sp)
    lw t1, 56(sp)
    mul a0, t0, t1
    li t0, 4
    mul a0, a0, t0
    jal malloc
    mv s8 a0 # make d2 as s8
    jal print_all_len

    mv a0 s4
    lw a1, 44(sp)
    lw a2, 48(sp)
    mv a3 s7
    lw a4, 36(sp)
    lw a5, 56(sp)
    mv a6 s8
    jal matmul # d2 = matmul(m1, d1)
    jal print_all_len

    mv a0 s7
    jal free # free(d1)

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1 s8
    lw a2, 44(sp)
    lw a3, 56(sp)
    jal write_matrix # write_matrix(d2)

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s8
    lw t0, 44(sp)
    lw t1, 56(sp)
    mul a1, t0, t1
    jal argmax
    mv s6 a0 # save ans as s6

    mv a0 s8
    jal free # free(d2)

    # Print classification
    li t0 1
    bne s2, t0, prepare_return
    mv a1 s6
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

prepare_return:
    mv a0 s6 # return ans

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 60

    ret

bad_arg:
    mv a1 a0
    jal print_int
    li a1 49
    jal exit2

bad:
    li a1 123
    jal exit2

print_all_len:
    ret
    mv s11, ra

    lw a1, 36(sp)
    jal print_int
    li a1 ' '
    jal print_char

    lw a1, 40(sp)
    jal print_int
    li a1 '\n'
    jal print_char

    lw a1, 44(sp)
    jal print_int
    li a1 ' '
    jal print_char

    lw a1, 48(sp)
    jal print_int
    li a1 '\n'
    jal print_char

    lw a1, 52(sp)
    jal print_int
    li a1 ' '
    jal print_char

    lw a1, 56(sp)
    jal print_int
    li a1 '\n'
    jal print_char
    li a1 '\n'
    jal print_char

    # print m1
    mv a0 s4
    lw a1, 44(sp)
    lw a2, 48(sp)
    jal print_int_array

    # print d1
    mv a0 s7
    lw a1, 52(sp)
    lw a2, 56(sp)
    jal print_int_array

    li a1 '\n'
    jal print_char

    # print d2
    mv a0 s8
    lw a1, 44(sp)
    lw a2, 56(sp)
    jal print_int_array

    li a1 '\n'
    jal print_char

    mv ra, s11
    ret
