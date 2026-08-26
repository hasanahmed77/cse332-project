.data
newline: .asciiz "\n"
str0: .asciiz "null pointer\n"
str1: .asciiz "array index out of bounds\n"
ARRAY: .word 1, 2, 3, 4
buffer: .space 16  # Reserve 100 bytes of uninitialized memory


vmt_Fac: # should start at address 0x0000002c or 44 in decimal
.word Fac.ComputeFac
.word Fac.meth2


.text

start: # should start at address 56
  jal Main
  li $v0, 10
  syscall


heapAlloc:
  li $v0, 9   # syscall: sbrk
  syscall
  jr $ra

print:
  li $v0, 1   # syscall: print integer
  syscall
  la $a0, newline
  li $v0, 4   # syscall: print string
  syscall
  jr $ra

error:
  li $v0, 4   # syscall: print string
  syscall
  li $v0, 10  # syscall: exit
  syscall


Main:
  sw $fp, -8($sp)
  move $30, $29
  addiu $29, $29, -76
  sw $ra, -4($fp)
  li $a0, 4
  jal heapAlloc
  move $t0, $v0
  la $t9, vmt_Fac
  sw $t9, 0($t0)
  bne $t0, $zero, null1
  la $a0, str0
  j error
null1:
  lw $t1, 0($t0)
  lw $t1, 0($t1)
  sw $s0, -12($30)
  sw $s1, -16($30)
  sw $s2, -20($30)
  sw $s3, -24($30)
  sw $s4, -28($30)
  sw $s5, -32($30)
  sw $s6, -36($30)
  sw $t0, -40($30)
  sw $t1, -44($30)
  sw $t2, -48($30)
  sw $t3, -52($30)
  sw $t4, -56($30)
  sw $t5, -60($30)
  sw $t6, -64($30)
  sw $t7, -68($30)
  sw $t8, -72($30)
  sw $v1, -76($30)
  move $a0, $t0
  li $a1, 10
  jalr $t1
  lw $s0, -12($30)
  lw $s1, -16($30)
  lw $s2, -20($30)
  lw $s3, -24($30)
  lw $s4, -28($30)
  lw $s5, -32($30)
  lw $s6, -36($30)
  lw $t0, -40($30)
  lw $t1, -44($30)
  lw $t2, -48($30)
  lw $t3, -52($30)
  lw $t4, -56($30)
  lw $t5, -60($30)
  lw $t6, -64($30)
  lw $t7, -68($30)
  lw $t8, -72($30)
  lw $v1, -76($30)
  move $t2, $v0
  move $a0, $t2
  jal print
  lw $ra, -4($30)
  lw $30, -8($30)
  addiu $29, $29, 76
  jr $ra

Fac.ComputeFac:
  sw $30, -8($29)
  move $30, $29
  addiu $29, $29, -84
  sw $ra, -4($30)
  sw $s0, -12($30)
  sw $s1, -16($30)
  move $t5, $a0
  move $s0, $a1
  slti $t0, $s0, 1
  beq $t0, $zero, if1_else
  li $s1, 1
  j if1_end
if1_else:
  addiu $t1, $s0, -1
  lw $t2, 0($t5)
  lw $t2, 0($t2)
  sw $s0, -20($30)
  sw $s1, -24($30)
  sw $s2, -28($30)
  sw $s3, -32($30)
  sw $s4, -36($30)
  sw $s5, -40($30)
  sw $s6, -44($30)
  sw $t0, -48($30)
  sw $t1, -52($30)
  sw $t2, -56($30)
  sw $t3, -60($30)
  sw $t4, -64($30)
  sw $t5, -68($30)
  sw $t6, -72($30)
  sw $t7, -76($30)
  sw $t8, -80($30)
  sw $v1, -84($30)
  move $a0, $t5
  move $a1, $t1
  jalr $t2
  lw $s0, -20($30)
  lw $s1, -24($30)
  lw $s2, -28($30)
  lw $s3, -32($30)
  lw $s4, -36($30)
  lw $s5, -40($30)
  lw $s6, -44($30)
  lw $t0, -48($30)
  lw $t1, -52($30)
  lw $t2, -56($30)
  lw $t3, -60($30)
  lw $t4, -64($30)
  lw $t5, -68($30)
  lw $t6, -72($30)
  lw $t7, -76($30)
  lw $t8, -80($30)
  lw $v1, -84($30)
  move $t3, $v0

  move $t4, $t3
  mult $t4, $s0
  
  move $s1, $t4
if1_end:
  move $v0, $s1
  lw $s0, -12($30)
  lw $s1, -16($30)
  lw $ra, -4($30)
  lw $30, -8($30)
  addiu $29, $29, 84
  jr $ra

Fac.meth2:
  jr $ra

AllocArray:
  sw $30, -8($29)
  move $30, $29
  addiu $29, $29, -76
  sw $ra, -4($30)
  move $t1, $a0

  addiu $t0, $zero, 4
  mult $t0, $t1
  
  addiu $t0, $t0, 4
  move $a0, $t0
  jal heapAlloc
  move $t2, $v0
  sw $t1, 0($t2)
  move $v0, $t2
  lw $ra, -4($30)
  lw $30, -8($30)
  addiu $29, $29, 76
  jr $ra



