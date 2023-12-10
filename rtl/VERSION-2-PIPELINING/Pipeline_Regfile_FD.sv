module Pipeline_Regfile_FD(
    //INPUTS
    input logic             clk,
    input logic  [31:0]     InstrF_i,
    input logic  [31:0]     PCF_i,
    input logic  [31:0]     PCPlus4F_i,

    //OUTPUTS
    output logic [31:0]      InstrD_o,
    output logic [31:0]      PCD_o,
    output logic [31:0]      PCPlus4D_o,
);

always_ff @(posedge clk) begin 
    InstrD_o <= InstrF_i;
    PCD_o <= PCF_i;
    PCPlus4F_o <= PCPlus4D_i;
end

endmodule
