module Pipeline_Regfile_MW(
    input logic             clk,
    input logic             RegWriteM,
    input logic [1:0]       ResultSrcM,

    input logic [31:0]            RdM,
    input logic [31:0]            PCPlus4M,
    input logic [31:0]            ALUResultM,
    input logic [31:0]            RDM,

    output logic             RegWriteW,
    output logic [1:0]       ResultSrcW,
    
    output logic [31:0]            RdW,
    output logic [31:0]            PCPlus4W,
    output logic [31:0]            ALUResultW,
    output logic [31:0]            RDW
);

always_ff @(posedge clk) begin 
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
    RdW <= RdM;
    PCPlus4W <= PCPlus4M;
    ALUResultW <= ALUResultM;
    RDW <= RDM;
end

endmodule
