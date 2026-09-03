// file: MIPS_SCP_minmax_tb.v
// Testbench for the MIN / MAX / SUM demo.
//
// Two differences from MIPS_SCP_tb.v:
//   1. It runs 20 clock cycles instead of 10, because minmaxsum_test.s is
//      14 instructions long and the original testbench would stop partway.
//   2. It dumps the final contents of data memory to minmax_dmem_dump.txt,
//      so the stored MIN / MAX / SUM results can be inspected directly.

`timescale 1ns/1ns

module MIPS_SCP_minmax_tb;

	reg clk;
	reg reset;

	MIPS_SCP uut (
		.clk(clk),
		.reset(reset)
	);

	always
		#50 clk=!clk;

	initial begin
		$dumpfile("MIPS_SCP_minmax_tb.vcd");
		$dumpvars(0, MIPS_SCP_minmax_tb);
		clk=0;
		reset=1;
		#1000;
		repeat(20) begin
			reset=0;
			#100;
		end
		#10;

		$display("");
		$display("--- registers ---");
		$display("t0=%0d  t1=%0d  t2=%0d",
			$signed(uut.datapathcomp.RF.register[8]),
			$signed(uut.datapathcomp.RF.register[9]),
			$signed(uut.datapathcomp.RF.register[10]));
		$display("min(25,7)   -> s0 = %0d", $signed(uut.datapathcomp.RF.register[16]));
		$display("max(25,7)   -> s1 = %0d", $signed(uut.datapathcomp.RF.register[17]));
		$display("sum(25,7)   -> s2 = %0d", $signed(uut.datapathcomp.RF.register[18]));
		$display("min(25,-12) -> s3 = %0d", $signed(uut.datapathcomp.RF.register[19]));
		$display("max(-12,7)  -> s4 = %0d", $signed(uut.datapathcomp.RF.register[20]));
		$display("reached end -> t7 = %0d", uut.datapathcomp.RF.register[15]);

		$display("");
		$display("--- data memory ---");
		$display("Dmem[0] @byte 0  = %0d (%h)", $signed(uut.dmem.Dmem[0]), uut.dmem.Dmem[0]);
		$display("Dmem[1] @byte 4  = %0d (%h)", $signed(uut.dmem.Dmem[1]), uut.dmem.Dmem[1]);
		$display("Dmem[2] @byte 8  = %0d (%h)", $signed(uut.dmem.Dmem[2]), uut.dmem.Dmem[2]);
		$display("Dmem[3] @byte 12 = %0d (%h)", $signed(uut.dmem.Dmem[3]), uut.dmem.Dmem[3]);
		$display("Dmem[4] @byte 16 = %0d (%h)", $signed(uut.dmem.Dmem[4]), uut.dmem.Dmem[4]);

		$writememh("minmax_dmem_dump.txt", uut.dmem.Dmem);
		$finish;
	end
endmodule
