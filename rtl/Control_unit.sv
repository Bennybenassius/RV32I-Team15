module Control_unit (  
    //Input
    input logic [6: 0]   op,
    input logic [2: 0]   funct3,
    input logic          funct7,
    input logic          Zero,

    //Output
    output logic                RegWrite,
    output logic [2: 0]         ALUControl,
    output logic                ALUSrc,
    output logic [1: 0]         ImmSrc,
    output logic [1: 0]         PCSrc,
    output logic                MemWrite,          //memory write enable
    output logic [1: 0]         ResultSrc
);

always_comb begin
    case(op)
        //================================================================
        7'd51   :   begin
            case (funct3)
                3'b000  :   begin   //ADD
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b0;   // bypass data mem
                    MemWrite = 1'b0;    // not writing to data mem
                    ALUControl = 3'b0;  // addition
                    ALUSrc = 1'b0;      // register operand
                    ImmSrc = 2'b0;      // not using imm
                    RegWrite = 1'b1;    // write to destination reg
                end
                3'b001  :   begin   //shift left logical
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b001;    // sll
                    ALUSrc = 1'b0;          // 2 register operands
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to rd
                end
                3'b100  :   begin   //XOR (^)
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b100;    // XOR
                    ALUSrc = 1'b0;          // 2 register operands
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to rd
                end
                3'b111  :   begin   //AND (&)
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b111;    // AND
                    ALUSrc = 1'b0;          // 2 register operands
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to rd
                end
                default: begin      // do nothing
                    PCSrc = 2'b0;
                        ResultSrc = 2'b0;
                        MemWrite = 1'b0;
                        ALUControl = 3'b0; 
                        ALUSrc = 1'b0;
                        ImmSrc = 2'b0;
                        RegWrite = 1'b0; 
                end
            endcase
        end

        7'd19   :   begin   // ADDI
            case (funct3)
                3'b000    :   begin 
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b0;   // bypass data mem
                    MemWrite = 1'b0;    // not writing to data mem
                    ALUControl = 3'b0;  // addition
                    ALUSrc = 1'b1;      // add with imm
                    ImmSrc = 2'b1;      // need to sign extend
                    RegWrite = 1'b1;    // write to destination reg
                end

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b0; 
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0; 
                end

            endcase
        end

        7'd99   :   begin   // B-type instr
            case (funct3)
                3'b000    :  begin  // BEQ
                    ResultSrc = 2'b0;   // doesn't matter
                    MemWrite = 1'b0;    // doesn't matter
                    ALUControl = 3'b0;  // doesn't matter
                    ALUSrc = 1'b0;      // not using imm
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
                    ALUSrc = 1'b0;      // not using imm
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
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0; 
                end

            endcase
        end

        7'd103   :   begin  // JALR
            PCSrc = 2'b10;      // jump
            ResultSrc = 2'b10;  // choose PC+4
            MemWrite = 1'b0;
            ALUControl = 3'b0;   // need add immediate offset to rs1  
            ALUSrc = 1'b1;      // need imm
            ImmSrc = 2'b1;      // sign ext imm
            RegWrite = 1'b1;    // store return address (PC+4) in rd
        end

        7'd111   :   begin  // JAL
            PCSrc = 2'b1;       // jump
            ResultSrc = 2'b10;  // choose PC+4
            MemWrite = 1'b0;
            ALUControl = 3'b0;  // add PC with sign extended Imm
            ALUSrc = 1'b0;      
            ImmSrc = 2'b1;      // sign ext imm (JTA)
            RegWrite = 1'b1;    // store return address (PC+4) in rd
        end
        //================================================================
        //Data control part

        7'd3 :   begin      // load types
            case (funct3)
                3'b010 : begin  //lw
                    RegWrite = 1'b1;    // allow reg to be loaded
                    ALUControl = 3'b1;     // alu mode: add
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use signextend
                    PCSrc = 2'b0;       // no branch
                    MemWrite = 1'b0;          // not write to memory
                    ResultSrc = 2'b1;// load word from mem
                end
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b0; 
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0;  
                end
            endcase
        end
        7'd35 : begin       //store types
            case (funct3)
                3'b10 :begin    //sw
                    RegWrite = 1'b0;    // not write to reg (but write to mem)
                    ALUControl = 3'b1;     // alu mode: add
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use signextend
                    PCSrc = 2'b0;       // no branch
                    MemWrite = 1'b1;          // write to memory
                    ResultSrc = 2'b0;
                end
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 1'b0;
                    ALUControl = 3'b0; 
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0;  
                end
            endcase
        end
        //=================================================================
        default: begin // do nothing
            PCSrc = 2'b0;
            ResultSrc = 2'b0;
            MemWrite = 1'b0;
            ALUControl = 3'b0; 
            ALUSrc = 1'b0;
            ImmSrc = 2'b0;
            RegWrite = 1'b0;  
        end
    endcase
       
end

endmodule
