module M(
    //INPUTS
    input logic           clk,
    input logic [2: 0]    MemWriteM_i,
    input logic [31:0]    ALUResultM_i,
    input logic [31:0]    WriteDataM_i,

    //OUTPUTS
    output logic [31:0]   ReadDataM_o

);
//=======================================

Data_mem Data_mem(
    //INPUTS
    .clk(clk),
    .WE(MemWriteM_i),
    .A(ALUResultM_i),
    .WD(WriteDataM_i),

    //OUTPUTS
    .RD(ReadDataM_o)
);

endmodule
