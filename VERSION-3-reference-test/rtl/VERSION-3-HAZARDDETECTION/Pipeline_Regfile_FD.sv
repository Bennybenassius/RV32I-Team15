module Pipeline_Regfile_FD(
    //INPUTS
    input  logic             clk,
    input  logic [31:0]      InstrF_i,
    input  logic [31:0]      PCF_i,
    input  logic [31:0]      PCPlus4F_i,

    //STALL
    input  logic             EN,        // Active low enable signal
    //FLUSH
    input  logic             CLR,       // synchronous  reset/clear signal

    //OUTPUTS
    output logic [31:0]      InstrD_o,
    output logic [31:0]      PCD_o,
    output logic [31:0]      PCPlus4D_o
);

always_ff @(posedge clk) begin 
    // STALL
    if (~EN) begin                  // if ~EN is high (StallD is low), update signals 
        InstrD_o <= InstrF_i;
        PCD_o <= PCF_i;
        PCPlus4D_o <= PCPlus4F_i;
    end
    else begin                      // if ~EN is low (StaffD is high), STALL 
        InstrD_o <= InstrD_o;
        PCD_o <= PCD_o;
        PCPlus4D_o <= PCPlus4D_o;
    end

    // FLUSH
    if (CLR) begin                  // if CLR is high, FLUSH
        InstrD_o <= 32'h13;         // nop instr
        PCD_o <= 32'b0;
        PCPlus4D_o <= 32'b0;
    end
    else begin                      // if CLR is low, update signals
        InstrD_o <= InstrF_i;
        PCD_o <= PCF_i;
        PCPlus4D_o <= PCPlus4F_i;
    end
end

endmodule
