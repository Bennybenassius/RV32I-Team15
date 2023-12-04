module Sign_extend #(
    parameter D_WIDTH = 32 // each instruction word is 32 bits
)(
    input logic [D_WIDTH-1:0]   instr,
    input logic                 ImmSrc,
    output logic [D_WIDTH-1:0]  ImmOp // after sign extention we get a 32 bit number
);

logic   [6:0]   op      = instr[6:0];
logic   [2:0]   funct3  = instr[14:12];

always_comb begin
    // // if the instruction is addi
    // if (ImmSrc & instr[6:0]==7'd19 & instr[14:12]==3'b0) // check the bits related to addi
    //     ImmOp <= {20'b0, instr[31:20]}; // sign extend accordingly

    // // if the instruction is bne
    // else if (ImmSrc & instr[6:0]==7'd99 & instr[14:12]==3'b1) // check the bits related to bne
    //     ImmOp <= {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // sign extend accordingly
    if (ImmSrc) begin
        case (op)
            7'd19   :   begin
                case (funct3)
                    3'b0    :   ImmOp = {20'b0, instr[31:20]};
                endcase
            end
            7'd99   :   begin
                case (funct3)
                    3'b1    :   ImmOp = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};    // sign extend accordingly
                endcase
            end
            7'd3    :   begin
                case (funct3)
                    3'b10   :   ImmOp = {{19{instr[31]}},instr[31: 20]};
                endcase
            end
            7'd35   :   begin
                case (funct3)
                    3'b10   :   ImmOp = {{19{instr[31]}},instr[31: 25],instr[11: 7]};
                endcase
            end
        endcase
    end
end



endmodule
