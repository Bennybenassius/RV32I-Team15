module ALU_RegFile(
    input   logic             clk,        //clock
    input   logic             RegWrite,   //read register write enable
    input   logic             ALUsrc,     //Mux input between rs2 and Imm
    input   logic             ALUcrtl,    //ALU controls
    input   logic   [4:0]     rs1,        //rs1 register addr
    input   logic   [4:0]     rs2,        //rs2 register addr
    input   logic   [4:0]     rd,         //register destination
    input   logic   [31: 0]   WD3,        //write data
    input   logic   [31:0]    ImmOp,      //Immediate Operand
    output  logic             EQ,         //ALU output if operands are equal
    output  logic   [31:0]    a0,         //Output a0
    output  logic   [31: 0]   RD2,
    output  logic   [31: 0]   ALUout
);


logic   [31:0]  ALUop1;
logic   [31:0]  regOp2;
logic   [31:0]  ALUop2;

RegFile myRegFile (
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .RegWrite(RegWrite),
    .WD3(WD3),
    .ALUop1(ALUop1),
    .regOp2(regOp2),
    .a0(a0)
);
always_comb begin
    RD2 = regOp2;
end

//2MUX
assign ALUop2 = ALUsrc ? ImmOp : regOp2;

ALU myALU(
    .ALUop1(ALUop1),
    .ALUop2(ALUop2),
    .ALUcrtl(ALUcrtl),
    .ALUout(ALUout),
    .EQ(EQ)
);


endmodule
