# Simple MULT Example
# Multiplies two numbers and stores the result

    .data
num1:   .word 6         # First number
num2:   .word 7         # Second number
result: .word 0         # Space to store result

    .text

main:
#    # Load numbers into registers
    li   $t0, 6      # $t0 = 6
    li   $t1, 7      # $t1 = 7

    # Multiply $t0 and $t1
    mult $t0, $t1       # HI/LO = $t0 * $t1

    # Move result from LO to $t2
    mflo $t2            # $t2 = result of multiplication

    # Store result into memory
    la $t0, result
    sw   $t2, 0($t0)
    move $a0, $t2
    li $v0, 1
    syscall




