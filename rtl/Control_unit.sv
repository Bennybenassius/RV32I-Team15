module Control_unit #(
    parameter D_WIDTH = 32
)(
    // INPUTS
    input logic [6:0]   op,
    input logic [2:0]   funct3,
    input logic         funct7,
    input logic         zero,

    // OUTPUTS
    output logic        PCsrc,
    output logic        ResultSrc,
    output logic        MemWrite,
    output logic [2:0]  ALUControl,
    output logic        ALUsrc,
    output logic        ImmSrc,
    output logic        RegWrite
);

always_comb begin    
    case (op)
        7'd51   :   begin
            case (funct3)

                3'b000    :   begin 
                    case(funct7)

                        7'b0    :   begin   // add
                            RegWrite = 1'b1; // write to destination reg
                            ALUctrl = 1'b1; // addition
                            ALUsrc = 1'b0; // register operand
                            ImmSrc = 1'b0; // not using imm
                            PCsrc = 1'b0; // no branching
                        end

                    endcase
                end

            endcase
        end

        7'd19   :   begin
            case (funct3)

                3'b000    :   begin // addi
                    RegWrite = 1'b1; // write to destination reg
                    ALUctrl = 1'b1; // addition
                    ALUsrc = 1'b1; // add with imm
                    ImmSrc = 1'b1; // need to sign extend
                    PCsrc = 1'b0; // no branching
                end

                default: begin // do nothing
                    RegWrite = 1'b0; 
                    ALUctrl = 1'b0; 
                    ALUsrc = 1'b0;
                    ImmSrc = 1'b0;
                    PCsrc = 1'b0;
                end
            endcase
        end

        7'd99   :   begin // B-type instr
            case (funct3)

                3'b000    :  begin      //beq
                    RegWrite = 1'b0; // not writing to any reg
                    ALUctrl = 1'b0;
                    ALUsrc = 1'b0; // not using imm
                    ImmSrc = 1'b1; // need sign extend
                    case(zero)
                        1'b1    :   begin 
                            PCsrc = 1'b1; // need branching
                        end
                        default: PCsrc = 1'b0;
                    endcase
                end

                3'b001    :  begin      //bne 
                    RegWrite = 1'b0; // not writing to any reg
                    ALUctrl = 1'b0;
                    ALUsrc = 1'b0; // not using imm
                    ImmSrc = 1'b1; // need to sign extend
                    case(zero)
                        1'b0    :   begin 
                            PCsrc = 1'b1; // need branching
                        end
                        default: PCsrc = 1'b0;
                    endcase
                end           
            endcase
        end

        7'd103   :   begin  // jalr
            RegWrite = 1'b1; // store return address (PC+4) in rd
            ALUctrl = ; 
            ALUsrc = ;
            ImmSrc = 1'b1;
            PCsrc = 1'b1; // need jumping
        end

        7'd111   :   begin  // jal
            RegWrite = 1'b1; // store return address (PC+4) in rd
            ALUctrl = ; 
            ALUsrc = ;
            ImmSrc = 1'b1;
            PCsrc = 1'b1; // need jumping
        end

    endcase
end

endmodule
