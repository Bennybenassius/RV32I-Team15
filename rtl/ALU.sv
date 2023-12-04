module ALU(
    input   logic    [31:0]     ALUop1,      //operand 1 for ALU
    input   logic    [31:0]     ALUop2,      //operand 2 for ALU
    input   logic    [2:0]      ALUControl,     //ALU controls (func3)
    output  logic    [31:0]     ALUResult,      //ALU output
    output  logic               Zero
);

assign Zero = ALUout == 0;

always_comb begin
    case(ALUctrl)
        3'b000: ALUout = ALUop1 + ALUop2; //add
        3'b001: ALUout = ALUop1 << (ALUop2 & 5'b11111); //sll, shift left logical, 
        3'b010: ALUout = $signed(ALUop1) < $signed(Aluop2); //set less than signed
        3'b011: ALUout = ALUop1 < Aluop2; //set less than unsigned
        3'b100: ALUout = ALUop1 ^ ALUop2; //XOR
        3'b101: ALUout = ALUop1 >> (ALUop2 & 5'b11111); //srl, shift right logical, masked
        3'b110: ALUout = ALUop1 | AlUop2; // Or operation
        3'b111: ALUout = ALUop1 & ALUop2; //AND
    endcase
end
endmodule
