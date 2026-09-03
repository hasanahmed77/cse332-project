.text
main:
    addi $t0, $zero, 8      # $t0 = address 8 (word-aligned)
    addi $t1, $zero, 99     # $t1 = 99, value to store
    sw   $t1, 0($t0)        # Dmem[8/4] = Dmem[2] = 99
    lw   $t2, 0($t0)        # $t2 = Dmem[2], read it back = 99
    addi $t7, $zero, 1      # reached the end
