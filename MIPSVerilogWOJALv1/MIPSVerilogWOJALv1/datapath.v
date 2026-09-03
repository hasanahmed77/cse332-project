// file: Datapath.v


`include "adder.v"
`include "alu32.v"
`include "flopr_param.v"
`include "hilo.v"
`include "mux2.v"
`include "mux4.v"
`include "regfile32.v"
`include "signext.v"
`include "sl2.v"

`timescale 1ns/1ns

module Datapath(input clk,
                input reset,
                input RegDst,
                input RegWrite,
                input ALUSrc,
                input Jump,
                input JAL,
                input JR,
                input MultOp,
                input MFHiLo,
                input MemtoReg,
                input PCSrc,
                input [4:0] ALUControl,
                input [31:0] ReadData,
                input [31:0] Instr,
                output [31:0] PC,
                output ZeroFlag,
                output [31:0] datatwo,
                output [31:0] ALUResult);


wire [31:0] PCNext, PCNextPreJR, PCplus4, PCbeforeBranch, PCBranch;
wire [31:0] extendedimm, extendedimmafter, MUXresult, MUXresultPreMF, dataone, aluop2;
wire [4:0] writereg;
wire [31:0] HI, LO, hiloval;
wire signed [63:0] product;

// PC
flopr_param #(32) PCregister(clk,reset, PC,PCNext);
  adder #(32) pcadd4(PC, 32'd4 ,PCplus4);
slt2 shifteradd2(extendedimm,extendedimmafter);
adder #(32) pcaddsigned(extendedimmafter,PCplus4,PCbeforeBranch);
mux2 #(32) branchmux(PCplus4 , PCbeforeBranch, PCSrc, PCBranch);
mux2 #(32) jumpmux(PCBranch, {PCplus4[31:28],Instr[25:0],2'b00 }, Jump,PCNextPreJR);
mux2 #(32) jrmux(PCNextPreJR, dataone, JR, PCNext);       // JR: PC <= $ra (rs)

// Register File

registerfile32 RF(clk,RegWrite, reset, Instr[25:21], Instr[20:16], writereg, MUXresult, dataone,datatwo);
mux4 #(5) writeopmux(Instr[20:16], Instr[15:11], 5'd31, 5'd31, {JAL,RegDst}, writereg);   // JAL forces $ra(31)
mux4 #(32) resultmux(ALUResult, ReadData, PCplus4, PCplus4, {JAL,MemtoReg}, MUXresultPreMF);   // JAL writes back PC+4
mux2 #(32) mfhilomux(MUXresultPreMF, hiloval, MFHiLo, MUXresult);   // MFHI/MFLO writes back HI or LO instead

// ALU

alu32 alucomp(dataone, aluop2, ALUControl, Instr[10:6], ALUResult, ZeroFlag);
signext immextention(Instr[15:0],extendedimm);
mux2 #(32) aluop2sel(datatwo,extendedimm, ALUSrc, aluop2);

// MULT / MFHI / MFLO
assign product = $signed(dataone) * $signed(aluop2);   // 64-bit signed product of rs, rt
hilo hiloregs(clk, reset, MultOp, product[63:32], product[31:0], HI, LO);
mux2 #(32) hiloselmux(HI, LO, Instr[1], hiloval);       // Func[1]: 0=mfhi(HI), 1=mflo(LO)


endmodule