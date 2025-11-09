`timescale 1ns / 1ps

//============================================================
// 16-bit IEEE 754 Half Precision FPU Testbench
//============================================================

module tb_fpu();

    // DUT inputs
    reg [15:0] a, b;
    reg [3:0] opcode;
    reg valid_in;

    // DUT outputs
    wire [15:0] result;
    wire valid_out;
    wire overflow;

    // Instantiate the DUT
    fpu uut (
        .a(a),
        .b(b),
        .opcode(opcode),
        .valid_in(valid_in),
        .result(result),
        .valid_out(valid_out),
        .overflow(overflow)
    );

    // Utility task to display results
    task display_result;
        input [15:0] op_a;
        input [15:0] op_b;
        input [3:0] op_code;
        begin
            #5; // small delay for combinational settle
            $display("Time=%0t | Opcode=%b | A=%h | B=%h | -> Result=%h | Overflow=%b",
                      $time, op_code, op_a, op_b, result, overflow);
        end
    endtask

    // IEEE 754 Half-precision constants
    localparam ZERO_POS = 16'h0000;
    localparam ZERO_NEG = 16'h8000;
    localparam INF_POS  = 16'h7C00;
    localparam INF_NEG  = 16'hFC00;
    localparam NAN_Q    = 16'h7E00;

    // A few sample encoded values
    // Example: 0 01111 0000000000 = +1.0
    localparam ONE      = 16'h3C00;
    localparam TWO      = 16'h4000;
    localparam HALF     = 16'h3800;
    localparam THREE    = 16'h4200;
    localparam FOUR     = 16'h4400;

    initial begin
        $display("---------------------------------------------------------");
        $display("           IEEE 754 Half-Precision FPU TESTBENCH          ");
        $display("---------------------------------------------------------");
        
        valid_in = 1'b1;

        // --- ADDITION TESTS ---
        opcode = 4'b0001;
        a = ONE; b = ONE;       display_result(a,b,opcode); // 1.0 + 1.0 = 2.0
        a = TWO; b = HALF;      display_result(a,b,opcode); // 2.0 + 0.5 = 2.5
        a = INF_POS; b = ONE;   display_result(a,b,opcode); // +Inf + 1.0 = +Inf
        a = NAN_Q; b = ONE;     display_result(a,b,opcode); // NaN + 1.0 = NaN
        a = ZERO_POS; b = ZERO_POS; display_result(a,b,opcode); // 0 + 0 = 0

        // --- SUBTRACTION TESTS ---
        opcode = 4'b0001;
        a = TWO; b = ONE ^ 16'h8000; // 2.0 - 1.0
        display_result(a,b,opcode);

        // --- MULTIPLICATION TESTS ---
        opcode = 4'b0010;
        a = TWO; b = TWO;       display_result(a,b,opcode); // 2.0 * 2.0 = 4.0
        a = HALF; b = FOUR;     display_result(a,b,opcode); // 0.5 * 4.0 = 2.0
        a = INF_POS; b = ZERO_POS; display_result(a,b,opcode); // Inf * 0 = NaN
        a = INF_NEG; b = INF_NEG; display_result(a,b,opcode); // -Inf * -Inf = +Inf
        a = THREE; b = HALF;    display_result(a,b,opcode); // 3.0 * 0.5 = 1.5

        // --- Special Case Tests ---
        opcode = 4'b0001; // add
        a = INF_POS; b = INF_NEG; display_result(a,b,opcode); // +Inf + -Inf = NaN
        a = ZERO_NEG; b = ZERO_POS; display_result(a,b,opcode); // -0 + 0 = +0

        $display("---------------------------------------------------------");
        $display("Testbench completed.");
        $display("---------------------------------------------------------");

        $finish;
    end

endmodule
