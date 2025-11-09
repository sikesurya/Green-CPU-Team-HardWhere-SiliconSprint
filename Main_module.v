
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2024 12:23:24
// Design Name: 
// Module Name: Main_module
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


module Main_module(input clk,reset,
output [3:0]out_1
    );
    wire [15:0]pc_in,pc_out,sum_out,topc_main,pc_in_main,alu_result,data_out;
    wire [15:0]ins_out,rd1,rd2,Imm_out,mux1_out,writeback_out,rd3;
    wire regwrite,alusrc,memwrite,memtoreg,memread,branch,zero,sel2_main;
    wire[1:0] aluop;
   wire [3:0]control_out;
   wire [15:0]IFpc_out,IFins_out,IDrd1,IDrd2,IDImm_out,IDpc_out;
   wire IDins_in1_out;
   wire [2:0]IDins_in2_out;
   wire [2:0]IDins_wr_out;
   wire IDregwr_in_out,IDbranch_out,IDmemread_out,IDmemwrite_out,IDALUsrc_out,IDmemtoreg_out;
   wire [1:0]IDALUop_out;
   wire EXregwrite_out,EXmemtoreg_out,EXbranch_out,EXmemread_out,EXmemwrite_out,EXzero_out,MEMregwrite_out,MEMmemtoreg_out;
   wire  [15:0]EXsum_out,EXALU_result_out,EXRD2_out,MEMreaddata_out,MEMALU_result_out;
   wire [2:0]EXins_wr_out,MEMins_wr_out;
   
    
    //ProgramCounter pc1(.clk(clk),.reset(reset),.pc_in(pc_in_main),.pc_out(pc_out));
    ProgramCounter pc1(.clk(clk),.reset(reset),.pc_in(pc_in_main),.pc_out(pc_out));
    
    Adder_1 PC_adder(.pcout(pc_out),.topc(topc_main));
    
    Instruction_memory IM(.clk(clk),.reset(reset),.address(pc_out),.ins(ins_out));
    
    IF_ID IFID(.clk(clk),.reset(reset),.pc_in(pc_out),.ins_in(ins_out),.pc_out(IFpc_out),.ins_out(IFins_out));
    
    registers Register(.clk(clk),.reset(reset),.rr1(IFins_out[19:15]),.rr2(IFins_out[24:20]),.wr(EXins_wr_out),.wd(writeback_out),.write_sig(MEMregwrite_out),.rd1(rd1),.rd2(rd2),.rd3(rd3));
    
    ImmGen   IG(.ins(IFins_out),.imm_out(Imm_out));
    
    Control CONT(.ins(IFins_out[6:0]),.RegWrite(regwrite),.ALUSrc(alusrc),.MemWrite(memwrite),.MemtoReg(memtoreg),.MemRead(memread),.Branch(branch),.ALUOp(aluop));
   
   ID_EX IDEX(.clk(clk),.reset(reset),.pc_in(IFpc_out),.pc_out(IDpc_out),.ins_wr(IFins_out[11:7]),.ins_in1(IFins_out[30]),.ins_in2(IFins_out[14:12]),.RD1(rd1),.RD2(rd2),.imm_in(Imm_out),.regwr_in(regwrite),.branch(branch),.memread(memread),.memwrite(memwrite),.ALUsrc(alusrc),.memtoreg(memtoreg),.ALUop(aluop),.RD1_out(IDrd1),.RD2_out(IDrd2),.imm_out(IDImm_out),.ins_in1_out(IDins_in1_out),.ins_in2_out(IDins_in2_out),.ins_wr_out(IDins_wr_out),.regwr_in_out(IDregwr_in_out),.branch_out(IDbranch_out),.memread_out(IDmemread_out),.memwrite_out(IDmemwrite_out),.ALUsrc_out(IDALUsrc_out),.memtoreg_out(IDmemtoreg_out),.ALUop_out(IDALUop_out)); 
   
   ALUcontrol ALu_con(.funct7(IDins_in1_out),.funct3(IDins_in2_out),.ALUop(IDALUop_out),.ALUcon(control_out));
    
    ALU alu(.A(IDrd1),.B(mux1_out),.ALUcon(control_out),.result(alu_result),.Z(zero),.out_1(out_1));
    
    MUX mux1(.in0(IDrd2),.in1(IDImm_out),.sel(IDALUsrc_out),.out(mux1_out));
    
    Adder_2 add(.in1(IDpc_out),.in2(IDImm_out),.sum(sum_out));
    
    EX_MEM EXMEM(.clk(clk),.reset(reset),.regwrite(IDregwr_in_out),.memtoreg(IDmemtoreg_out),.branch(IDbranch_out),.memread(IDmemread_out),.memwrite(IDmemwrite_out),.sum(sum_out),.ALU_result(alu_result),.zero(zero),.RD2(IDrd2),.ins_wr(IFins_out[11:7]),. regwrite_out(EXregwrite_out),.memtoreg_out(EXmemtoreg_out),.branch_out(EXbranch_out),.memread_out(EXmemread_out),.memwrite_out(EXmemwrite_out),.sum_out(EXsum_out),.ALU_result_out(EXALU_result_out),.ins_wr_out(EXins_wr_out),.zero_out(EXzero_out),.RD2_out(EXRD2_out));
    
    AND_gate and1(.Branch(EXbranch_out),.Zero(EXzero_out),.And_out(sel2_main));
    
    MUX mux2(.in0(topc_main),.in1(EXsum_out),.sel(sel2_main),.out(pc_in_main));
    
    Data_memory DM(.address(EXALU_result_out[11:2]),.writedata(EXRD2_out),.memread(EXmemread_out),.memwrite(EXmemwrite_out),.clk(clk),.reset(reset),.readdata(data_out));
    
    MEM_WB MEMWB(.clk(clk),.reset(reset),.regwrite(EXregwrite_out),.memtoreg(EXmemtoreg_out),.readdata(data_out),.ALU_result(EXALU_result_out),.ins_wr(EXins_wr_out),.regwrite_out(MEMregwrite_out),.memtoreg_out(MEMmemtoreg_out),.readdata_out(MEMreaddata_out),.ALU_result_out(MEMALU_result_out),.ins_wr_out(MEMins_wr_out));
    
    MUX mux3(.in0(MEMALU_result_out),.in1(MEMreaddata_out),.sel(MEMmemtoreg_out),.out(writeback_out));
      
    
      
endmodule
