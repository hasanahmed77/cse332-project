.data
array:     .word 42, 1       # array[0] = 42, array[1] = 0

.text
main:
    la $t0, array
#    li $t0, 0
    lw  $t1, 0($t0)
    addi $t1, $t1, 1 
    sw  $t1, 1($t0)          # Store result into array[1]

