module ALU(
    input   logic    [31:0]     ALUop1,      //operand 1 for ALU
    input   logic    [31:0]     ALUop2,      //operand 2 for ALU
    input   logic               ALUcrtl,     //ALU controls
    output  logic    [31:0]     ALUout,      //ALU output
    output  logic               EQ           //Whether operands are equal
);

assign ALUout = ALUcrtl ? (ALUop1 + ALUop2) : (ALUop1 - ALUop2);

assign EQ = (ALUop1 == ALUop2);   //Flag for equals or not
    
endmodule
