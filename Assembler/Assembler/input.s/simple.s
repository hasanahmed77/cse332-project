.data
newline: .asciiz "\n"

# --- Virtual Method Table ---
vtable_Printer:
    .word printArray     # vtable[0] = address of printArray

.text
#.globl main

main:
    # --- Simulate new Printer() ---
    # Normally would allocate object, but here only vtable is needed
    la $s0, vtable_Printer  # $s0 points to Printer's vtable
