.text

main:
  addi $a0, $zero, 5      # a0 = 5
  addi $t7, $zero, 0      # t7 = 0, should be overwritten by the time we get to end
  jal  func                # $ra = addr(add t1...), jump to func
  add  $t1, $v0, $zero     # t1 = v0 (result returned by func)
  sll  $t2, $a0, 2         # t2 = a0 << 2 = 20
  srl  $t3, $t2, 1         # t3 = t2 >> 1 = 10
  j    end

func:
  addi $v0, $a0, 100       # v0 = a0 + 100 = 105
  jr   $ra                 # return to caller

end:
  addi $t7, $zero, 1       # t7 = 1 (marker that we reached the end correctly)
