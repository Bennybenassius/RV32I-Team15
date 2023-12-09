module ALU(
    //INPUTS
    input   logic    [31:0]     SrcAE,           //operand 1 for ALU
    input   logic    [31:0]     SrcBE,           //operand 2 for ALU
    input   logic    [2:0]      ALUControlE,     //ALU controls (func3)
    
    //OUTPUTS
    output  logic    [31:0]     ALUResultE,      //ALU output
    output  logic    [1:0]      ZeroE
);

//assign Zero = (SrcA == SrcB);   //Flag for equals or not equal

logic [31: 0] cmp;
logic sign;
logic eq;

always_comb begin
    cmp = SrcAE - SrcBE;
    sign = (SrcAE[31] == SrcBE[31]);
    eq = (SrcAE == SrcBE);
    case (eq)                                       //see if equal
        1'b1:   ZeroE = 2'b01;                          //equal, a = b
        1'b0:   begin                                   //not equal
            case(sign)                              //see if same sign
                1'b1:   begin                           // same sign
                    case(cmp[31])
                        1'b0:   ZeroE = 2'b10;               //difference is postive, a > b
                        1'b1:   ZeroE = 2'b00;               //difference is negetive, a < b
                    endcase
                end
                1'b0:   begin                           // different sign
                    case(SrcAE[31])
                        1'b0:   ZeroE = 2'b10;               // SrcAE is postive, SrcBE is negetive, a > b
                        1'b1:   ZeroE = 2'b00;               // SrcAE is negetive, SrcBE is postive, a < b
                    endcase
                end
            endcase
        end 
    endcase
end

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
