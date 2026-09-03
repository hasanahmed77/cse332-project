.text
main:
    addi $t0, $zero, 25      # t0 = 25
    addi $t1, $zero, 7       # t1 = 7
    addi $t2, $zero, -12     # t2 = -12, used to prove the compare is signed

    min  $s0, $t0, $t1       # s0 = min(25, 7)   = 7
    max  $s1, $t0, $t1       # s1 = max(25, 7)   = 25
    sum  $s2, $t0, $t1       # s2 = 25 + 7       = 32
    min  $s3, $t0, $t2       # s3 = min(25, -12) = -12  (unsigned would give 25)
    max  $s4, $t2, $t1       # s4 = max(-12, 7)  = 7    (unsigned would give -12)

    sw   $s0, 0($zero)       # Dmem[0] = 7
    sw   $s1, 4($zero)       # Dmem[1] = 25
    sw   $s2, 8($zero)       # Dmem[2] = 32
    sw   $s3, 12($zero)      # Dmem[3] = -12  (0xfffffff4)
    sw   $s4, 16($zero)      # Dmem[4] = 7

    addi $t7, $zero, 1       # marker that execution reached the end
