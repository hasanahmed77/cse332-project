// file: MIPS_SCP_dmem_tb.v
// Same as MIPS_SCP_tb.v, but dumps the final contents of data memory
// (uut.dmem.Dmem) to dmem_dump.txt after running, for the sw/lw demo.

`timescale 1ns/1ns

module MIPS_SCP_dmem_tb;

	reg clk;
    reg reset;

	MIPS_SCP uut (
		.clk(clk),
		.reset(reset)
	);

    always
        #50 clk=!clk;
	initial begin
        $dumpfile("MIPS_SCP_dmem_tb.vcd");
        $dumpvars(0, MIPS_SCP_dmem_tb);
    	clk=0;
	reset=1;
	#1000; //cycle 1
        repeat(10) begin
	reset=0;
	#100;
        end
        #10;
        $display("t0(addr)=%0d  t1(stored)=%0d  t2(loaded back)=%0d  t7=%0d",
                  uut.datapathcomp.RF.register[8],
                  uut.datapathcomp.RF.register[9],
                  uut.datapathcomp.RF.register[10],
                  uut.datapathcomp.RF.register[15]);
        $display("Dmem[2] (word at byte address 8) = %0d (%h)",
                  uut.dmem.Dmem[2], uut.dmem.Dmem[2]);
        $writememh("dmem_dump.txt", uut.dmem.Dmem);
        $finish;
  	end
endmodule
