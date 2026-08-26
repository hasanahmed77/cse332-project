// file: hilo.v
// HI/LO register pair, written by MULT; read by MFHI/MFLO.
// Same clocked-register style as flopr_param.v.

`timescale 1ns/1ns

module hilo(input clk,
            input reset,
            input we,
            input [31:0] hi_in,
            input [31:0] lo_in,
            output reg [31:0] hi,
            output reg [31:0] lo);

initial begin
    hi = 0;
    lo = 0;
end

always @(posedge clk) begin
    if (reset) begin
        hi <= 0;
        lo <= 0;
    end else if (we) begin
        hi <= hi_in;
        lo <= lo_in;
    end
end

endmodule
