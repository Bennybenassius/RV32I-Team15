module top#(

)(
    input   logic           clk,
    input   logic           rst,
    output  logic[31:0]     a0
);
//==========================================
//                 WIRE
logic [31:0]    Addr;

logic RegWrite;
logic ALUctrl;
logic ALUsrc;
logic ImmSrc;
logic PCsrc;
logic [31:0]    instr;
logic [31:0]    ImmOp;

logic EQ;

//==========================================
ProgramCounter ProgramCounter(
    //Input
    .clk(clk),
    .rst(rst),
    .ImmOp(ImmOp),
    .PCsrc(PCsrc),
    //Output
    .PC_out(Addr)
);

Control_unit Control_unit(
    //Input
    .EQ(EQ),
    .instr(instr),
    //Output
    .RegWrite(RegWrite),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc),
    .ImmSrc(ImmSrc),
    .PCsrc(PCsrc)
);

Instr_mem Instr_mem(
    //Input
    .A(Addr),
    //Output
    .RD(instr)
);

logic [4:0]     rs1 = instr[19:15];
logic [4:0]     rs2 = instr[24:20];
logic [4:0]     rd = instr[11:7];

ALU_RegFile ALU_RegFile(
    //Input
    .clk(clk),
    .RegWrite(RegWrite),
    .ALUsrc(ALUsrc),
    .ALUcrtl(ALUctrl),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .ImmOp(ImmOp),
    //Output
    .EQ(EQ),
    .a0(a0)
);

Sign_extend Sign_extend(
    //Input
    .instr(instr),
    .ImmSrc(ImmSrc),
    //Output
    .ImmOp(ImmOp)
);


// always_ff @(posedge clk) begin
//     $monitor("%t %m Addr: %h, instr: %h, a0: %h, RegWrite: %b, rs1: %b, rs2: %b, rd: %b, EQ: %b, PCsrc: %b, ImmOp: %h", $time, Addr, instr, a0, RegWrite, rs1, rs2, rd, EQ, PCsrc, ImmOp);
// end;

//==========================================
endmodule
