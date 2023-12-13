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
//Wires coming out of F stage
logic   [1: 0]  PCSrcE_o;
logic   [31:0]  PCTargetE_o;
logic   [31:0]  ALUResultE_o;
logic   [31:0]  PCF_o;
logic   [31:0]  PCPlus4F_o;
logic   [31:0]  InstrF_o;

//Wires coming out of FD pipeline register
logic   [31:0]  InstrD_o;
logic   [31:0]  PCD_o;
logic   [31:0]  PCPlus4D_o;

//Wires coming out of D stage
logic           RegWriteW_o;
logic   [4: 0]  RdW_o;
logic   [31:0]  ResultW_o;
logic           RegWriteD_o;
logic   [1: 0]  ResultSrcD_o;
logic   [2: 0]  MemWriteD_o;
logic   [1: 0]  JumpD_o;
logic           BranchD_o;
logic   [2: 0]  ALUControlD_o;
logic           ALUSrcD_o;
logic   [31:0]  RD1D_o;
logic   [31:0]  RD2D_o;
logic   [4: 0]  RdD_o;
logic   [31:0]  ImmExtD_o;
//HAZARD
logic   [4:0]   Rs1D_o;
logic   [4:0]   Rs2D_o;

//Wires coming out of DE pipeline register
logic           RegWriteE_o;
logic   [1: 0]  ResultSrcE_o;
logic   [2: 0]  MemWriteE_o;
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
//HAZARD
logic   [4:0]   Rs1E_o;
logic   [4:0]   Rs2E_o;

//Wires coming out of E stage
logic   [31:0]  WriteDataE_o;

//Wires coming out of EM pipeline register
logic           RegWriteM_o;
logic   [1: 0]  ResultSrcM_o;
logic   [2: 0]  MemWriteM_o;
logic   [31:0]  ALUResultM_o_2_r;
logic   [31:0]  ALUResultM_o_2_m;
logic   [31:0]  WriteDataM_o;
logic   [4: 0]  RdM_o;
logic   [31:0]  PCPlus4M_o;

//Wires coming out of M stage
logic   [31:0]  ReadDataM_o;

//Wire coming out of MW pipeline register
logic   [1: 0]  ResultSrcW_o;
logic   [31:0]  ALUResultW_o;
logic   [31:0]  ReadDataW_o;
logic   [31:0]  PCPlus4W_o;

//HAZARD 
//Wire coming out of Hazard Unit
logic            StallF_o;
logic            StallD_o;
logic            FlushD_o;
logic            FlushE_o;
logic   [1:0]    ForwardAE_o;
logic   [1:0]    ForwardBE_o;

//CACHE
logic            StallAllM_o;

//STALL
logic            Stall_F;
logic            Stall_D;
logic            Stall_E;
logic            Stall_M;
logic            Stall_W;
//==========================================
//                  MODULES

//Fetching pipeline stage
F   F(
    //INPUTS
    .clk(clk),
    .rst(rst),
    .PCSrcE_i(PCSrcE_o),
    .PCTargetE_i(PCTargetE_o),
    .ALUResultE_i(ALUResultE_o),
    //HAZARD
    .EN(Stall_F),

    //OUTPUTS
    .PCF_o(PCF_o),
    .PCPlus4F_o(PCPlus4F_o),
    .InstrF_o(InstrF_o)

);

//Pipeline register between F and D
Pipeline_Regfile_FD Pipeline_Regfile_FD (
    //INPUTSS
    .clk(clk),
    .InstrF_i(InstrF_o),
    .PCF_i(PCF_o),
    .PCPlus4F_i(PCPlus4F_o),
    //HAZARD
    .EN(Stall_D),
    .CLR(FlushD_o),

    //OUTPUTS
    .InstrD_o(InstrD_o),
    .PCD_o(PCD_o),
    .PCPlus4D_o(PCPlus4D_o)
);

//Decode pipeline stage
D   D (
    //INPUTS
    .clk(clk),
    .RegWriteW_i(RegWriteW_o),
    .InstrD_i(InstrD_o),
    .RdW_i(RdW_o),
    .ResultW_i(ResultW_o),
    .trigger_i(trigger),

    //OUTPUTS
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
    .ImmExtD_o(ImmExtD_o),
    .a0(a0),
    //HAZARD
    .Rs1D_o(Rs1D_o),
    .Rs2D_o(Rs2D_o)
);

//Pipeline register between D and E
Pipeline_Regfile_DE Pipeline_Regfile_DE (
    //INPUTS
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
    //HAZARD
    .Rs1D_i(Rs1D_o),
    .Rs2D_i(Rs2D_o),
    .CLR(FlushE_o),
    //STALL
    .EN(Stall_E),

    //OUTPUTS
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
    .PCPlus4E_o(PCPlus4E_o),
    //HAZARD
    .Rs1E_o(Rs1E_o),
    .Rs2E_o(Rs2E_o)
);

