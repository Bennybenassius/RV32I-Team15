module ALU(
    input   logic    [31:0]     SrcA,      //operand 1 for ALU
    input   logic    [31:0]     SrcB,      //operand 2 for ALU
    input   logic    [2:0]      ALUControl,     //ALU controls (func3)
    
    output  logic    [31:0]     ALUResult,      //ALU output
    output  logic               Zero
);

assign Zero = (SrcA == SrcB);   //Flag for equals or not

always_comb begin
    case(ALUControl)
        3'b000: ALUResult = SrcA + SrcB;                                //add
        3'b001: ALUResult = SrcA << (SrcB & 32'b11111);                 //sll, shift left logical, 
        3'b010: ALUResult = {{31{1'b0}}, $signed(SrcA) < $signed(SrcB)};//set less than signed
        3'b011: ALUResult = {{31{1'b0}}, SrcA < SrcB};                  //set less than unsigned
        3'b100: ALUResult = SrcA ^ SrcB;                                //XOR
        3'b101: ALUResult = SrcA >> (SrcB & 32'b11111);                 //srl, shift right logical, masked
        3'b110: ALUResult = SrcA | SrcB;                                // Or operation
        3'b111: ALUResult = SrcA & SrcB;                                //AND
        default: ALUResult = 0;                                         // Handle unexpected ALUctrl values
    endcase
end
endmodule
