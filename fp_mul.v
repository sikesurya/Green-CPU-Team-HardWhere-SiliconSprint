`timescale 1ns / 1ps
`include "fp_shared.v"

module fp_mul(
    input             valid_in,
    input      [15:0] a_in,
    input      [15:0] b_in,
    output reg [15:0] result_out,
    output reg        result_vld,
    output reg        ovf
);

wire a_s = a_in[15];
wire b_s = b_in[15];
wire [`HALF_EXP-1:0] a_e = a_in[14:10];
wire [`HALF_EXP-1:0] b_e = b_in[14:10];
wire [`HALF_MAN:0] a_m_ext = (a_e==0) ? {1'b0, a_in[9:0]} : {1'b1, a_in[9:0]};
wire [`HALF_MAN:0] b_m_ext = (b_e==0) ? {1'b0, b_in[9:0]} : {1'b1, b_in[9:0]};

wire a_is_nan  = (a_e == {`HALF_EXP{1'b1}}) && (a_in[9:0] != 0);
wire b_is_nan  = (b_e == {`HALF_EXP{1'b1}}) && (b_in[9:0] != 0);
wire a_is_inf  = (a_e == {`HALF_EXP{1'b1}}) && (a_in[9:0] == 0);
wire b_is_inf  = (b_e == {`HALF_EXP{1'b1}}) && (b_in[9:0] == 0);
wire a_is_zero = (a_in[14:0] == 15'b0);
wire b_is_zero = (b_in[14:0] == 15'b0);

wire res_sign = a_s ^ b_s;

// special cases first
always @(*) begin
    if (!valid_in) begin
        result_out = 16'b0;
        result_vld = 1'b0;
        ovf = 0;
    end else if (a_is_nan || b_is_nan || (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero)) begin
        result_out = `QNAN_HALF;
        result_vld = 1;
        ovf = 1;
    end else if (a_is_inf || b_is_inf) begin
        result_out = {res_sign, {`HALF_EXP{1'b1}}, {`HALF_MAN{1'b0}}};
        result_vld = 1;
        ovf = 1;
    end else if (a_is_zero || b_is_zero) begin
        result_out = {res_sign, 15'b0};
        result_vld = 1;
        ovf = 0;
    end else begin
        // Core multiply
        // Multiply extended mantissas (11x11 = 22 bits)
        wire [21:0] prod = a_m_ext * b_m_ext;
        // Determine normalization shift (if MSB at bit 21)
        wire norm_shift = prod[21];
        wire [10:0] mant_candidate = norm_shift ? prod[20:10] : prod[19:9]; // 11 bits (implicit + 10)
        wire guard = norm_shift ? prod[9] : prod[8];
        wire sticky = norm_shift ? |prod[8:0] : |prod[7:0];
        wire round_bit = guard & (sticky | mant_candidate[0]); // round to nearest even heuristic

        wire [10:0] mant_rounded = mant_candidate + round_bit;
        wire carry_out = mant_rounded[10];
        wire [9:0] final_m = carry_out ? mant_rounded[10:1] : mant_rounded[9:0];

        // Exponent calculation
        wire [6:0] exp_raw = a_e + b_e - `HALF_BIAS + norm_shift + carry_out;
        wire [4:0] final_exp_w = exp_raw[4:0];

        // Overflow detection
        if (exp_raw > 7'd30) begin
            ovf = 1;
            result_out = {res_sign, {`HALF_EXP{1'b1}}, {`HALF_MAN{1'b0}}};
            result_vld = 1;
        end else begin
            ovf = 0;
            result_out = {res_sign, final_exp_w, final_m};
            result_vld = 1;
        end
    end
end

endmodule