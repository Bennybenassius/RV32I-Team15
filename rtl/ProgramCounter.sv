module ProgramCounter #(
    parameter WIDTH = 32
)(
    input logic                 clk,
    input logic                 rst, 
    input logic  [WIDTH-1:0]    ImmOp, // is either 12 or 20 bits (I-type, U-type)
    input logic                 PCsrc,
    output logic [WIDTH-1:0]    PC_out
);

logic   [WIDTH-1:0] branch_PC   ;
logic   [WIDTH-1:0] next_PC     ;

assign  branch_PC = ImmOp + PC_out;
assign  next_PC = PCsrc ? branch_PC : PC_out + 32'b100;

always_ff @ (posedge clk, posedge rst)begin
    if (rst)    PC_out <= 32'b0;
    PC_out <= next_PC;
end;

endmodule