//Execution pipeline stage
E   E (
    //INPUTS
    .JumpE_i(JumpE_o),
    .BranchE_i(BranchE_o),
    .ALUControlE_i(ALUControlE_o),
    .ALUSrcE_i(ALUSrcE_o),
    .RD1E_i(RD1E_o),
    .RD2E_i(RD2E_o),
    .ImmExtE_i(ImmExtE_o),
    .PCE_i(PCE_o),
    //HAZARD
    .ALUResultM_i_me(ALUResultM_o_2_m),
    .ResultW_i_we(ResultW_o),
    .ForwardAE(ForwardAE_o),
    .ForwardBE(ForwardBE_o),

    //OUTPUTS
    .PCSrcE_o(PCSrcE_o),
    .ALUResultE_o(ALUResultE_o),
    .WriteDataE_o(WriteDataE_o),
    .PCTargetE_o(PCTargetE_o)
);

//Pipeline register between E and M
Pipeline_Regfile_EM Pipeline_Regfile_EM (
    //INPUTS
    .clk(clk),
    .RegWriteE_i(RegWriteE_o),
    .ResultSrcE_i(ResultSrcE_o),
    .MemWriteE_i(MemWriteE_o),
    .ALUResultE_i(ALUResultE_o),
    .WriteDataE_i(WriteDataE_o),
    .RdE_i(RdE_o),
    .PCPlus4E_i(PCPlus4E_o),
    //STALL
    .EN(Stall_M),

    //OUTPUTS
    .RegWriteM_o(RegWriteM_o),
    .ResultSrcM_o(ResultSrcM_o),
    .MemWriteM_o(MemWriteM_o),
    .ALUResultM_o_2_r(ALUResultM_o_2_r),
    .ALUResultM_o_2_m(ALUResultM_o_2_m),
    .WriteDataM_o(WriteDataM_o),
    .RdM_o(RdM_o),
    .PCPlus4M_o(PCPlus4M_o)
);

//Memory pipeline stage
M_cache M_cache(
    //INPUTS
    .clk(clk),
    .MemWriteM_i(MemWriteM_o),
    .ALUResultM_i(ALUResultM_o_2_m),
    .WriteDataM_i(WriteDataM_o),
    .EN(ResultSrcM_o[0]),

    //OUTPUTS
    .ReadDataM_o(ReadDataM_o),
    .StallAllM_o(StallAllM_o)
);

//Pipeline register between M and W
Pipeline_Regfile_MW Pipeline_Regfile_MW (
    //INPUTS
    .clk(clk),
    .RegWriteM_i(RegWriteM_o),
    .ResultSrcM_i(ResultSrcM_o),
    .ALUResultM_i(ALUResultM_o_2_r),
    .ReadDataM_i(ReadDataM_o),
    .RdM_i(RdM_o),
    .PCPlus4M_i(PCPlus4M_o),
    //STALL
    .EN(Stall_W),
    
    //OUTPUTS
    .RegWriteW_o(RegWriteW_o),
    .ResultSrcW_o(ResultSrcW_o),
    .ALUResultW_o(ALUResultW_o),
    .ReadDataW_o(ReadDataW_o),
    .PCPlus4W_o(PCPlus4W_o),
    .RdW_o(RdW_o)
);

//Write pipeline stage
W   W (
    //INPUTS
    .ResultSrcW_i(ResultSrcW_o),
    .ALUResultW_i(ALUResultW_o),
    .ReadDataW_i(ReadDataW_o),
    .PCPlus4W_i(PCPlus4W_o),

    //OUTPUTS
    .ResultW_o(ResultW_o)
);

//Hazard unit
Hazard Hazard (
    //INPUTS
    .Rs1D_i_dh(Rs1D_o),
    .Rs2D_i_dh(Rs2D_o),
    .Rs1E_i_eh(Rs1E_o),
    .Rs2E_i_eh(Rs2E_o),
    .RdE_i_eh(RdE_o),
    .PCSrcE_i_eh(PCSrcE_o),
    .ResultSrcE_i_eh(ResultSrcE_o[0]),      // LSB of ResultSrcE_o (tells if writing back data from data_mem)
    .RdM_i_mh(RdM_o),
    .RegWriteM_i_mh(RegWriteM_o),
    .RdW_i_wh(RdW_o),
    .RegWriteW_i_wh(RegWriteW_o),

    //OUTPUTS
    .StallF_o(StallF_o),
    .StallD_o(StallD_o),
    .FlushD_o(FlushD_o),
    .FlushE_o(FlushE_o),
    .ForwardAE_o(ForwardAE_o),
    .ForwardBE_o(ForwardBE_o)
);

//Stall unit
Stall Stall(
    //INPUTS
    .StallAllM_i(StallAllM_o),
    .StallF_i(StallF_o),
    .StallD_i(StallD_o),

    //OUTPUTS
    .Stall_F(Stall_F),
    .Stall_D(Stall_D),
    .Stall_E(Stall_E),
    .Stall_M(Stall_M),
    .Stall_W(Stall_W)
);

//==========================================
endmodule
