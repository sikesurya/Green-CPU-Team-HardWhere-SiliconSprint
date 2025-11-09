`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2024 02:08:48
// Design Name: 
// Module Name: Data_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 16-bit Data Memory for Custom ISA
// 
//////////////////////////////////////////////////////////////////////////////////

module Data_memory(
    input [9:0] address,
    input [15:0] writedata,
    input memread,
    input memwrite,
    input clk,
    input reset,
    output [15:0] readdata
);
    integer i;
    reg [15:0] memory [1023:0];   // 1024 words, each 16-bit wide

    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            for (i = 0; i < 1024; i = i + 1) begin
                memory[i] <= 16'd0;
            end
        end 
        else if (memwrite) begin
            memory[address] <= writedata;
        end
    end

    assign readdata = (memread) ? memory[address] : 16'd0;

endmodule
