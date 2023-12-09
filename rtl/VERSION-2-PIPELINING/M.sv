module E#(

    input logic           clk,
    input logic           RegWriteM_i,
    input logic [1:0]     ResultSrcM_i,
    input logic           MemWriteM_i,

    input logic [11:7]    RdM_i,
    input logic [31:0]    PCPlus4M_i,
    input logic [31:0]    ALUResultM_i,
    input logic [31:0]    WriteDataM_i,

    output logic          RegWriteM_o,
    output logic [1:0]    ResultSrcM_o,

    output logic [31:0]   ALUResultM_o,
    output logic [11:7]   RdM_o,
    output logic [31:0]   PCPlus4M_o,
    output logic [31:0]   RD

);
//=======================================

assign logic           RegWriteM_o = RegWrite_i;
assign logic [1:0]     ResultSrcM_o = ResultSrcM_i;
assign logic [31:0]    ALUResultM_i = ALUResultM_o;
assign logic [11:7]    RdM_i = RdM_o;
assign logic [31:0]    PCPlus4M_i = PCPlus4M_o;


Data_mem Data_mem(
    //INPUT
    .clk(clk),
    .WE(MemWriteM_i),
    .A(ALUResultM_i),
    .WD(WriteDataM_i),

    //OUTPUTS
    .RD(RD),
);

endmodule