module W (
    //Input
    input logic [1: 0] ResultSrcW_i,
    input logic [31: 0] ALUResultW_i,
    input logic [31: 0] ReadDataW_i,
    input logic [31: 0] PCPlus4W_i,
    //Output
    output logic [31: 0]    ResultW_o

);

always_comb begin
    case (ResultSrcW_i) begin
        2'b00: Result_o = ALUResultW_i;
        2'b01: Result_o = ReadDataW_i;
        2'b01: Result_o = PCPlus4W_i;
        end
    endcase
    
end

endmodule
