`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 01:24:24
// Design Name: 
// Module Name: TOP
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


module TOP(
    input reset, 
    input clk_signal,  // 50 MHz input clock
    output [3:0] out_1
   
);
    wire clk;
   // assign clk1 = clk;

    // Instantiate clock divider
    toggle_Clock ck(.reset(reset),.clk_signal(clk_signal), .clk(clk));

    // Instantiate main module with toggled clock
    Main_module m1(.clk(clk) ,.reset(reset) ,.out_1(out_1));
endmodule