# ModelSim simulation script for MIPS_SCP_tb.
#
# Run from this directory (MIPSVerilogWOJALv1/MIPSVerilogWOJALv1), so that
# rom.v and ram.v can find memfile.txt / datafile.txt with a relative path:
#
#   vsim -do sim.do
#
# or from inside the ModelSim GUI, after changing directory here:
#   do sim.do

vlib work
vmap work work

# MIPS_SCP_tb.v does not include MIPS_SCP.v itself, so both need to be
# named explicitly. Everything else (datapath.v, control.v, hilo.v,
# alu32.v, rom.v, ram.v, and the small building-block modules) is pulled
# in automatically through the `include chain starting at MIPS_SCP.v.
vlog MIPS_SCP.v MIPS_SCP_tb.v

vsim -voptargs=+acc work.MIPS_SCP_tb

add wave -radix hexadecimal /MIPS_SCP_tb/uut/PC
add wave -radix hexadecimal /MIPS_SCP_tb/uut/Instr
add wave -radix binary      /MIPS_SCP_tb/uut/RegDst
add wave -radix binary      /MIPS_SCP_tb/uut/RegWrite
add wave -radix binary      /MIPS_SCP_tb/uut/Jump
add wave -radix binary      /MIPS_SCP_tb/uut/JAL
add wave -radix binary      /MIPS_SCP_tb/uut/JR
add wave -radix binary      /MIPS_SCP_tb/uut/MultOp
add wave -radix binary      /MIPS_SCP_tb/uut/MFHiLo
add wave -radix hexadecimal /MIPS_SCP_tb/uut/datapathcomp/HI
add wave -radix hexadecimal /MIPS_SCP_tb/uut/datapathcomp/LO
add wave -radix hexadecimal /MIPS_SCP_tb/uut/ALUResult

run -all

wave zoom full
