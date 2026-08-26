.data
heap_address: .word 890, 354, 46, 2834, 4587, 12
text_: .asciiz "Hello World?!\n"

.text
    addi $v0, $zero, 1     # $v0 = 1
    addi $a0, $zero, 1     # $a0 = 1
    syscall

    addi $a0, $zero, 12
    addi $v0, $zero, 9
    syscall

    add $a0, $zero, $v0
    addi $v0, $zero, 1
    syscall


    addi $a0, $zero, 12
    addi $v0, $zero, 9
    syscall

    add $a0, $zero, $v0
    addi $v0, $zero, 1
    syscall


    addi $a1, $zero, 3485
    sw $a1, 0($a0)

    lw $a0, 0($a0)
    li $v0, 1
    syscall

    # Store some string

    li $a0, 16          # Request 16 bytes for the string
    li $v0, 9
    syscall             # $v0 now holds base heap address

    # Save base address
    move $t0, $v0       # $t0 = heap base address

    # Store "Hell" -> 0x48656C6C
    li $t1, 1214606444
    sw $t1, 0($t0)

    # Store "O Wo" -> 0x4F20576F
    li $t1, 1327519599
    sw $t1, 4($t0)

    # Store "rlD!" -> 0x726C4421
    li $t1, 1919697953
    sw $t1, 8($t0)

    # Store null terminator -> 0x00000000
    li $t1, 0
    sw $t1, 12($t0)

    # Optional: now print it using syscall 4
    move $a0, $t0       # $a0 = address of string
    li $v0, 4
    syscall             # Print the string


    la $a0, text_
    li $v0, 4
    syscall

