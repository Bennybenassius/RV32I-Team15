module Control_unit_ #(
    parameter D_WIDTH = 32
)(  
    //Input
    input logic [D_WIDTH-1:0]   instr, // instruction is 32 bits long
    input logic                 EQ,

    //Output
    output logic                RegWrite,
    output logic                ALUctrl,
    output logic                ALUsrc,
    output logic                ImmSrc,
    output logic                PCsrc
);

logic   [6:0]   op      = instr[6:0];
logic   [2:0]   funct3  = instr[14:12];

always_comb begin
    // // if the instruction is addi
    // if (instr[6:0]==7'd19 & instr[14:12]==3'b0) begin
    //     RegWrite = 1'b1; // if addi then we want to write to destination reg
    //     ALUctrl = 1'b1; // in the ALU we defined 1 for add and 0 for subtract
    //     ALUsrc = 1'b1; // need to add with imm
    //     ImmSrc = 1'b1; // need to sign extend the imm to make it 32 bits
    //     PCsrc = 1'b0; // no branching
    // end

    // // if the instruction is bne
    // else if (instr[6:0]==7'd99 & instr[14:12]==3'b1) 
    //     if(~EQ) begin // in the ALU we defined EQ=1 as equal and EQ=0 as not equal
    //         RegWrite = 1'b0; // not writing to any reg
    //         ALUctrl = 1'b0; // need subtraction to calc branch target addr
    //         ALUsrc = 1'b0; // not using imm, need both operands coming from reg
    //         ImmSrc = 1'b1; // need to sign extend the branch target address
    //         PCsrc = 1'b1; // need branching
    //     end
    
    case (op)
        7'd19   :   begin
            case (funct3)
                3'b000    :   begin
                    RegWrite = 1'b1; // if addi then we want to write to destination reg
                    ALUctrl = 1'b1; // in the ALU we defined 1 for add and 0 for subtract
                    ALUsrc = 1'b1; // need to add with imm
                    ImmSrc = 1'b1; // need to sign extend the imm to make it 32 bits
                    PCsrc = 1'b0; // no branching
                end
            endcase
        end
        7'd99   :   begin
            case (funct3)
                3'b001    :  begin      //bne instruction
                    RegWrite = 1'b0; // not writing to any reg
                    ALUctrl = 1'b0; // need subtraction to calc branch target addr
                    ALUsrc = 1'b0; // not using imm, need both operands coming from reg
                    ImmSrc = 1'b1; // need to sign extend the branch target address
                    case(EQ)
                        1'b0    :   begin 
                            PCsrc = 1'b1; // need branching
                        end
                    endcase
                end
            endcase
        end
    endcase
end

endmodule
