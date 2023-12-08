module ProgramCounter #(
    parameter WIDTH = 32
)(
    // INPUTS
    input logic                 clk,
    input logic                 rst, 
    input logic  [WIDTH-1: 0]   ImmExt, // is either 12 or 20 bits (I-type, U-type)
    input logic  [1:0]          PCSrc,
    input logic  [WIDTH-1: 0]   PCjalr,

    // OUTPUTS
    output logic [WIDTH-1: 0]   PCF,
    output logic [WIDTH-1: 0]   PCPlus4F
);

logic   [WIDTH-1:0] PCTarget    ;
logic   [WIDTH-1:0] PCNextF     ;


assign  PCPlus4F = PCF + 32'b100;
assign  PCTarget = ImmExt + PCF;

always_comb begin // 4 input MUX
    case (PCSrc)
        2'b00 :  PCNextF = PCPlus4F;
        2'b01 :  PCNextF = PCTarget;
        2'b10 :  PCNextF = PCjalr;
        default: PCNextF = PCPlus4F;
    endcase
end

always_ff @ (posedge clk, posedge rst)begin
    if (rst)    PCF <= 32'b0;
    PCF <= PCNextF;
end;

endmodule
