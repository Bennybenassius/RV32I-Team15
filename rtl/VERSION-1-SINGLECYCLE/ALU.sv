module ALU(
    //INPUTS
    input   logic    [31:0]     SrcA,           //operand 1 for ALU
    input   logic    [31:0]     SrcB,           //operand 2 for ALU
    input   logic    [2:0]      ALUControl,     //ALU controls (func3)
    
    //OUTPUTS
    output  logic    [31:0]     ALUResult,      //ALU output
    output  logic    [1:0]      Zero
);

//assign Zero = (SrcA == SrcB);   //Flag for equals or not equal

logic [31: 0] cmp;
logic sign;
logic eq;

always_comb begin
    cmp = SrcA - SrcB;
    sign = (SrcA[31] == SrcB[31]);
    eq = (SrcA == SrcB);
    case (eq)                     //see if equal
        1'b1:   Zero = 2'b1;               //equal
        1'b0:   begin                       //not queal
            case(sign)     // see if same sign
                1'b1:   begin               // same sign
                    case(cmp[31])
                        1'b0:      Zero = 2'b11;        //different is postive
                        1'b1:      Zero = 2'b10;      //different is negetive
                    endcase
                end
                1'b0:   begin           // different sign
                    case(SrcA[31])
                        1'b0:   Zero = 2'b11;          // SrcA is postive, SrcB is negetive
                        1'b1:   Zero = 2'b10;          // SrcA is negetive, SrcB is postive
                    endcase
                end
            endcase
        end 
    endcase
end

always_comb begin
    case(ALUControl)
        3'b000: ALUResult = SrcA + SrcB;                                    // ADD
        3'b001: ALUResult = SrcA << (SrcB & 32'b11111);                     // SLL, shift left logical, 
        3'b010: ALUResult = {{31{1'b0}}, $signed(SrcA) < $signed(SrcB)};    // set less than signed
        3'b011: ALUResult = {{31{1'b0}}, SrcA < SrcB};                      // set less than unsigned
        3'b100: ALUResult = SrcA ^ SrcB;                                    // XOR
        3'b101: ALUResult = SrcA >> (SrcB & 32'b11111);                     // SRL, shift right logical, masked
        3'b110: ALUResult = SrcA | SrcB;                                    // OR operation
        3'b111: ALUResult = SrcA & SrcB;                                    // AND
        default: ALUResult = 0;                                             // Handle unexpected ALUctrl values
    endcase
end

endmodule
