module Sign_extend #(
    parameter D_WIDTH = 32
)(
    //INPUTS
    input logic [D_WIDTH-1:0]   instr,
    input logic [1:0]           ImmSrc,

    //OUTPUTS
    output logic [D_WIDTH-1:0]  ImmExt // after sign extention we get a 32 bit number
);

logic   [6:0]   op      = instr[6:0];
logic   [2:0]   funct3  = instr[14:12];

always_comb begin
    case (ImmSrc) 
        2'b0 : begin    // not sign extending
            ImmExt = 0; 
        end

        2'b1 : begin    // 32 bit sign extend
            case (op)
                7'd19   :   begin   // if the instruction is addi
                    case (funct3)
                        3'b0    :   ImmExt = {{20{instr[31]}}, instr[31:20]};
                        default :   ImmExt = 32'b0;
                    endcase
                end
                7'd99   :   begin   // if the instruction is bne
                    case (funct3)
                        3'b1    :   ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};    // sign extend accordingly
                        default :   ImmExt = 32'b0;
                    endcase
                end             
                7'd3    :   begin   //load word
                    case (funct3)
                        3'b10   :   ImmExt = {{20{instr[31]}},instr[31: 20]};
                        default :   ImmExt = 32'b0;
                    endcase
                end
                7'd35   :   begin   //store word 
                    case (funct3)
                        3'b10   :   ImmExt = {{20{instr[31]}},instr[31: 25],instr[11: 7]};
                        default :   ImmExt = 32'b0;
                    endcase
                end
                7'd103  :   begin   //jalr
                    case (funct3)
                        3'b0    :   ImmExt = {{20{instr[31]}},instr[31:20]};
                        default :   ImmExt = 32'b0;
                    endcase
                end
                7'd111  :   begin   //jal
                    ImmExt = {{11{instr[31]}} ,instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
                end
                default :   ImmExt = 32'b0;
            endcase
        end
        default  :  ImmExt = 32'b0;
        // 2'b10 : begin   // byte extend
        
        // end

        // 2'b11 : begin   // zero extend

        // end
    endcase
end


endmodule
