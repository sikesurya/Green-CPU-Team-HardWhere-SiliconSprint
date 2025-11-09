`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2025 02:11:51
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
input clk,reset,
input [15:0]pc_in,
input [15:0]ins_in,
output reg [15:0]pc_out,
output reg [15:0]ins_out
    );
    always@(posedge clk or posedge reset)begin
    if(reset)begin
    pc_out <= 16'b0;
    ins_out <= 16'b0;
    end
    else begin
    pc_out <= pc_in;
    ins_out <= ins_in;
    end
    end
endmodule
