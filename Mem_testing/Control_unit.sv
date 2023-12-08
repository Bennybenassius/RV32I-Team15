module Control_unit (  
    //INPUTS
    input logic [6: 0]   op,
    input logic [2: 0]   funct3,
    input logic          funct7,
    input logic          Zero,

    //OUTPUTS
    output logic [1: 0]         PCSrc,
    output logic [1: 0]         ResultSrc,
    output logic [2: 0]         MemWrite,          //memory write enable
    output logic [2: 0]         ALUControl,
    output logic                ALUSrc,
    output logic [1: 0]         ImmSrc,
    output logic                RegWrite
);

always_comb begin
    case(op)
        //================================================================
        7'd55   :   begin           // LUI 
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b0;      // alu mode: ADD
                    ALUSrc = 1'b1;          // use imm
                    ImmSrc = 2'b1;          // use sign extend
                    RegWrite = 1'b1;        // write to destination reg
                end

        7'd51   :   begin
            case (funct3)
                3'b000  :   begin   //ADD
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b0;      // alu mode: ADD
                    ALUSrc = 1'b0;          // use reg
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to destination reg
                end
                3'b001  :   begin   // SLL
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b001;    // alu mode: SLL
                    ALUSrc = 1'b0;          // use reg
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to destination reg
                end
                3'b100  :   begin   //XOR (^)
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b100;    // alu mode: XOR
                    ALUSrc = 1'b0;          // use reg
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to destination reg
                end
                3'b101  :   begin   //SRL
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b101;    // alu mode: SRL
                    ALUSrc = 1'b0;          // use reg
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to destination reg
                end
                3'b111  :   begin   //AND (&)
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b111;    // alu mode: AND
                    ALUSrc = 1'b0;          // use reg
                    ImmSrc = 2'b0;          // don't care
                    RegWrite = 1'b1;        // write to destination reg
                end
                default: begin      // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 3'b0;
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
                    PCSrc = 2'b0;           // no branching
                    ResultSrc = 2'b0;       // bypass mem
                    MemWrite = 3'b0;        // not writing to mem
                    ALUControl = 3'b0;      // alu mode: ADD
                    ALUSrc = 1'b1;          // use imm
                    ImmSrc = 2'b1;          // use sign extend
                    RegWrite = 1'b1;        // write to destination reg
                end

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 3'b0;
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
                    ResultSrc = 2'b0;        // don't care
                    MemWrite = 3'b0;         // don't care
                    ALUControl = 3'b0;       // don't care
                    ALUSrc = 1'b0;           // use reg
                    ImmSrc = 2'b1;           // use sign extend 
                    RegWrite = 1'b0;         // not writing to any reg
                    case(Zero)
                        1'b1    :   begin 
                            PCSrc = 2'b1; // need branching
                        end
                        default: PCSrc = 2'b0;
                    endcase
                end

                3'b001    :  begin  // BNE 
                    ResultSrc = 2'b0;        // don't care
                    MemWrite = 3'b0;         // don't care
                    ALUControl = 3'b0;       // don't care
                    ALUSrc = 1'b0;           // use reg
                    ImmSrc = 2'b1;           // use sign extend 
                    RegWrite = 1'b0;         // not writing to any reg
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
                    MemWrite = 3'b0;
                    ALUControl = 3'b0; 
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0; 
                end

            endcase
        end

        7'd103   :   begin  // JALR
            PCSrc = 2'b10;          // jump
            ResultSrc = 2'b10;      // choose PC+4
            MemWrite = 3'b0;    
            ALUControl = 3'b0;      // add immediate offset to rs1  
            ALUSrc = 1'b1;          // use imm
            ImmSrc = 2'b1;          // use sign extend
            RegWrite = 1'b1;        // store return address (PC+4) in rd
        end

        7'd111   :   begin  // JAL
            PCSrc = 2'b1;           // jump
            ResultSrc = 2'b10;      // choose PC+4
            MemWrite = 3'b0;    
            ALUControl = 3'b0;      // add PC with sign extended Imm
            ALUSrc = 1'b0;          
            ImmSrc = 2'b1;          // use sign extend (JTA)
            RegWrite = 1'b1;        // store return address (PC+4) in rd
        end
        //================================================================
        
        7'd3 :   begin      // load type instr
            case (funct3)
                3'b010 : begin  // lw
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b1;   // load word from mem
                    MemWrite = 3'b0;    // not writing to mem
                    ALUControl = 3'b0;  // alu mode: ADD
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use sign extend
                    RegWrite = 1'b1;    // write to destination reg
                end

                3'b000 : begin  // lb
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b1;   // load word from mem
                    MemWrite = 3'b10;   // not writing to mem
                    ALUControl = 3'b0;  // alu mode: ADD
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use sign extend
                    RegWrite = 1'b1;    // write to destination reg
                end

                3'b100 : begin  // lbu
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b1;   // load word from mem
                    MemWrite = 3'b110;  // not writing to mem
                    ALUControl = 3'b0;  // alu mode: ADD
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use sign extend
                    RegWrite = 1'b1;    // write to destination reg
                end
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 3'b0;
                    ALUControl = 3'b0; 
                    ALUSrc = 1'b0;
                    ImmSrc = 2'b0;
                    RegWrite = 1'b0;  
                end
            endcase
        end
        7'd35 : begin       // store type instr
            case (funct3)
                3'b10 :begin    // sw
                    PCSrc = 2'b0;       // no branching
                    ResultSrc = 2'b0;
                    MemWrite = 3'b1;    // write to memory
                    ALUControl = 3'b0;  // alu mode: ADD
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use sign extend
                    RegWrite = 1'b0;    // not writing to reg (but write to mem)
                end

                3'b0 :begin    // sb
                    PCSrc = 2'b0;       // no branch
                    ResultSrc = 2'b0;
                    MemWrite = 3'b11;   // write to memory
                    ALUControl = 3'b0;  // alu mode: ADD
                    ALUSrc = 1'b1;      // use imm
                    ImmSrc = 2'b1;      // use sign extend
                    RegWrite = 1'b0;    // not writing to reg (but write to mem)
                end
                
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrc = 2'b0;
                    MemWrite = 3'b0;
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
            MemWrite = 3'b0;
            ALUControl = 3'b0; 
            ALUSrc = 1'b0;
            ImmSrc = 2'b0;
            RegWrite = 1'b0;  
        end
    endcase
end

endmodule
