`timescale 1ns / 1ps
`include "fp_shared.v"

module fp_addsub(
    input              clk_unused, // kept for interface parity, unused
    input              valid_in,
    input  [15:0]      a_in,
    input  [15:0]      b_in,
    output reg [15:0]  result_out,
    output reg         result_vld,
    output reg         ovf
);

wire a_s = a_in[15];
wire b_s = b_in[15];
wire [`HALF_EXP-1:0] a_e = a_in[14:10];
wire [`HALF_EXP-1:0] b_e = b_in[14:10];
wire [`HALF_MAN:0] a_m_ext = (a_e==0) ? {1'b0, a_in[9:0]} : {1'b1, a_in[9:0]};
wire [`HALF_MAN:0] b_m_ext = (b_e==0) ? {1'b0, b_in[9:0]} : {1'b1, b_in[9:0]};

wire a_is_nan = (a_e == {`HALF_EXP{1'b1}}) && (a_in[9:0] != 0);
wire b_is_nan = (b_e == {`HALF_EXP{1'b1}}) && (b_in[9:0] != 0);
wire a_is_inf = (a_e == {`HALF_EXP{1'b1}}) && (a_in[9:0] == 0);
wire b_is_inf = (b_e == {`HALF_EXP{1'b1}}) && (b_in[9:0] == 0);
wire a_is_zero = (a_in[14:0] == 15'b0);
wire b_is_zero = (b_in[14:0] == 15'b0);

// Alignment
reg [`HALF_MAN:0] larger_m, smaller_m;
reg [`HALF_EXP-1:0] larger_e;
reg larger_s, smaller_s;
reg [5:0] shift_amt; // up to 31 but we only need up to 31 safe margin

always @(*) begin
    // default
    larger_m = a_m_ext;
    smaller_m = b_m_ext;
    larger_e = a_e;
    larger_s = a_s;
    smaller_s = b_s;
    if (a_e < b_e) begin
        larger_m = b_m_ext;
        smaller_m = a_m_ext;
        larger_e = b_e;
        larger_s = b_s;
        smaller_s = a_s;
        shift_amt = b_e - a_e;
    end else begin
        shift_amt = a_e - b_e;
    end
    // Guard against shifting larger than mantissa width
    if (shift_amt > 11) begin
        smaller_m = 0;
    end else begin
        smaller_m = smaller_m >> shift_amt;
    end
end

// Add/Sub with sign handling
reg [12:0] raw_sum; // width enough for carry
reg out_sign;
always @(*) begin
    if (larger_s == smaller_s) begin
        raw_sum = {2'b00, larger_m} + {2'b00, smaller_m};
        out_sign = larger_s;
    end else begin
        if (larger_m >= smaller_m) begin
            raw_sum = {2'b00, larger_m} - {2'b00, smaller_m};
            out_sign = larger_s;
        end else begin
            raw_sum = {2'b00, smaller_m} - {2'b00, larger_m};
            out_sign = smaller_s;
        end
    end
end

// Normalization and rounding
reg [4:0] exp_after; // can go negative in process; keep signed behavior via checks
reg [11:0] norm_m; // normalized mantissa with guard and round bits
reg sticky;
integer i;
always @(*) begin
    exp_after = larger_e;
    norm_m = raw_sum[11:0]; // take lower bits
    sticky = 0;
    ovf = 0;
    // handle zero result
    if (raw_sum == 0) begin
        result_out = 16'b0;
        result_vld = valid_in;
        ovf = 0;
    end else begin
        // If carry out (bit 12), shift right and increment exponent
        if (raw_sum[12]) begin
            // shift right by 1, compute round bits
            // guard = bit 0 after shift; sticky = OR of bits shifted out
            sticky = |raw_sum[11:0];
            norm_m = raw_sum[12:1]; // top 12 -> after shift 12 bits (including guard)
            exp_after = larger_e + 1;
        end else begin
            // normalize left until MSB of mantissa (bit 11) is 1 (max 12 shifts)
            norm_m = raw_sum[11:0];
            while ((norm_m[11] == 0) && (exp_after > 0)) begin
                norm_m = norm_m << 1;
                exp_after = exp_after - 1;
            end
            // if further bits beyond representable, set sticky if any lower bits were 1
            sticky = 0;
        end

        // Rounding to nearest even:
        // norm_m[1] = guard bit, norm_m[0] = round bit; but our arrangement: take top 11 bits as mantissa+implicit
        // We'll compute guard and sticky from norm_m lower bits if present
        // Build 10-bit mantissa + guard + sticky
        // norm_m width 12: [11:0] -> mantissa candidates in [11:2], guard=norm_m[1], roundbit=norm_m[0]
        // sticky already accounts for any bits shifted out; for simplicity keep sticky as OR of lower bits
        // Calculate round increment
        reg round_inc;
        reg guard_bit;
        reg round_bit;
        guard_bit = norm_m[1];
        round_bit = norm_m[0];
        round_inc = guard_bit & (round_bit | sticky | (norm_m[2] & guard_bit)); // nearest even heuristic

        // Assemble final mantissa (10 bits)
        reg [10:0] mant_pre;
        mant_pre = norm_m[11:1]; // 11 bits (implicit + 10 mantissa)
        mant_pre = mant_pre + round_inc;

        // Handle mantissa overflow after rounding
        if (mant_pre[10]) begin
            // overflowed into extra bit: shift right and increment exponent
            mant_pre = mant_pre >> 1;
            exp_after = exp_after + 1;
        end

        // Check for exponent overflow
        if (exp_after >= {`HALF_EXP{1'b1}}) begin
            ovf = 1;
            result_out = {out_sign, {`HALF_EXP{1'b1}}, {`HALF_MAN{1'b0}}}; // Inf
            result_vld = 1;
        end else if (exp_after == 0) begin
            // subnormal or zero
            result_out = {out_sign, 5'b0, mant_pre[9:0]};
            result_vld = 1;
        end else begin
            // Normalized result
            result_out = {out_sign, exp_after[4:0], mant_pre[9:0]};
            result_vld = 1;
        end
    end
end

// Special cases handling override (NaN / Inf / zeros)
always @(*) begin
    if (!valid_in) begin
        result_out = 16'b0;
        result_vld = 1'b0;
        ovf = 0;
    end else if (a_is_nan || b_is_nan) begin
        result_out = `QNAN_HALF;
        result_vld = 1;
        ovf = 1;
    end else if ((a_is_inf && b_is_inf) && (a_s != b_s)) begin
        // Inf - Inf = NaN
        result_out = `QNAN_HALF;
        result_vld = 1;
        ovf = 1;
    end else if (a_is_inf || b_is_inf) begin
        result_out = a_is_inf ? a_in : b_in;
        result_vld = 1;
        ovf = 1;
    end else if (a_is_zero && b_is_zero) begin
        result_out = 16'b0;
        result_vld = 1;
        ovf = 0;
    end
    // else arithmetic path above already sets result
end

endmodule