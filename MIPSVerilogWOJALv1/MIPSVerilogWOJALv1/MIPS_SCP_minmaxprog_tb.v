// file: MIPS_SCP_minmaxprog_tb.v
// Testbench for minmaxsum_prog.s, which finds the minimum, maximum and sum
// of an array using only stock MIPS instructions.
//
// It runs 90 clock cycles rather than 10, because that program is a loop
// over five elements and needs roughly 65 cycles to finish. It also dumps
// data memory at the end, so both the input array and the three results
// can be read out of one file.

`timescale 1ns/1ns

module MIPS_SCP_minmaxprog_tb;

	reg clk;
	reg reset;

	MIPS_SCP uut (
		.clk(clk),
		.reset(reset)
	);

	always
		#50 clk=!clk;

	initial begin
		$dumpfile("MIPS_SCP_minmaxprog_tb.vcd");
		$dumpvars(0, MIPS_SCP_minmaxprog_tb);
		clk=0;
		reset=1;
		#1000;
		repeat(90) begin
			reset=0;
			#100;
		end
		#10;

		$display("");
		$display("--- input array, read from data memory ---");
		$display("arr[0]=%0d  arr[1]=%0d  arr[2]=%0d  arr[3]=%0d  arr[4]=%0d",
			$signed(uut.dmem.Dmem[0]), $signed(uut.dmem.Dmem[1]),
			$signed(uut.dmem.Dmem[2]), $signed(uut.dmem.Dmem[3]),
			$signed(uut.dmem.Dmem[4]));

		$display("");
		$display("--- results in registers ---");
		$display("min -> s0 = %0d", $signed(uut.datapathcomp.RF.register[16]));
		$display("max -> s1 = %0d", $signed(uut.datapathcomp.RF.register[17]));
		$display("sum -> s2 = %0d", $signed(uut.datapathcomp.RF.register[18]));
		$display("finished -> t7 = %0d", uut.datapathcomp.RF.register[15]);

		$display("");
		$display("--- results written back to data memory ---");
		$display("Dmem[8]  @byte 32 = %0d   (min)", $signed(uut.dmem.Dmem[8]));
		$display("Dmem[9]  @byte 36 = %0d   (max)", $signed(uut.dmem.Dmem[9]));
		$display("Dmem[10] @byte 40 = %0d   (sum)", $signed(uut.dmem.Dmem[10]));

		$writememh("minmaxprog_dmem_dump.txt", uut.dmem.Dmem);
		$finish;
	end
endmodule
