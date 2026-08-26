.data
hjkhk:      .space 1
array:      .word 55, 10, 15, 20, 205     # Input array
length:     .word 5                    # Number of elements
result:     .space 5                  # 5 words = 20 bytes

.text
main:
    la $t0, array        # Load base address of input array
    la $t1, result       # Load base address of result array
    la $t2, length       # Load address of 'length' into $t2
    lw $t2, 0($t2)       # Load the value at 'length' into $t2

    li $t3, 0            # i = 0

loop:
    beq $t3, $t2, end
    sll $t4, $t3, 2
    add $t5, $t0, $t4    # address of array[i]
    lw $t6, 0($t5)       # t6 = array[i]
    addi $t6, $t6, 1     # t6 += 1
    add $t7, $t1, $t4    # address of result[i]
    sw $t6, 0($t7)       # result[i] = t6
    addi $t3, $t3, 1
    j loop
end:

