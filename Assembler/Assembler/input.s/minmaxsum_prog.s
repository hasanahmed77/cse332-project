.data
# Five values to scan. These load into data memory words 0 to 4,
# i.e. byte addresses 0, 4, 8, 12, 16.
arr:  .word 17, 42, 8, 23, 4

.text
# Computes the minimum, maximum and sum of the array above using only
# stock MIPS instructions. No custom instructions are used anywhere, so
# this runs on the unmodified starter datapath.
main:
    addi $t0, $zero, 0       # t0 = byte offset of current element
    addi $t1, $zero, 20      # t1 = end offset, 5 words times 4 bytes
    lw   $s0, 0($zero)       # s0 = running minimum, seeded with arr[0]
    lw   $s1, 0($zero)       # s1 = running maximum, seeded with arr[0]
    addi $s2, $zero, 0       # s2 = running sum

loop:
    beq  $t0, $t1, done      # stop once every element has been visited
    lw   $t2, 0($t0)         # t2 = arr[i]
    add  $s2, $s2, $t2       # sum = sum + arr[i]

    slt  $t3, $t2, $s0       # is arr[i] less than the running minimum
    beq  $t3, $zero, skipmin
    add  $s0, $t2, $zero     # yes, so take it as the new minimum
skipmin:

    slt  $t3, $s1, $t2       # is the running maximum less than arr[i]
    beq  $t3, $zero, skipmax
    add  $s1, $t2, $zero     # yes, so take it as the new maximum
skipmax:

    addi $t0, $t0, 4         # advance to the next word
    j    loop

done:
    sw   $s0, 32($zero)      # min goes to data memory word 8
    sw   $s1, 36($zero)      # max goes to data memory word 9
    sw   $s2, 40($zero)      # sum goes to data memory word 10
    addi $t7, $zero, 1       # marker that the program ran to completion
