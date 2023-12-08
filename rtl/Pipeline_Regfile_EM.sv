module Pipeline_Regfile_EM (
    input logic             RegWriteE,
    input logic [1:0]       ResultSrcE,
    input logic             MemWriteE,

    input logic [31:0]      ALUResultE,
    input logic [31:0]      WriteDataE,
    input logic [31:0]      RdE,
    input logic [31:0]      PCPlus4E,

    output logic            RegWriteM,
    output logic [1:0]      ResultSrcM,
    output logic            MemWriteM,

    output logic [31:0]     ALUResultM,
    output logic [31:0]     WriteDataM, 
    output logic [31:0]     RdM,
    output logic [31:0]     PCPlus4M

)

always_ff @(posedge clk) begin
    RegWriteM <= RegWriteE;
    ResultSrcM <= ResultSrcE;
    MemWriteM <= MemWriteE;
    ALUResultM <= ALUResultE;
    WriteDataM <= WriteDataE;
    RdM <= RdE;
    PCPlus4M <= PCPlus4E;
end

endmodule