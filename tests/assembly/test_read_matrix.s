.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    li a0 8
    jal malloc
    mv s0 a0            # s0 = malloc(8)

    la a0 file_path
    mv a1 s0
    addi a2, s0, 4
    jal read_matrix     # s1 = read_matrix(file_path, s0, s0+4)
    mv s1 a0

    # Print out elements of matrix
    lw a1, 0(s0)
    lw a2, 4(s0)
    jal print_int_array

    # Terminate the program
    jal exit
