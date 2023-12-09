module E#(

    input logic           RegWriteE_i,
    input logic [1:0]     ResultSrcE_i,
    input logic           MemWriteE_i,
    input logic           JumpE_i,
    input logic           BranchE_i,
    input logic [2:0]     ALUControlE_i,
    input logic           ALUSrcE_i,

    input logic [31:0]    RD1E_i,
    input logic [31:0]    RD2E_i,
    input logic [31:0]    PCE_i,
    input logic [11:7]    RdE_i,
    input logic [31:7]    ImmExtE_i,
    input logic [31:0]    PCPlus4E_i,

    output logic [31:0]   PCTargetE_o,
    output logic [31:0]   PCPlus4E_o,
    output logic [31:0]   RdE_o,
    output logic [31:0]   WriteDataE_o,
    output logic [31:0]   ALUResultE_o,

    output logic          MemWriteE_o,
    output logic [1:0]    ResultSrcE_o,
    output logic          RegWriteE_o,
    output logic          PCSrcE_o,
    output logic          ZeroE

);
//=======================================
//          WIRE

logic [31:0]    PCTargetE    = PCE + ImmExtE;
logic [31:0]    WriteDataE_o = RD2E;
logic [31:0]    SrcBE        = (ALUSrcE_i) ? ImmExtE_i : RD2E_i; 
logic           PCSrcE_o     = (ZeroE & BranchE) | JumpE_i;

ALU ALU(
    //INPUT
    .SrcAE(RD1E_i),
    .SrcBE(SrcBE)
    .ALUControlE(ALUControlE_i)

    //OUTPUTS
    .ALUResultE(ALUResultE_o),
    .ZeroE(ZeroE),
);

endmodule