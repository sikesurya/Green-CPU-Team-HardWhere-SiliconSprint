`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 11:26:36
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
input clk,reset,
input regwrite,memtoreg,
input branch,memread,memwrite,
input [15:0]sum,
input [15:0]ALU_result,
input zero,
input [15:0]RD2,
input [2:0]ins_wr,
output reg regwrite_out,memtoreg_out,branch_out,memread_out,memwrite_out,
output reg [15:0] sum_out,ALU_result_out,
output reg [2:0] ins_wr_out,
output reg zero_out,
output reg [15:0]RD2_out
    );
    always@(posedge clk or posedge reset)begin
    
    if(reset)begin
    regwrite_out <= 0;
    memtoreg_out <= 0;
    branch_out <= 0;
    memread_out <= 0;
    memwrite_out <= 0;
    sum_out <= 16'b0;
    ALU_result_out <= 3'b0;
    ins_wr_out <= 3'b0;
    zero_out <= 0;
    RD2_out  <= 0;
    end
    
    else begin
    regwrite_out <= regwrite;
    memtoreg_out <= memtoreg;
    branch_out <= branch;
    memread_out <= memread;
    memwrite_out <= memwrite;
    sum_out <= sum;
    ALU_result_out <= ALU_result;
    ins_wr_out <= ins_wr;
    zero_out <= zero;
    RD2_out  <= RD2;
    end
    end
    
    
    
endmodule
