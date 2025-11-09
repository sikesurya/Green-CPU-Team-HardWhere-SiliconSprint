`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 02:17:52
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
input clk ,reset,
input [15:0] RD1,RD2,imm_in,pc_in,
input  ins_in1,
input [2:0]ins_in2,
input [2:0]ins_wr,
input regwr_in,branch,memread,memwrite,ALUsrc,memtoreg,
input [1:0]ALUop,
output reg [15:0] RD1_out,RD2_out,imm_out,pc_out,
output  reg ins_in1_out,
output reg  [2:0]ins_in2_out,
output reg [2:0]ins_wr_out,
output reg regwr_in_out,branch_out,memread_out,memwrite_out,ALUsrc_out,memtoreg_out,
output reg  [1:0]ALUop_out
    );
    
    always@(posedge clk or posedge reset)begin
    if (reset) begin
    RD1_out <= 15'b0;
    RD2_out <= 15'b0;
    imm_out <= 15'b0;
    ins_in1_out <= 1'b0;
    ins_in2_out <= 3'b0;
    ins_wr_out <= 3'b0; 
    regwr_in_out <= 0;
    branch_out <= 0;
    memread_out <= 0;
    memwrite_out <= 0;
    ALUsrc_out <= 0;
    memtoreg_out <= 0;
    ALUop_out <= 0;
    end
    else begin
     RD1_out <= RD1;
    RD2_out <= RD2;
    imm_out <= imm_in;
   ins_in1_out <= ins_in1;
    ins_in2_out <= ins_in2;
    ins_wr_out <= ins_wr; 
    regwr_in_out <= regwr_in;
    branch_out <= branch;
    memread_out <= memread;
    memwrite_out <= memwrite;
    ALUsrc_out <= ALUsrc;
    memtoreg_out <= memtoreg;
    ALUop_out <= ALUop;
    end
    
    
    end
endmodule
