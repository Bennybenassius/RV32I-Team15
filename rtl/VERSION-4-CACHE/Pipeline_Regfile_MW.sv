module Pipeline_Regfile_MW(
    //INPUTS
    input logic             clk,
    input logic             RegWriteM_i,
    input logic [1:0]       ResultSrcM_i,

    input logic [31:0]      ALUResultM_i,
    input logic [31:0]      ReadDataM_i,
    input logic [4:0]       RdM_i,
    input logic [31:0]      PCPlus4M_i,

    //STALL
    input  logic             EN,        // Active low enable signal

    //OUTPUTS
    output logic             RegWriteW_o,
    output logic [1:0]       ResultSrcW_o,
    
    output logic [31:0]      ALUResultW_o,
    output logic [31:0]      ReadDataW_o,
    output logic [4:0]       RdW_o,
    output logic [31:0]      PCPlus4W_o
);

always_ff @(posedge clk) begin 
    if (~ EN) begin
        RegWriteW_o <= RegWriteM_i;
        ResultSrcW_o <= ResultSrcM_i;
        ALUResultW_o <= ALUResultM_i;
        ReadDataW_o <= ReadDataM_i;
        RdW_o <= RdM_i;
        PCPlus4W_o <= PCPlus4M_i;
    end
    else begin
        RegWriteW_o <= RegWriteW_o;
        ResultSrcW_o <= ResultSrcW_o;
        ALUResultW_o <= ALUResultW_o;
        ReadDataW_o <= ReadDataW_o;
        RdW_o <= RdW_o;
        PCPlus4W_o <= PCPlus4W_o;
    end
end

endmodule
