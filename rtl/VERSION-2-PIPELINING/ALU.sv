module ALU(
    //INPUTS
    input   logic    [31:0]     SrcAE,           //operand 1 for ALU
    input   logic    [31:0]     SrcBE,           //operand 2 for ALU
    input   logic    [2:0]      ALUControlE,     //ALU controls (func3)
    
    //OUTPUTS
    output  logic    [31:0]     ALUResultE,      //ALU output
    output  logic               ZeroE
);

assign ZeroE = (SrcAE == SrcBE);   //Flag for equals or not equal

always_comb begin
    case(ALUControlE)
        3'b000: ALUResultE = SrcAE + SrcBE;                                    // ADD
        3'b001: ALUResultE = SrcAE << (SrcBE & 32'b11111);                     // SLL, shift left logical, 
        3'b010: ALUResultE = {{31{1'b0}}, $signed(SrcAE) < $signed(SrcBE)};    // set less than signed
        3'b011: ALUResultE = {{31{1'b0}}, SrcAE < SrcBE};                      // set less than unsigned
        3'b100: ALUResultE = SrcAE ^ SrcBE;                                    // XOR
        3'b101: ALUResultE = SrcAE >> (SrcBE & 32'b11111);                     // SRL, shift right logical, masked
        3'b110: ALUResultE = SrcAE | SrcBE;                                    // OR operation
        3'b111: ALUResultE = SrcAE & SrcBE;                                    // AND
        default: ALUResultE = 0;                                               // Handle unexpected ALUctrl values
    endcase
end
endmodule
