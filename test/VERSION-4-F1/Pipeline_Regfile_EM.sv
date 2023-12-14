module Pipeline_Regfile_EM (
    //INPUTS
    input logic             clk,
    input logic             RegWriteE_i,
    input logic [1: 0]      ResultSrcE_i,
    input logic [2: 0]      MemWriteE_i,

    input logic [31:0]      ALUResultE_i,
    input logic [31:0]      WriteDataE_i,
    input logic [4: 0]      RdE_i,
    input logic [31:0]      PCPlus4E_i,

    //STALL
    input logic             EN,           //Active low enable signal 

    //OUTPUTS
    output logic            RegWriteM_o,
    output logic [1: 0]     ResultSrcM_o,
    output logic [2: 0]     MemWriteM_o,

    output logic [31:0]     ALUResultM_o_2_m,
    output logic [31:0]     ALUResultM_o_2_r,
    output logic [31:0]     WriteDataM_o, 
    output logic [4: 0]     RdM_o,
    output logic [31:0]     PCPlus4M_o
);

always_ff @(posedge clk) begin
    if (~EN) begin                        //if ~EN is high (Stall_M is low), update signals
        RegWriteM_o <= RegWriteE_i;
        ResultSrcM_o <= ResultSrcE_i;
        MemWriteM_o <= MemWriteE_i;
        ALUResultM_o_2_m <= ALUResultE_i;
        ALUResultM_o_2_r <= ALUResultE_i;
        WriteDataM_o <= WriteDataE_i;
        RdM_o <= RdE_i;
        PCPlus4M_o <= PCPlus4E_i;
    end
    else begin                            //if ~EN is low (Stall_M is high), STALL
        RegWriteM_o <= RegWriteM_o;
        ResultSrcM_o <= ResultSrcM_o;
        MemWriteM_o <= MemWriteM_o;
        ALUResultM_o_2_m <= ALUResultM_o_2_m;
        ALUResultM_o_2_r <= ALUResultM_o_2_r;
        WriteDataM_o <= WriteDataM_o;
        RdM_o <= RdM_o;
        PCPlus4M_o <= PCPlus4M_o;
    end
end

endmodule
