Mips Assembler
==============

An assembler for a subset of the MIPS instruction set.

# How to use
The assembler will take a file written in assembly language as input on the command line and will produce an output file containing the MIPS machine code. Each line in the input assembly file contains either a mnemonic, a section header (such as .data or .text) or a label (jump or branch target.

The assembler supports the following 46 instruction set:

- "lw"
- "lb"
- "sw"
- "sb" 
- "add"
- "addu"
- "sub"
- "subu"
- "slt"
- "sltu"
- "and"
- "or"
- "xor"
- "nor"
- "sll"
- "srl",
- "sra"
- "mult"
- "multu"
- "div"
- "divu"
- "addi"
- "addiu"
- "andi"
- "ori"
- "xori"
- "lui"
- "slti"
- "beq"
- "bne"
- "blez"
- "bgtz"
- "bltz"
- "bgez"
- "j"
- "jal"
- "jalr"
- "jr"
- "mfhi"
- "mflo" 
- "syscall",
- "la"
- "move"
- "li"
- "nop"
- "sltiu"

## Modified Assembler
The following modifications were made to this MIPS assembler. This assembler now supports the generation of mahcine code for the data section of the compiler generated assembly.

To build the assembler, you'll have to run the following commands from within the MipsAssembler directory:
``` bash
mkdir -p build
cd build
cmake ..
make
cd ..
```

This will create the MipsAssembler executable. To generate the machine code for a sample assembly program, run the following command from within the MipsAssembler directory:
```bash
./build/MipsAssembler input.s/factorial.s output/factorial.out logs/factorial.log
```

`factorial.out` contains the machine code for only the text section with the addresses. `factorial.out.no_address.data.bin` and `factorial.out.no_address.text.bin` contains the machine code for the data section and the text section respectively without the addresses.

