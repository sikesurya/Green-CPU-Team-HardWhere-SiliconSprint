module registers (
    input clk,reset,                       
    input [2:0] rr1,           
    input [2:0] rr2,           
    input [2:0] wr,           
    input [15:0] wd,         
    input write_sig,                
    output [15:0] rd1, rd3,    
    output [15:0] rd2     
);

    reg [15:0] registers [0:7];

    integer i;

    // Use an initial block for register initialization
   /* initial begin
        registers[0]  = 0;
        registers[1]  = 4;
        registers[2]  = 2;
        registers[3]  = 24;
        registers[4]  = 4;
        registers[5]  = 1;
        registers[6]  = 44;
        registers[7]  = 4;
        registers[8]  = 2;
        registers[9]  = 1;
        registers[10] = 23;
        registers[11] = 4;
        registers[12] = 90;
        registers[13] = 10;
        registers[14] = 20;
        registers[15] = 30;
        registers[16] = 40;
        registers[17] = 50;
        registers[18] = 60;
        registers[19] = 70;
        registers[20] = 80;
        registers[21] = 80;
        registers[22] = 90;
        registers[23] = 70;
        registers[24] = 60;
        registers[25] = 65;
        registers[26] = 4;
        registers[27] = 32;
        registers[28] = 12;
        registers[29] = 34;
        registers[30] = 5;
        registers[31] = 10;
    end
    */

    // Write operation
    always @(posedge clk or posedge reset) begin
    if(reset)begin
    for(i = 0;i <32;i = i+1) begin
    registers[i] <= 32'd0;
    end
    end
     else if (write_sig && wr != 0) begin
            registers[wr] <= wd;
        end
    end

    // Read operations
    assign rd1 = registers[rr1];
    assign rd2 = registers[rr2];
    assign rd3 = registers[wr];

endmodule
