module Control_unit #(
    parameter D_WIDTH = 32
)(
    // INPUTS
    input logic [6:0]   op,
    input logic [2:0]   funct3,
    input logic         funct7,
    input logic         Zero,

    // OUTPUTS
    output logic [1:0]  PCSrc,
    output logic [1:0]  ResultSrc,
    output logic        MemWrite,
    output logic [2:0]  ALUControl,
    output logic        ALUsrc,
    output logic [1:0]  ImmSrc,
    output logic        RegWrite
);

always_comb begin    
    case (op)
        7'd51   :   begin
            case (funct3)

                3'b000    :   begin 
                    case(funct7)

                        1'b0    :   begin   // ADD
                            PCSrc = 2'b0;       // no branching
                            ResultSrc = 2'b0;   // bypass data mem
                            MemWrite = 1'b0;    // not writing to data mem
                            ALUControl = 3'b1;  // addition
                            ALUsrc = 1'b0;      // register operand
                            ImmSrc = 2'b0;      // not using imm
                            RegWrite = 1'b1;    // write to destination reg
                        end

                        default: begin // do nothing
                            PCSrc = 2'b0;
                            ResultSrc = 2'b0;
                            MemWrite = 1'b0;
                            ALUControl = 3'b0; 
                            ALUsrc = 1'b0;
                            ImmSrc = 2'b0;
                            RegWrite = 1'b0; 
                        end

                    endcase
                end

                default: begin // do nothing
                    PCSrc = 2'b0;
                        ResultSrc = 2'b0;
                        MemWrite = 1'b0;
                        ALUControl = 3'b0; 
                        ALUsrc = 1'b0;
                        ImmSrc = 2'b0;
                        RegWrite = 1'b0; 
                end

            endcase
        end

        7'd19   :   begin
            case (funct3)

                3'b000    :   begin // ADDI
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b0;   // bypass data mem
                    MemWrite = 1'b0;    // not writing to data mem
                    ALUControl = 3'b1;  // addition
                    ALUsrc = 1'b1;      // add with imm
                    ImmSrc = 2'b1;      // need to sign extend
                    RegWrite = 1'b1;    // write to destination reg
                end

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b0; 
                    ALUsrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0; 
                end

            endcase
        end

        7'd99   :   begin // B-type instr
            case (funct3)

                3'b000    :  begin  // BEQ
                    ResultSrc = 2'b0;   // doesn't matter
                    MemWrite = 1'b0;    // doesn't matter
                    ALUControl = 3'b0;
                    ALUsrc = 1'b0;      // not using imm
                    ImmSrc = 2'b1;      // need sign extend
                    RegWrite = 1'b0;    // not writing to any reg
                    case(Zero)
                        1'b1    :   begin 
                            PCSrc = 2'b1; // need branching
                        end
                        default: PCSrc = 2'b0;
                    endcase
                end

                3'b001    :  begin  // BNE 
                    ResultSrc = 2'b0;   // doesn't matter
                    MemWrite = 1'b0;    // doesn't matter
                    ALUControl = 3'b0;
                    ALUsrc = 1'b0;      // not using imm
                    ImmSrc = 2'b1;      // need to sign extend
                    RegWrite = 1'b0;    // not writing to any reg
                    case(Zero)
                        1'b0    :   begin 
                            PCSrc = 2'b1; // need branching
                        end
                        default: PCSrc = 2'b0;
                    endcase
                end      

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b0; 
                    ALUsrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0; 
                end

            endcase
        end

        7'd103   :   begin  // JALR
            PCSrc = 2'b10;      // jump
            ResultSrc = 2'b10;  // choose PC+4
            MemWrite = 1'b0;
            ALUControl = 3'b1; 
            ALUsrc = 1'b1;      // need imm
            ImmSrc = 2'b1;      // sign ext imm
            RegWrite = 1'b1;    // store return address (PC+4) in rd
        end

        7'd111   :   begin  // JAL
            PCSrc = 2'b1;       // jump
            ResultSrc = 2'b10;  // choose PC+4
            MemWrite = 1'b0;
            ALUControl = 3'b0; 
            ALUsrc = 1'b0;
            ImmSrc = 2'b1;      // sign ext imm (JTA)
            RegWrite = 1'b1;    // store return address (PC+4) in rd
        end

        default: begin // do nothing
            PCSrc = 2'b0;
            ResultSrc = 2'b0;
            MemWrite = 1'b0;
            ALUControl = 3'b0; 
            ALUsrc = 1'b0;
            ImmSrc = 2'b0;
            RegWrite = 1'b0;  
        end

    endcase
end

endmodule
