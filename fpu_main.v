`timescale 1ns / 1ps
`include "fp_shared.v"


module fpu(
    input            i_valid,
    input  [15:0]    i_operand_a,
    input  [15:0]    i_operand_b,
    input  [3:0]     i_opcode, // choose operation: 4'b0001 add, 4'b0010 mul (user can expand)
    output reg [15:0] o_result,
    output reg        o_overflow
);

// Local wires
wire [15:0] add_res, mul_res;
wire add_v, mul_v;
wire add_ovf, mul_ovf;

// Instantiate add/sub unit (handles addition and subtraction by signs)
fp_addsub u_addsub (
    .clk_unused(1'b0),
    .valid_in(i_valid),
    .a_in(i_operand_a),
    .b_in(i_operand_b),
    .result_out(add_res),
    .result_vld(add_v),
    .ovf(add_ovf)
);

// Instantiate multiplier
fp_mul u_mul (
    .valid_in(i_valid),
    .a_in(i_operand_a),
    .b_in(i_operand_b),
    .result_out(mul_res),
    .result_vld(mul_v),
    .ovf(mul_ovf)
);

// Opcode selection
always @(*) begin
    o_result = 16'b0;
    o_overflow = 1'b0;
    case (i_opcode)
        4'b0001: begin // add/sub
            o_result = add_res;
            o_overflow = add_ovf;
        end
        4'b0010: begin // multiply
            o_result = mul_res;
            o_overflow = mul_ovf;
        end
        default: begin
            o_result = 16'b0;
            o_overflow = 1'b0;
        end
    endcase
end

endmodule