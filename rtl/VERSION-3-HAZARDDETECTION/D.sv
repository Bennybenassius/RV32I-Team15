module D (
    //Input
    input logic             clk,
    input logic     [31:0]  InstrD_i,
    input logic     [31:0]  ResultW_i,
    input logic     [4: 0]  RdW_i,
    input logic             RegWriteW_i,
    input logic             trigger_i,
    //Output
    output logic            RegWriteD_o,
    output logic    [1: 0]  ResultSrcD_o,
    output logic    [2: 0]  MemWriteD_o,
    output logic    [1: 0]  JumpD_o,
    output logic            BranchD_o,
    output logic    [2: 0]  ALUControlD_o,
    output logic            ALUSrcD_o,

    output logic    [31:0]  RD1D_o,
    output logic    [31:0]  RD2D_o,
    output logic    [4: 0]  RdD_o,
    output logic    [31:0]  ImmExtD_o,

    output  logic   [31:0]  a0

    //FORWARDING
    output logic   [15:19] Rs1D_o;
    output logic   [20:24] Rs2D_o;

);

logic   [6: 0]    op;
logic   [2: 0]    funct3;
logic             funct7;
logic   [4: 0]    A1;
logic   [4: 0]    A2;
logic   [4: 0]    A3;
logic   [31:0]    WD3;
logic   [4: 0]    RdD;
logic   [31:0]    Instr;
logic   [1: 0]    ImmSrc;

always_comb begin
    op = InstrD_i[6: 0];
    funct3 = InstrD_i[14: 12];
    funct7 = InstrD_i[30];
    A1 = InstrD_i[19: 15];
    A2 = InstrD_i[24: 20];
    A3 = RdW_i;
    WD3 = ResultW_i;
    RdD = InstrD_i[11: 7];
    RdD_o = RdD;
    Instr = InstrD_i;
    Rs1D_o = InstrD_i[19:15];
    Rs2D_o = InstrD_i[24:20];
end

Control_unit    Control_unit(
    //Input
    .op(op),
    .funct3(funct3),
    .funct7(funct7),

    //Output
    .RegWriteD(RegWriteD_o),
    .ResultSrcD(ResultSrcD_o),
    .MemWriteD(MemWriteD_o),
    .JumpD(JumpD_o),
    .BranchD(BranchD_o),
    .ALUControlD(ALUControlD_o),
    .ALUSrcD(ALUSrcD_o),
    .ImmSrcD(ImmSrc)
);

RegFile RegFile(
    //Input
    .clk(clk),
    .RegWrite(RegWriteW_i),
    .rs1(A1),
    .rs2(A2),
    .rd(A3),
    .WD3(WD3),
    .trigger(trigger_i),

    //Output
    .RD1D(RD1D_o),
    .RD2D(RD2D_o),
    .a0(a0)
);

Sign_extend     Extend(
    //INput
    .instrD(Instr),
    .ImmSrcD(ImmSrc),

    //Output
    .ImmExtD(ImmExtD_o)
);

endmodule
