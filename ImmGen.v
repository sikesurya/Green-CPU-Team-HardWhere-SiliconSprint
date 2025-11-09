`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.12.2024 00:52:21
// Design Name: Immediate Generator (ImmGen)
// Module Name: ImmGen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  - Generates immediate values based on the instruction format
//  - Prevents optimization of unused instruction bits
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ImmGen (
    input [15:0] ins,         // 32-bit instruction input
    output reg [15:0] imm_out // 32-bit immediate output
    // 8-bit output to prevent optimization of unused bits
);

// Extract opcode from instruction
wire [3:0] opcode;
assign opcode = ins[15:12];

// Assign unused bits to an output signal to prevent optimization


// Alternative method: Explicitly prevent optimization using (* DONT_TOUCH = "TRUE" *)
genvar i;
generate
    for (i = 12; i <= 19; i = i + 1) begin : UNUSED_BITS
        (* DONT_TOUCH = "TRUE" *) wire unused_instruction_bit = ins[i];
    end
endgenerate

// Immediate Generator Logic
always @(*) begin
    case (opcode)
        4'b0000: imm_out = {{20{ins[5]}}, ins[5:3]};                      // I-type (Load)
        4'b0001: imm_out = {{20{ins[5]}}, ins[5:3]};                      // I-type (ALU Immediate)
        4'b1000: imm_out = {{20{ins[5]}}, ins[5:0]};           // S-type (Store)
        4'b0010: imm_out = {{19{ins[31]}}, ins[5:0]}; // B-type (Branch)
        default  imm_out = 16'h0000;                                     // Default case
    endcase
end

endmodule
