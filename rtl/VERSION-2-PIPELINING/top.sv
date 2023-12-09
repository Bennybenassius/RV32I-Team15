module top#(
)(
    //INPUTS
    input   logic           clk,
    input   logic           rst,
    input   logic           trigger,

    //OUTPUTS
    output  logic[31:0]     a0
);

//==========================================
//                 WIRE
//Wires going in and out of F stage
logic   [1: 0]  PCSrcE_o;
logic   [31:0]  PCTargetE_o;
logic   [31:0]  ALUResultE_o;
logic   [31:0]  PCF_o;
logic   [31:0]  PCPlus4F_o;
logic   [31:0]  InstrF_o;
//Wires going in and out of FD pipeline register
logic   [31:0]  InstrD_o;
logic   [31:0]  PCD_o;
logic   [31:0]  PCPlus4D_o;
//Wires going in and out of D stage
logic           RegWriteW_o;
logic   [4: 0]  RdW_o;
logic   [31:0]  ResultW_o;
logic           RegWriteD_o;
logic   [1: 0]  ResultSrcD_o;
logic           MemWriteD_o;
logic   [1: 0]  JumpD_o;
logic           BranchD_o;
logic   [2: 0]  ALUControlD_o;
logic           ALUSrcD_o;
logic   [31:0]  RD1D_o;
logic   [31:0]  RD2D_o;
logic   [4: 0]  RdD_o;
logic   [31:0]  ImmExtD_o;
//Wires going in and out of DE pipeline register
logic           RegWriteE_o;
logic   [1: 0]  ResultSrcE_o;
logic           MemWriteE_o;
logic   [1: 0]  JumpE_o;
logic           BranchE_o;
logic   [2: 0]  ALUControlE_o;
logic           ALUSrcE_o;
logic   [31:0]  RD1E_o;
logic   [31:0]  RD2E_o;
logic   [4: 0]  RdE_o;
logic   [31:0]  ImmExtE_o;
logic   [31:0]  PCE_o;
logic   [31:0]  PCPlus4E_o;
//Wires going in and out of E stage
logic   [31:0]  WriteDataE_o;

//Wires going in and out of EM pipeline register
logic           RegWriteM_o;
logic   [1: 0]  ResultSrcM_o;
logic           MemWriteM_o;
logic   [31:0]  ALUResultM_o;
logic   [31:0]  WriteDataM_o;
logic   [4: 0]  RdM_o;
logic   [31:0]  PCPlus4M_o;

//Wires going in and out of M stage
logic   [31:0]  ReadDataM_o;

//Wire going in and out of MW pipeline register
logic   [2: 0]  ResultSrcW_o;
logic   [31:0]  ALUResultW_o;
logic   [31:0]  ReadDataW_o;
logic   [31:0]  PCPlus4W_o;

//==========================================
//                  MODULES

//Fetching pipeline stage
F   F(
    //INPUTS\
    .clk(clk),
    .rst(rst),
    .PCSrcE_i(PCSrcE_o),
    .PCTargetE_i(PCTargetE_o),
    .ALUResultE_i(ALUResultE_o),
    //OUTPUTS
    .PCF_o(PCF_o),
    .PCPlus4F_o(PCPlus4F_o),
    .InstrF_o(InstrF_o)
);

//Pipeline register between F and D
Pipeline_Regfile_FD Pipeline_Regfile_FD (
    //INPUTS
    .clk(clk),
    .InstrF_i(InstrF_o),
    .PCF_i(PCF_o),
    .PCPlus4F_i(PCPlus4F_o),
    //OUTPUT
    .InstrD_o(InstrD_o),
    .PCD_o(PCD_o),
    .PCPlus4D_o(PCPlus4D_o)
);

//Decode pipeline stage
D   D (
    //INPUT
    .clk(clk),
    .RegWriteW_i(RegWriteW_o),
    .InstrD_i(InstrD_o),
    .PCD_i(PCD_o),
    .RdW_i(RdW_o),
    .ResultW_i(ResultW_o),
    //OUTPUT
    .RegWriteD_o(RegWriteD_o),
    .ResultSrcD_o(ResultSrcD_o),
    .MemWriteD_o(MemWriteD_o),
    .JumpD_o(JumpD_o),
    .BranchD_o(BranchD_o),
    .ALUControlD_o(ALUControlD_o),
    .ALUSrcD_o(ALUSrcD_o),
    .RD1D_o(RD1D_o),
    .RD2D_o(RD2D_o),
    .RdD_o(RdD_o),
    .ImmExtD_o(ImmExtD_o)
);

