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
    output logic [WIDTH-1: 0]   PC,
    output logic [WIDTH-1: 0]   PCPlus4
);

logic   [WIDTH-1:0] PCTarget   ;
logic   [WIDTH-1:0] PCNext     ;


assign  PCPlus4 = PC + 32'b100;
assign  PCTarget = ImmExt + PC;

always_comb begin // 4 input MUX
    case (rst)
        1'b1:   PCNext = 0; 
        1'b0:   begin
            case (PCSrc)
                2'b00 :  PCNext = PCPlus4;
                2'b01 :  PCNext = PCTarget;
                2'b10 :  PCNext = PCjalr;
                default: PCNext = PCPlus4;
            endcase
        end
    endcase
end

always_ff @ (posedge clk)begin
    PC <= PCNext;
end;

endmodule
