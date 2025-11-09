`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2024 12:12:35
// Design Name: 
// Module Name: MUX
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


module MUX (
    input [15:0] in0,   
    input [15:0] in1,   
    input sel,          
    output reg [15:0] out

    
);

    always @(*) begin
        case (sel)
            1'b0: out = in0; 
            1'b1: out = in1; 
                    endcase
    end
  
   
endmodule
