.data
.align 0
_newline: .asciiz "\n"
_str0: .asciiz "null pointer\n"
_str1: .asciiz "array index out of bounds\n"

vmt_Fac:
  .word Fac.ComputeFac
  .word Fac.meth2

.text

.global _start

_start:

  jal Main
  li $v0, 10
  syscall

Main:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp, 80
  sw $ra, -4($fp)
  sw $s0, -12($fp)
  li $a0, 4
  jal _heapAlloc
  move $t0, $v0
  la $t9, vmt_Fac
  sw $t9, 0($t0)
  bnez $t0, null1
  la $a0, _str0
  j _error
null1:
  move $s0, $t0
  lw $t1, 0($s0)
  lw $t1, 4($t1)
  sw $s0, -16($fp)
  sw $s1, -20($fp)
  sw $s2, -24($fp)
  sw $s3, -28($fp)
  sw $s4, -32($fp)
  sw $s5, -36($fp)
  sw $s6, -40($fp)
  sw $t0, -44($fp)
  sw $t1, -48($fp)
  sw $t2, -52($fp)
  sw $t3, -56($fp)
  sw $t4, -60($fp)
  sw $t5, -64($fp)
  sw $t6, -68($fp)
  sw $t7, -72($fp)
  sw $t8, -76($fp)
  sw $v1, -80($fp)
  move $a0, $s0
  jalr $t1
  lw $s0, -16($fp)
  lw $s1, -20($fp)
  lw $s2, -24($fp)
  lw $s3, -28($fp)
  lw $s4, -32($fp)
  lw $s5, -36($fp)
  lw $s6, -40($fp)
  lw $t0, -44($fp)
  lw $t1, -48($fp)
  lw $t2, -52($fp)
  lw $t3, -56($fp)
  lw $t4, -60($fp)
  lw $t5, -64($fp)
  lw $t6, -68($fp)
  lw $t7, -72($fp)
  lw $t8, -76($fp)
  lw $v1, -80($fp)
  move $t2, $v0
  move $a0, $t2
  jal _print
  lw $t3, 0($s0)
  lw $t3, 0($t3)
  sw $s0, -16($fp)
  sw $s1, -20($fp)
  sw $s2, -24($fp)
  sw $s3, -28($fp)
  sw $s4, -32($fp)
  sw $s5, -36($fp)
  sw $s6, -40($fp)
  sw $t0, -44($fp)
  sw $t1, -48($fp)
  sw $t2, -52($fp)
  sw $t3, -56($fp)
  sw $t4, -60($fp)
  sw $t5, -64($fp)
  sw $t6, -68($fp)
  sw $t7, -72($fp)
  sw $t8, -76($fp)
  sw $v1, -80($fp)
  move $a0, $s0
  li $a1, 10
  jalr $t3
  lw $s0, -16($fp)
  lw $s1, -20($fp)
  lw $s2, -24($fp)
  lw $s3, -28($fp)
  lw $s4, -32($fp)
  lw $s5, -36($fp)
  lw $s6, -40($fp)
  lw $t0, -44($fp)
  lw $t1, -48($fp)
  lw $t2, -52($fp)
  lw $t3, -56($fp)
  lw $t4, -60($fp)
  lw $t5, -64($fp)
  lw $t6, -68($fp)
  lw $t7, -72($fp)
  lw $t8, -76($fp)
  lw $v1, -80($fp)
  move $t4, $v0
  move $a0, $t4
  jal _print
  lw $t5, 0($s0)
  lw $t5, 0($t5)
  sw $s0, -16($fp)
  sw $s1, -20($fp)
  sw $s2, -24($fp)
  sw $s3, -28($fp)
  sw $s4, -32($fp)
  sw $s5, -36($fp)
  sw $s6, -40($fp)
  sw $t0, -44($fp)
  sw $t1, -48($fp)
  sw $t2, -52($fp)
  sw $t3, -56($fp)
  sw $t4, -60($fp)
  sw $t5, -64($fp)
  sw $t6, -68($fp)
  sw $t7, -72($fp)
  sw $t8, -76($fp)
  sw $v1, -80($fp)
  move $a0, $s0
  li $a1, 11
  jalr $t5
  lw $s0, -16($fp)
  lw $s1, -20($fp)
  lw $s2, -24($fp)
  lw $s3, -28($fp)
  lw $s4, -32($fp)
  lw $s5, -36($fp)
  lw $s6, -40($fp)
  lw $t0, -44($fp)
  lw $t1, -48($fp)
  lw $t2, -52($fp)
  lw $t3, -56($fp)
  lw $t4, -60($fp)
  lw $t5, -64($fp)
  lw $t6, -68($fp)
  lw $t7, -72($fp)
  lw $t8, -76($fp)
  lw $v1, -80($fp)
  move $t6, $v0
  move $a0, $t6
  jal _print
  lw $s0, -12($fp)
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 80
  jr $ra

Fac.ComputeFac:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp, 84
  sw $ra, -4($fp)
  sw $s1, -16($fp)
  sw $s0, -12($fp)
  move $t5, $a0
  move $s0, $a1
  slti $t0, $s0, 1
  beqz $t0, if1_else
  li $s1, 1
  j if1_end
if1_else:
  subu $t1, $s0, 1
  lw $t2, 0($t5)
  lw $t2, 0($t2)
  sw $s0, -20($fp)
  sw $s1, -24($fp)
  sw $s2, -28($fp)
  sw $s3, -32($fp)
  sw $s4, -36($fp)
  sw $s5, -40($fp)
  sw $s6, -44($fp)
  sw $t0, -48($fp)
  sw $t1, -52($fp)
  sw $t2, -56($fp)
  sw $t3, -60($fp)
  sw $t4, -64($fp)
  sw $t5, -68($fp)
  sw $t6, -72($fp)
  sw $t7, -76($fp)
  sw $t8, -80($fp)
  sw $v1, -84($fp)
  move $a0, $t5
  move $a1, $t1
  jalr $t2
  lw $s0, -20($fp)
  lw $s1, -24($fp)
  lw $s2, -28($fp)
  lw $s3, -32($fp)
  lw $s4, -36($fp)
  lw $s5, -40($fp)
  lw $s6, -44($fp)
  lw $t0, -48($fp)
  lw $t1, -52($fp)
  lw $t2, -56($fp)
  lw $t3, -60($fp)
  lw $t4, -64($fp)
  lw $t5, -68($fp)
  lw $t6, -72($fp)
  lw $t7, -76($fp)
  lw $t8, -80($fp)
  lw $v1, -84($fp)
  move $t3, $v0
  mul $t4, $s0, $t3
  move $s1, $t4
if1_end:
  move $v0, $s1
  lw $s1, -16($fp)
  lw $s0, -12($fp)
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 84
  jr $ra

Fac.meth2:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp, 76
  sw $ra, -4($fp)
  li $v0, 456
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 76
  jr $ra

AllocArray:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp, 76
  sw $ra, -4($fp)
  move $t1, $a0
  mul $t0, $t1, 4
  addu $t0, $t0, 4
  move $a0, $t0
  jal _heapAlloc
  move $t2, $v0
  sw $t1, 0($t2)
  move $v0, $t2
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 76
  jr $ra

_print:
  li $v0, 1   # syscall: print integer
  syscall
  la $a0, _newline
  li $v0, 4   # syscall: print string
  syscall
  jr $ra

_error:
  li $v0, 4   # syscall: print string
  syscall
  li $v0, 10  # syscall: exit
  syscall

_heapAlloc:
  li $v0, 9   # syscall: sbrk
  syscall
  jr $ra

