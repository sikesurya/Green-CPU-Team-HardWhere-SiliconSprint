`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 11:37:53
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
input clk,reset,
input regwrite,memtoreg,
input [15:0]readdata,ALU_result,
input [2:0] ins_wr,
output reg regwrite_out ,memtoreg_out,
output reg [15:0]readdata_out,ALU_result_out,
output reg [2:0]ins_wr_out 
    );
    always @(posedge clk or posedge reset) begin
    if(reset)begin
    regwrite_out <= 0;
    memtoreg_out <= 0;
    readdata_out <= 0;
    ALU_result_out <= 0;
    ins_wr_out <= 2'b0;
    end
    else begin
    regwrite_out <= regwrite;
    memtoreg_out <= memtoreg;
    readdata_out <= readdata;
    ALU_result_out <= ALU_result;
    ins_wr_out <= ins_wr;
    end
    end
    
endmodule
