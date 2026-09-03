#!/bin/bash
# Converts an assembler .out file (address + space-grouped 32-bit binary per line)
# into a plain hex-per-line memfile for $readmemh in rom.v.
# Usage: ./to_memfile.sh output/jal_jr_test.out > ../../MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt

awk '{
    bin = "";
    for (i = 2; i <= NF; i++) bin = bin $i;
    dec = 0;
    for (i = 1; i <= length(bin); i++) {
        dec = dec * 2 + substr(bin, i, 1);
    }
    printf "%08x\n", dec;
}' "$1"
