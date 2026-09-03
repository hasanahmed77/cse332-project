// file: ALU.v


`timescale 1ns/1ns

// ALUControl was widened from 4 bits to 5 when MIN, MAX and SUM were added.
// The original 4-bit field had only code 1111 left free, which is one code,
// and three new operations needed three. Every original operation keeps its
// old value with a leading 0 added, so nothing that worked before changes.

module alu32( input [31:0] a,
            input [31:0] b,
            input [4:0] f,
            input [4:0] shamt,
            output reg [31:0] y,
            output reg zero);

always @ (*) begin

    case (f)
        5'b00000: y = a + b;                             // ADD
        5'b00001: y = a - b;                             // SUB
        5'b00010: y = a & b;                             // AND
        5'b00011: y = a | b;                             // OR
        5'b00100: y = a ^ b;                             // XOR
        5'b00101: y = b << shamt;                        // SLL
        5'b00110: y = b >> shamt;                        // SRL
        5'b00111: y = $signed($signed(b) >>> shamt);     // SRA
        5'b01000: y = $signed(a) < $signed(b) ? 1 : 0;   // SLT
        5'b01001: y = a < b ? 1 : 0;                     // SLTU
        5'b01010: y = ~ (a | b);                         // NOR
        5'b01011: y = b << a;                            // SLLV
        5'b01100: y = b >> a;                            // SRLV
        5'b01101: y = $signed($signed(b) >>> a);         // SRAV
        5'b01110: y = {b[15:0], 16'b0};                  // LUI
        // new operations
        5'b10000: y = $signed(a) < $signed(b) ? a : b;   // MIN, signed
        5'b10001: y = $signed(a) > $signed(b) ? a : b;   // MAX, signed
        5'b10010: y = a + b;                             // SUM
        default:  y = 32'b0;
    endcase
         zero = (y==8'b0);
     end
endmodule
