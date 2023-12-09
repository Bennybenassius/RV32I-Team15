module E#(

    input logic           RegWriteE,
    input logic [1:0]     ResultSrcE,
    input logic           MemWriteE,
    input logic           JumpE,
    input logic           BranchE,
    input logic [2:0]     ALUControlE,
    input logic           ALUSrcE,

    input logic [31:0]    RD1E,
    input logic [31:0]    RD2E,
    input logic [31:0]    PCE,
    input logic [11:7]    in_RdE,
    input logic [31:7]    ImmExtE,
    input logic [31:0]    in_PCPlus4E

    output logic [31:0]   PCTargetE,
    output logic [31:0]   out_PCPlus4E,
    output logic [31:0]   out_RdE,
    output logic [31:0]   WriteDataE,
    output logic [31:0]   ALUResultE,

    output logic          MemWriteE,
    output logic [1:0]    ResultSrcE,
     

);
//=======================================
//          WIRE

logic [31:0]    PCTargetE = PCE + ImmExtE;





endmodule