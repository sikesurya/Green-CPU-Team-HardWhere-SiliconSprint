`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.12.2024 01:10:56
// Design Name: 
// Module Name: Control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Control (
    input [3:0] opcode,
    output reg branch,
    output reg memRead,
    output reg memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
    );

    // TODO: implement your Control here
    // Hint: follow the Architecture to set output signal
    always@(*)
    begin
        branch = 0;
        memRead = 0;
        memtoReg = 0;
        ALUOp = 2'b00;
        memWrite = 0;
        ALUSrc = 0;
        regWrite = 0;
        case(opcode)
            7'b0000:begin // R-type
                        branch = 0;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b10;
                        memWrite = 0;
                        ALUSrc = 0;
                        regWrite = 1;
                       end
            7'b1000:begin // lw
                        branch = 0;
                        memRead = 1;
                        memtoReg = 1;
                        ALUOp = 2'b00;
                        memWrite = 0;
                        ALUSrc = 1;
                        regWrite = 1;
                       end
            7'b1100:begin // sw
                        branch = 0;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b00;
                        memWrite = 1;
                        ALUSrc = 1;
                        regWrite = 0;
                       end
            7'b0010:begin // B
                        branch = 1;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b01;
                        memWrite = 0;
                        ALUSrc = 0;
                        regWrite = 0;
                       end
            7'b0001:begin  // I-type
                        branch = 0;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b11;
                        memWrite = 0;
                        ALUSrc = 1;
                        regWrite = 1;
                       end
            7'b0011: begin // JAL
                        branch = 1;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b00;
                        memWrite = 0;
                        ALUSrc = 1;
                        regWrite = 1;
                       end
           7'b0100: begin // JALR
                        branch = 1;
                        memRead = 0;
                        memtoReg = 0;
                        ALUOp = 2'b00;
                        memWrite = 0;
                        ALUSrc = 1;
                        regWrite = 1;
                       end
        endcase
    end

endmodule