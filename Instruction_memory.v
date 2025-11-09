module Instruction_memory (
    input  [15:0] readAddr,   // 16-bit address input
    output [15:0] inst        // 16-bit instruction output
);
    // 128 bytes total -> 64 instructions (each 16 bits)
    reg [7:0] insts [0:127];

    assign inst = (readAddr >= 128) ? 16'b0 : 
                  {insts[readAddr], insts[readAddr + 1]};

    integer i;
    initial begin
        
        insts[0]  = 8'b00001010;  // Instruction 0 upper byte
        insts[1]  = 8'b00110000;  // Instruction 0 lower byte

        insts[2]  = 8'b00000100;  // Instruction 1 upper byte
        insts[3]  = 8'b00010011;  // Instruction 1 lower byte

        insts[4]  = 8'b11111111;
        insts[5]  = 8'b11000001;

        insts[6]  = 8'b00000001;
        insts[7]  = 8'b00010011;

        insts[8]  = 8'b00000000;
        insts[9]  = 8'b10000001;

        insts[10] = 8'b00100000;
        insts[11] = 8'b00100011;

        // Zero-fill remaining bytes
        for (i = 12; i < 128; i = i + 1)
            insts[i] = 8'b0;
    end
endmodule