//Pipeline register between D and E
Pipeline_Regfile_DE Pipeline_Regfile_DE (
    //INPUT
    .clk(clk),
    .RegWriteD_i(RegWriteD_o),
    .ResultSrcD_i(ResultSrcD_o),
    .MemWriteD_i(MemWriteD_o),
    .JumpD_i(JumpD_o),
    .BranchD_i(BranchD_o),
    .ALUControlD_i(ALUControlD_o),
    .ALUSrcD_i(ALUSrcD_o),
    .RD1D_i(RD1D_o),
    .RD2D_i(RD2D_o),
    .RdD_i(RdD_o),
    .ImmExtD_i(ImmExtD_o),
    .PCD_i(PCD_o),
    .PCPlus4D_i(PCPlus4D_o),
    //OUTPUT
    .RegWriteE_o(RegWriteE_o),
    .ResultSrcE_o(ResultSrcE_o),
    .MemWriteE_o(MemWriteE_o),
    .JumpE_o(JumpE_o),
    .BranchE_o(BranchE_o),
    .ALUControlE_o(ALUControlE_o),
    .ALUSrcE_o(ALUSrcE_o),
    .RD1E_o(RD1E_o),
    .RD2E_o(RD2E_o),
    .RdE_o(RdE_o),
    .ImmExtE_o(ImmExtE_o),
    .PCE_o(PCE_o),
    .PCPlus4E_o(PCPlus4E_o)
);

//Execution pipeline stage
E   E (
    //INPUT
    .JumpE_i(JumpE_o),
    .BranchE_i(BranchE_o),
    .ALUControlE_i(ALUControlE_o),
    .ALUSrcE_i(ALUSrcE_o),
    .RD1E_i(RD1E_o),
    .RD2E_i(RD2E_o),
    .ImmExtE_i(ImmExtE_o),
    .PCE_i(PCE_o),
    //OUTPUT
    .PCSrcE_o(PCSrcE_o),
    .ALUResultE_o(ALUResultE_o),
    .WriteDataE_o(WriteDataE_o),
    .PCTargetE_o(PCTargetE_o)
);

//Pipeline register between E and M
Pipeline_Regfile_EM Pipeline_Regfile_EM (
    //INPUT
    .clk(clk),
    .RegWriteE_i(RegWriteE_o),
    .ResultSrcE_i(ResultSrcE_o),
    .MemWriteE_i(MemWriteE_o),
    .ALUResultE_i(ALUResultE_o),
    .WriteDataE_i(WriteDataE_o),
    .RdE_i(RdE_o),
    .PCPlus4E_i(PCPlus4E_o),
    //OUTPUT
    .RegWriteM_o(RegWriteM_o),
    .ResultSrcM_o(ResultSrcM_o),
    .MemWriteM_o(MemWriteM_o),
    .ALUResultM_o(ALUResultM_o),
    .WriteDataM_o(WriteDataM_o),
    .RdM_o(RdM_o),
    .PCPlus4M_o(PCPlus4M_o),
);

//Memory pipeline stage
M   M (
    //INPUT
    .clk(clk),
    .MemWriteM_i(MemWriteM_o),
    .ALUResultM_i(ALUResultM_o),
    .WriteDataM_i(WriteDataM_o),
    //OUTPUT
    .ALUResultM_o(ALUResultM_o),
    .ReadDataM_o(ReadDataM_o)
);

//Pipeline register between M and W
Pipeline_Regfile_MW Pipeline_Regfile_MW (
    //INPUT
    .clk(clk),
    .RegWriteM_i(RegWriteM_o),
    .ResultSrcM_i(ResultSrcM_o),
    .ALUResultM_i(ALUResultM_o),
    .ReadDataM_i(ReadDataM_o),
    .RdM_i(RdM_o),
    .PCPlus4M_i(PCPlus4M_i),
    //OUTPUT
    .ResultSrcW_o(ResultSrcW_o),
    .ALUResultW_o(ALUResultW_o),
    .ReadDataW_o(ReadDataW_o),
    .PCPlus4W_o(PCPlus4W_o)
);

//Write pipeline stage
W   W (
    //INPUT
    .ResultSrcW_i(ResultSrcW_o),
    .ALUResultW_i(ALUResultW_o),
    .ReadDataW_i(ReadDataW_o),
    .PCPlus4W_i(PCPlus4W_o),
    //OUTPUT
    .ResultW_o(ResultW_o)
);

//==========================================
endmodule
