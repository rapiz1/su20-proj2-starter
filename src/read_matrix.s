.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw ra, 20(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2

    mv a1 s0
    li a2 0
    jal ra fopen
    mv s4 a0        # f = fopen(s0, RDONLY)

    # handle error 
    li t0, 1
    bge a0, t0, fopen_good
    li a1 50
    jal ra exit2
fopen_good:
    # mv a1 s4
    # jal ra print_int

    mv a1 s4
    mv a2 s1
    li a3 4
    jal ra fread    # fread(f, s1, 4)

    # handle error
    li t0 4
    bne a0 t0 fread_bad

    mv a1 s4
    mv a2 s2
    li a3 4
    jal ra fread    # fread(f, s2, 4)    


    # handle error
    li t0 4
    bne a0 t0 fread_bad


    lw t1, 0(s1)
    lw t2, 0(s2)
    mul a0, t1, t2
    li t0 4
    mul a0, a0, t0
    jal ra malloc
    mv s3 a0       # buf = malloc(s1*s2)

    # print row, col
    # lw a1, 0(s1)
    # jal ra print_int
    # lw a1, 0(s2)
    # jal ra print_int

    mv a1 s4
    mv a2 s3
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul a3, t1, t2
    li t0 4
    mul a3, a3, t0
    jal ra fread # fread(f, buf, (*s1)*(*s2)*4)

    # handle error
    lw t1, 0(s1)
    lw t2, 0(s2)
    mul t3, t1, t2
    li t0 4
    mul t3, t3, t0
    bne a0 t3 fread_bad

    mv a1 s4
    jal fclose # fclose(fd)

    mv a0 s3

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw ra, 20(sp)
	addi sp, sp, 24

    ret

fread_bad:
    li a1 51
    jal ra exit2
fclose_bad:
    li a1 52
    jal ra exit2

bad:
    li a1 123
    jal ra exit2
