// file: MIPS_SCP_tb.v
// Testbench for MIPS_SCP

`timescale 1ns/1ns

module MIPS_SCP_tb;

	//Inputs
	reg clk;
    reg reset;

	//Outputs


	//Instantiation of Unit Under Test
	MIPS_SCP uut (
		.clk(clk),
		.reset(reset)
	);

    always
        #50 clk=!clk;
	initial begin
        $dumpfile("MIPS_SCP_tb.vcd");
        $dumpvars(0, MIPS_SCP_tb);
    	clk=0;
	reset=1;
	#1000; //cycle 1
        repeat(10) begin
	reset=0;
	#100;
        end
        #10;
        $display("PC=%0d  a0=%0d  v0=%0d  ra=%0d  t1=%0d  t2=%0d  t3=%0d  t7=%0d",
                  uut.PC,
                  uut.datapathcomp.RF.register[4],
                  uut.datapathcomp.RF.register[2],
                  uut.datapathcomp.RF.register[31],
                  uut.datapathcomp.RF.register[9],
                  uut.datapathcomp.RF.register[10],
                  uut.datapathcomp.RF.register[11],
                  uut.datapathcomp.RF.register[15]);
        $display("t0=%0d(%h)  t1=%0d(%h)  HI=%h  LO=%h  t2(mflo)=%h  t3(mfhi)=%h",
                  uut.datapathcomp.RF.register[8], uut.datapathcomp.RF.register[8],
                  uut.datapathcomp.RF.register[9], uut.datapathcomp.RF.register[9],
                  uut.datapathcomp.HI, uut.datapathcomp.LO,
                  uut.datapathcomp.RF.register[10], uut.datapathcomp.RF.register[11]);
        $finish;
  	end
endmodule