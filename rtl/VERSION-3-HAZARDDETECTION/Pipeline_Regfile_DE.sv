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

    //FORWARDING INPUTS
    input logic [4:0]       Rs1D_i,
    input logic [4:0]       Rs2D_i,

    //FLUSH
    input logic             CLR,          // synchronous reset/clear signal

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
    output logic [31:0]     PCPlus4E_o,

    //FORDWARDING OUTPUTS
    output logic [4:0]      Rs1E_o,
    output logic [4:0]      Rs2E_o
);

always_ff @(posedge clk) begin 
    //FLUSH
    if (CLR) begin                     // if CLR is high, FLUSH
        RegWriteE_o <= 1'b0;
        ResultSrcE_o <= 2'b0;
        MemWriteE_o <= 3'b0;
        JumpE_o <= 2'b0;
        BranchE_o <= 1'b0;
        ALUControlE_o <= 3'b0;
        ALUSrcE_o <= 1'b0;
        RD1E_o <= 32'b0;
        RD2E_o <= 32'b0;
        PCE_o <= 32'b0;
        RdE_o <= 5'b0;
        ImmExtE_o <= 32'b0;
        PCPlus4E_o <= 32'b0;

        //FORWARDING
        Rs1E_o <= 5'b0;
        Rs2E_o <= 5'b0;
    end
    else begin                         // if CLR is low, update signals
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

        //FORWARDING
        Rs1E_o <= Rs1D_i;
        Rs2E_o <= Rs2D_i;        
    end
end

endmodule
