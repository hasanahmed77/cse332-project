.text

main:
  addi $t0, $zero, -5      # t0 = -5
  addi $t1, $zero, 5       # t1 = 5
  mult $t0, $t1            # {HI,LO} = -5 * 5 = -25  (HI=0xFFFFFFFF, LO=0xFFFFFFE7)
  mflo $t2                 # t2 = LO = -25
  mfhi $t3                 # t3 = HI = -1
