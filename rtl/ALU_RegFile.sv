module ALU_RegFile(
    input   logic             clk,        //clock
    input   logic             RegWrite,   //read register write enable
    input   logic             ALUSrc,     //Mux input between rs2 and Imm
    input   logic   [2:0]     ALUControl,     //ALU controls (func3)
    input   logic   [4:0]     rs1,        //rs1 register addr
    input   logic   [4:0]     rs2,        //rs2 register addr
    input   logic   [4:0]     rd,         //register destination
    input   logic   [31: 0]   WD3,        //write data
    input   logic   [31:0]    ImmOp,      //Immediate Operand

    output  logic             Zero,         //ALU output if operands are equal
    output  logic   [31:0]    a0,         //Output a0
    output  logic   [31: 0]   WriteData,
    output  logic   [31: 0]   ALUResult
);


logic   [31:0]  SrcA;
logic   [31:0]  regOp2;
logic   [31:0]  SrcB;

RegFile myRegFile (
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .RegWrite(RegWrite),
    .WD3(WD3),
    .RD1(SrcA),
    .RD2(regOp2),
    .a0(a0)
);

always_comb begin
    WriteData = regOp2;
end

//2MUX
assign SrcB = ALUSrc ? ImmOp : regOp2;

ALU myALU(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);


endmodule
