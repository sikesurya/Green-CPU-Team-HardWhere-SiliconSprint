`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 20:23:28
// Design Name: 
// Module Name: Program Counter
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


module ProgramCounter(input clk,reset,
input [15:0]pc_in,
output reg [15:0]pc_out );

always @(posedge clk or posedge reset) begin

  if(reset)
    pc_out <= 16'b0;
  else
    pc_out <= pc_in;
 end
 
endmodule
