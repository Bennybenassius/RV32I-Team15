module Pipeline_Regfile_DE(
    //INPUTS
    input logic             clk,
    input logic             RegWriteD,
    input logic [1:0]       ResultSrcD,
    input logic             MemWriteD,
    input logic [1:0]       JumpD,
    input logic             BranchD,
    input logic [2:0]       ALUControlD,
    input logic             ALUSrcD,

    input logic [31:0]      RD1D,
    input logic [31:0]      RD2D,
    input logic [31:0]      PCD,
    input logic [4:0]       RdD,
    input logic [31:0]      ImmExtD,
    input logic [31:0]      PCPlus4D,

    //OUTPUTS
    output logic             RegWriteE,
    output logic [1:0]       ResultSrcE,
    output logic             MemWriteE,
    output logic [1:0]       JumpE,
    output logic             BranchE,
    output logic [2:0]       ALUControlE,
    output logic             ALUSrcE,
    
    output logic [31:0]      RD1E,
    output logic [31:0]      RD2E,
    output logic [31:0]      PCE,
    output logic [4:0]       RdE,
    output logic [31:0]      ImmExtE,
    output logic [31:0]      PCPlus4E
);

always_ff @(posedge clk) begin 
    RegWriteD <= RegWriteE;
    ResultSrcD <= ResultSrcE;
    MemWriteD <= MemWriteE;
    JumpD <= JumpE;
    BranchD <= BranchE;
    ALUControlD <= ALUControlE;
    ALUSrcD <= ALUSrcE;
    RD1D <= RD1E;
    RD2D <= RD2E;
    PCD <= PCE;
    RdD <= RdE;
    ImmExtD <= ImmExtE;
    PCPlus4D <= PCPlus4E;
end

endmodule
