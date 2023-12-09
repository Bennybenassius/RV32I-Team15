module W (
    //Input
    input logic [1: 0] ResultSrc_i,
    input logic [31: 0] ALUResult_i,
    input logic [31: 0] ReadData_i,
    input logic [31: 0] PCPlus4_i,
    //Output
    output logic [31: 0]    Result_o

);

always_comb begin
    case (ResultSrc_i) begin
        2'b00: Result_o = ALUResult_i;
        2'b01: Result_o = ReadData_i;
        2'b01: Result_o = PCPlus4_i;
        end
    endcase
    
end

endmodule
