module Sign_extend #(
    parameter D_WIDTH = 32
)(
    //INPUTS
    input logic [D_WIDTH-1:0]   instrD,
    input logic [1:0]           ImmSrcD,

    //OUTPUTS
    output logic [D_WIDTH-1:0]  ImmExtD // after sign extention we get a 32 bit number
);

logic   [6:0]   op      = instrD[6:0];
logic   [2:0]   funct3  = instrD[14:12];

always_comb begin
    case (ImmSrcD) 
        2'b0 : begin    // not sign extending
            ImmExtD = 0; 
        end

        2'b1 : begin    // 32 bit sign extend
            case (op)

                7'd55   :   begin   // LUI 
                    ImmExtD = {instrD[31:12], 12'b0};
                end

                7'd19   :   begin   // ADDI
                    case (funct3)
                        3'b0    :   ImmExtD = {{20{instrD[31]}}, instrD[31:20]};
                        default :   ImmExtD = 32'b0;
                    endcase
                end

                7'd99   :   begin   // BEQ, BNE, BLT, BGE
                    case (funct3)
                        3'b000    :   ImmExtD = {{19{instrD[31]}}, instrD[31], instrD[7], instrD[30:25], instrD[11:8], 1'b0};  
                        3'b001    :   ImmExtD = {{19{instrD[31]}}, instrD[31], instrD[7], instrD[30:25], instrD[11:8], 1'b0}; 
                        3'b100    :   ImmExtD = {{19{instrD[31]}}, instrD[31], instrD[7], instrD[30:25], instrD[11:8], 1'b0};
                        3'b101    :   ImmExtD = {{19{instrD[31]}}, instrD[31], instrD[7], instrD[30:25], instrD[11:8], 1'b0};  
                        default :   ImmExtD = 32'b0;
                    endcase
                end

                7'd3    :   begin   // load 
                    case (funct3)   
                        3'b10   :   ImmExtD = {{20{instrD[31]}},instrD[31: 20]};   //word
                        3'b0    :   ImmExtD = {{20{instrD[31]}},instrD[31: 20]};   //byte
                        3'b100  :   ImmExtD = {{20{instrD[31]}},instrD[31: 20]};   //byte unsigned
                        default :   ImmExtD = 32'b0;
                    endcase
                end

                7'd35   :   begin   // store
                    case (funct3)
                        3'b10   :   ImmExtD = {{20{instrD[31]}},instrD[31: 25],instrD[11: 7]};  //word
                        3'b00   :   ImmExtD = {{20{instrD[31]}},instrD[31: 25],instrD[11: 7]};  //byte
                        default :   ImmExtD = 32'b0;
                    endcase
                end

                7'd103  :   begin   // JALR
                    case (funct3)
                        3'b0    :   ImmExtD = {{20{instrD[31]}},instrD[31:20]};
                        default :   ImmExtD = 32'b0;
                    endcase
                end

                7'd111  :   begin   // JAL
                    ImmExtD = {{11{instrD[31]}} ,instrD[31], instrD[19:12], instrD[20], instrD[30:21], 1'b0};
                end

                default :   ImmExtD = 32'b0;
            endcase
        end

        default  :  ImmExtD = 32'b0;

        // 2'b10 : begin   // byte extend
        
        // end

        // 2'b11 : begin   // zero extend

        // end

    endcase
end

endmodule
