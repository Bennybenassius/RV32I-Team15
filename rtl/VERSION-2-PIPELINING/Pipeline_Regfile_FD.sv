module Pipeline_Regfile_FD(
    //INPUTS
    input logic             clk,
    input logic  [31:0]     InstrF,
    input logic             PCF,
    input logic             PCPlus4F,

    //OUTPUTS
    output logic [31:0]      InstrD,
    output logic [31:0]      PCD,
    output logic [31:0]      PCPlus4D,
);

always_ff @(posedge clk) begin 
    InstrD <= InstrF;
    PCD <= PCF;
    PCPlus4F <= PCPlus4D;
end

endmodule
