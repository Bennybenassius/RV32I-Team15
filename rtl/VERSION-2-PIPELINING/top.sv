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
logic [31:0]    Addr;

logic           RegWrite;
logic [2: 0]    ALUControl;
logic           ALUSrc;
logic [1: 0]    ImmSrc;
logic [1: 0]    PCSrc;
logic [31: 0]   instr;
logic [31: 0]   ImmExt;

logic   [6:0]   op      = instr[6:0];
logic   [2:0]   funct3  = instr[14:12];
logic           funct7  = instr[30];

logic           Zero;

logic [31: 0]   WriteData;
logic [31: 0]   ALUResult;
logic [31: 0]   ReadData;
logic [31: 0]   Result;

logic [31: 0]   PCPlus4;
logic [2: 0]    MemWrite;
logic [1: 0]    ResultSrc;

//==========================================
ProgramCounter ProgramCounter(
    //INPUTS
    .clk(clk),
    .rst(rst),
    .ImmExt(ImmExt),
    .PCSrc(PCSrc),
    .PCjalr(ALUResult),

    //OUTPUTS
    .PC(Addr),
    .PCPlus4(PCPlus4)
);

Control_unit Control_unit(
    //INPUTS
    .op(op),
    .funct3(funct3),
    .funct7(funct7),

    //OUTPUTS
    .RegWrite(RegWrite),
    .ResultSrc(ResultSrc)
    .MemWrite(MemWrite),
    .ALUControl(ALUControl),
    .ALUSrc(ALUSrc),
    .ImmSrc(ImmSrc),
);

Instr_mem Instr_mem(
    //INPUTS
    .A(Addr),

    //OUTPUTS
    .RD(instr)
);

logic [4:0]     rs1 = instr[19:15];
logic [4:0]     rs2 = instr[24:20];
logic [4:0]     rd = instr[11:7];

ALU_RegFile ALU_RegFile(
    //INPUTS
    .clk(clk),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .ALUControl(ALUControl),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .ImmOp(ImmExt),
    .WD3(Result),
    .trigger(trigger),

    //OUTPUTS
    .Zero(Zero),
    .ALUResult(ALUResult),
    .a0(a0),
    .WriteData(WriteData)
);

Sign_extend Sign_extend(
    //INPUTS
    .instr(instr),
    .ImmSrc(ImmSrc),

    //OUTPUTS
    .ImmExt(ImmExt)
);

Data_mem Data_mem(
    //INPUTS
    .clk(clk),
    .WE(MemWrite),
    .A(ALUResult),
    .WD(WriteData),

    //OUTPUTS
    .RD(ReadData)
);

always_comb begin
    case (ResultSrc)
        2'b0    :   Result = ALUResult;
        2'b1    :   Result = ReadData;
        2'b10   :   Result = PCPlus4;
        default: Result = ALUResult;
    endcase  
    
end;

//==========================================
endmodule
