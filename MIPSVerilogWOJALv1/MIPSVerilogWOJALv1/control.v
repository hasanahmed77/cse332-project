// Code your design here
// file: control.v


`timescale 1ns/1ns

module Controlunit(input [5:0] Opcode, 
               input [5:0] Func,
               input Zero,
               output reg MemtoReg,
               output reg  MemWrite,
               output reg  ALUSrc,
               output reg  RegDst,
               output reg  RegWrite,
               output reg  Jump,
               output reg  JAL,
               output reg  JR,
               output reg  MultOp,
               output reg  MFHiLo,
               output PCSrc,
               output reg  [3:0] ALUControl
               );

reg [7:0] temp;
reg Branch,BNE;

always @(*) begin

    // defaults so JAL/JR/MultOp/MFHiLo never infer a latch on opcodes/funcs that don't use them
    JAL <= 1'b0;
    JR  <= 1'b0;
    MultOp <= 1'b0;
    MFHiLo <= 1'b0;

    case (Opcode)
        6'b000000: begin                          // R-type
                    temp <= 8'b11000000;

                    case (Func)
                    6'b100000: ALUControl <= 4'b0000;    // ADD
                    6'b100001: ALUControl <= 4'b0000;    // ADDU
                    6'b100010: ALUControl <= 4'b0001;    // SUB
                    6'b100011: ALUControl <= 4'b0001;    // SUBU
                    6'b100100: ALUControl <= 4'b0010;    // AND
                    6'b100101: ALUControl <= 4'b0011;    // OR
                    6'b100110: ALUControl <= 4'b0100;    // XOR
                    6'b100111: ALUControl <= 4'b1010;    // NOR
                    6'b101010: ALUControl <= 4'b1000;    // SLT
                    6'b101011: ALUControl <= 4'b1001;    // SLTU
                    6'b000000: ALUControl <= 4'b0101;    // SLL
                    6'b000010: ALUControl <= 4'b0110;    // SRL
                    6'b000011: ALUControl <= 4'b0111;    // SRA
                    6'b000100: ALUControl <= 4'b1011;    // SLLV
                    6'b000110: ALUControl <= 4'b1100;    // SRLV
                    6'b000111: ALUControl <= 4'b1101;    // SRAV
                    6'b001000: begin                     // JR
                                ALUControl <= 4'b0000;   // unused by JR
                                JR <= 1'b1;              // PC <= rs (read register 1)
                            end
                    6'b011000: begin                     // MULT
                                ALUControl <= 4'b0000;   // unused; product computed separately
                                MultOp <= 1'b1;          // HI:LO <= rs * rt (signed)
                            end
                    6'b010000: begin                     // MFHI
                                ALUControl <= 4'b0000;   // unused
                                MFHiLo <= 1'b1;          // rd <= HI
                            end
                    6'b010010: begin                     // MFLO
                                ALUControl <= 4'b0000;   // unused
                                MFHiLo <= 1'b1;          // rd <= LO
                            end
                endcase

            end

        6'b100011: begin                          // LW
                        temp <= 8'b10100100;     
                        ALUControl <= 4'b0000;
                    end

        6'b101011: begin                          // SW
                         temp <= 8'b00101000;      
                         ALUControl <= 4'b0000;
                    end  

        6'b000100: begin                          // BEQ
                         temp <= 8'b00010000;      
                        ALUControl <= 4'b0001; 
                    end      

        6'b000101: begin                          // BNE
                        temp <= 8'b00010001;  
                        ALUControl <= 4'b0001; 
                    end

        6'b001000: begin                          // ADDI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b0000; 
                    end  

        6'b001001: begin                          // ADDIU
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b0000; 
                    end  

        6'b001100: begin                          // ANDI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b0010; 
                    end 

        6'b001101: begin                          // ORI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b0011; 
                    end  

        6'b001110: begin                          // XORI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b0100; 
                    end       

        6'b001010: begin                          // SLTI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b1000; 
                    end 

        6'b001011: begin                          // SLTIU
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b1001; 
                    end  

        6'b000010: begin                          // J
                        temp <= 8'b00000010;
                        ALUControl <= 4'b0010;
                    end

        6'b000011: begin                          // JAL
                        temp <= 8'b10000010;      // RegWrite=1, Jump=1 (rest don't-care/0)
                        ALUControl <= 4'b0000;    // unused by JAL
                        JAL <= 1'b1;              // writereg <= $ra(31), writedata <= PC+4
                    end

        6'b001111:  begin                         // LUI
                        temp <= 8'b10100000;  
                        ALUControl <= 4'b1110; 
                    end          
        default:   temp <= 12'bxxxxxxxxxxxx;      // NOP
    endcase
   

    
    {RegWrite,RegDst,ALUSrc,Branch,MemWrite,MemtoReg,Jump,BNE} = temp;

    // JR and MULT do not write a register; override the R-type default here (reading
    // only the stable Opcode/Func inputs, not JR/MultOp themselves, avoids a double
    // non-blocking write to `temp` from two nested case scopes, which livelocks the
    // simulator). MFHI/MFLO keep RegWrite=1 from the R-type default -- they DO write rd.
    if (Opcode == 6'b000000 && Func == 6'b001000) RegWrite = 1'b0;   // JR
    if (Opcode == 6'b000000 && Func == 6'b011000) RegWrite = 1'b0;   // MULT

end

assign PCSrc = Branch & (Zero ^ BNE);

endmodule