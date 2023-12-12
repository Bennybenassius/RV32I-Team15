module W (
    //INPUTS
    input logic  [1: 0]   ResultSrcW_i,
    input logic  [31: 0]  ALUResultW_i,
    input logic  [31: 0]  ReadDataW_i,
    input logic  [31: 0]  PCPlus4W_i,

    //OUTPUTS
    output logic [31: 0]  ResultW_o

);

always_comb begin
    case (ResultSrcW_i)
        2'b00: ResultW_o = ALUResultW_i;
        2'b01: ResultW_o = ReadDataW_i;
        2'b10: ResultW_o = PCPlus4W_i;
        default:;
    endcase
end

endmodule
