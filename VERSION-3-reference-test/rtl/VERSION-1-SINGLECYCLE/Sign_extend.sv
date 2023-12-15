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

                7'd55   :   begin   // LUI 
                    ImmExt = {instr[31:12], 12'b0};
                end

                7'd19   :   begin   // ADDI
                    case (funct3)
                        3'b0    :   ImmExt = {{20{instr[31]}}, instr[31:20]};
                        default :   ImmExt = 32'b0;
                    endcase
                end

                7'd99   :   begin   // BEQ, BNE, BLT, BGE
                    case (funct3)
                        3'b000    :   ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};  
                        3'b001    :   ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; 
                        3'b100    :   ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                        3'b101    :   ImmExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
                        default :   ImmExt = 32'b0;
                    endcase
                end

                7'd3    :   begin   // load 
                    case (funct3)   
                        3'b10   :   ImmExt = {{20{instr[31]}},instr[31: 20]};   //word
                        3'b0    :   ImmExt = {{20{instr[31]}},instr[31: 20]};   //byte
                        3'b100  :   ImmExt = {{20{instr[31]}},instr[31: 20]};   //byte unsigned
                        default :   ImmExt = 32'b0;
                    endcase
                end

                7'd35   :   begin   // store
                    case (funct3)
                        3'b10   :   ImmExt = {{20{instr[31]}},instr[31: 25],instr[11: 7]};  //word
                        3'b00   :   ImmExt = {{20{instr[31]}},instr[31: 25],instr[11: 7]};  //byte
                        default :   ImmExt = 32'b0;
                    endcase
                end

                7'd103  :   begin   // JALR
                    case (funct3)
                        3'b0    :   ImmExt = {{20{instr[31]}},instr[31:20]};
                        default :   ImmExt = 32'b0;
                    endcase
                end

                7'd111  :   begin   // JAL
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
