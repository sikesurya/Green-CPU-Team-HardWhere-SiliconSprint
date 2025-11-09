`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 01:13:20
// Design Name: 
// Module Name: Clock
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


module toggle_Clock (
    input wire clk_signal, // 50 MHz clock input
   input wire reset,        // Active high reset
    output reg clk         // Toggling output signal
);

    reg [4:0] counter;    // 26-bit counter to count up to 50M

    always @(posedge clk_signal) begin
    
        if (~reset) begin
            counter <= 0;
            clk <= 0;
        end else if (counter == 27'd75000000) begin
            counter <= 0;
            clk <= ~clk;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule

