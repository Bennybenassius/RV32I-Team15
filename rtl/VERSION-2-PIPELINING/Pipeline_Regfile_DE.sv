module Pipeline_Regfile_DE(
    //INPUTS
    input logic             clk,
    input logic             RegWriteD_i,
    input logic [1: 0]      ResultSrcD_i,
    input logic [2: 0]      MemWriteD_i,
    input logic [1: 0]      JumpD_i,
    input logic             BranchD_i,
    input logic [2: 0]      ALUControlD_i,
    input logic             ALUSrcD_i,

    input logic [31:0]      RD1D_i,
    input logic [31:0]      RD2D_i,
    input logic [31:0]      PCD_i,
    input logic [4: 0]      RdD_i,
    input logic [31:0]      ImmExtD_i,
    input logic [31:0]      PCPlus4D_i,

    //OUTPUTS
    output logic            RegWriteE_o,
    output logic [1: 0]     ResultSrcE_o,
    output logic [2: 0]     MemWriteE_o,
    output logic [1: 0]     JumpE_o,
    output logic            BranchE_o,
    output logic [2: 0]     ALUControlE_o,
    output logic            ALUSrcE_o,
    
    output logic [31:0]     RD1E_o,
    output logic [31:0]     RD2E_o,
    output logic [31:0]     PCE_o,
    output logic [4: 0]     RdE_o,
    output logic [31:0]     ImmExtE_o,
    output logic [31:0]     PCPlus4E_o
);

always_ff @(posedge clk) begin 
    RegWriteE_o <= RegWriteD_i;
    ResultSrcE_o <= ResultSrcD_i;
    MemWriteE_o <= MemWriteD_i;
    JumpE_o <= JumpD_i;
    BranchE_o <= BranchD_i;
    ALUControlE_o <= ALUControlD_i;
    ALUSrcE_o <= ALUSrcD_i;
    RD1E_o <= RD1D_i;
    RD2E_o <= RD2D_i;
    PCE_o <= PCD_i;
    RdE_o <= RdD_i;
    ImmExtE_o <= ImmExtD_i;
    PCPlus4E_o <= PCPlus4D_i;
end

endmodule
