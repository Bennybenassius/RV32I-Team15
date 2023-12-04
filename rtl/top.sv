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
logic [31: 0]    instr;
logic [31: 0]    ImmOp;

logic EQ;

logic [31: 0]   WriteData;
logic [31: 0]   ALUResult;
logic [31: 0]   ReadData;
logic [31: 0]   Result;

logic MemWrite;
logic ResultSrc;
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

Data_control Data_control(
    //Input
    .EQ(EQ),
    .instr(instr),
    //Output
    .RegWrite(RegWrite),
    .ALUctrl(ALUctrl),
    .ALUsrc(ALUsrc),
    .ImmSrc(ImmSrc),
    .PCsrc(PCsrc),

    .MemWrite(MemWrite),
    .ResultSrc(ResultSrc)
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
    .WD3(Result),
    //Output
    .EQ(EQ),
    .ALUout(ALUResult),
    .a0(a0),
    .RD2(WriteData)
);

Sign_extend Sign_extend(
    //Input
    .instr(instr),
    .ImmSrc(ImmSrc),
    //Output
    .ImmOp(ImmOp)
);

Data_mem Data_mem(
    //Input
    .clk(clk),
    .WE(MemWrite),
    .A(ALUResult),
    .WD(WriteData),
    //Output
    .RD(ReadData)
);

always_comb begin
    if (ResultSrc) Result = ReadData;
    else Result = ALUResult;
end;

// always_ff @(posedge clk) begin
//     $monitor("%t %m Addr: %h, instr: %h, a0: %h, RegWrite: %b, rs1: %b, rs2: %b, rd: %b, EQ: %b, PCsrc: %b, ImmOp: %h", $time, Addr, instr, a0, RegWrite, rs1, rs2, rd, EQ, PCsrc, ImmOp);
// end;

//==========================================
endmodule
