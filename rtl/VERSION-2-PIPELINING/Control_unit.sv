module Control_unit (  
    //INPUTS
    input logic [6: 0]   op,
    input logic [2: 0]   funct3,
    input logic          funct7,

    //OUTPUTS
    output logic                RegWriteD,
    output logic [1: 0]         ResultSrcD,
    output logic [2: 0]         MemWriteD,          //memory write enable
    output logic [2: 0]         ALUControlD,
    output logic                ALUSrcD,
    output logic [1: 0]         ImmSrcD,
);

always_comb begin
    case(op)
        //================================================================
        7'd55   :   begin           // LUI 
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b1;          // use imm
                    ImmSrcD = 2'b1;          // use sign extend
                    RegWriteD = 1'b1;        // write to destination reg
                end

        7'd51   :   begin
            case (funct3)
                3'b000  :   begin   //ADD
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                    RegWriteD = 1'b1;        // write to destination reg
                end
                3'b001  :   begin   // SLL
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b001;    // alu mode: SLL
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                    RegWriteD = 1'b1;        // write to destination reg
                end
                3'b100  :   begin   //XOR (^)
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b100;    // alu mode: XOR
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                    RegWriteD = 1'b1;        // write to destination reg
                end
                3'b101  :   begin   //SRL
                    PCSrc = 2'b0;             // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b101;    // alu mode: SRL
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                    RegWriteD = 1'b1;        // write to destination reg
                end
                3'b111  :   begin   //AND (&)
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b111;    // alu mode: AND
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                    RegWriteD = 1'b1;        // write to destination reg
                end
                default: begin      // do nothing
                    PCSrc = 2'b0;
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                    RegWriteD = 1'b0; 
                end
            endcase
        end

        7'd19   :   begin   // ADDI
            case (funct3)
                3'b000    :   begin 
                    PCSrc = 2'b0;            // no branching
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b1;          // use imm
                    ImmSrcD = 2'b1;          // use sign extend
                    RegWriteD = 1'b1;        // write to destination reg
                end

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                    RegWriteD = 1'b0; 
                end

            endcase
        end

        7'd99   :   begin   // B-type instr
            case (funct3)
                3'b000    :  begin  // BEQ
                    ResultSrcD = 2'b0;        // don't care
                    MemWriteD = 3'b0;         // don't care
                    ALUControlD = 3'b0;       // don't care
                    ALUSrcD = 1'b0;           // use reg
                    ImmSrcD = 2'b1;           // use sign extend 
                    RegWriteD = 1'b0;         // not writing to any reg
                    case(Zero)
                        1'b1    :   begin 
                            PCSrc = 2'b1; // need branching
                        end
                        default: PCSrc = 2'b0;
                    endcase
                end

                3'b001    :  begin  // BNE 
                    ResultSrcD = 2'b0;        // don't care
                    MemWriteD = 3'b0;         // don't care
                    ALUControlD = 3'b0;       // don't care
                    ALUSrcD = 1'b0;           // use reg
                    ImmSrcD = 2'b1;           // use sign extend 
                    RegWriteD = 1'b0;         // not writing to any reg
                    case(Zero)
                        1'b0    :   begin 
                            PCSrc = 2'b1; // need branching
                        end
                        default: PCSrc = 2'b0;
                    endcase
                end      

                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                    RegWriteD = 1'b0; 
                end

            endcase
        end

        7'd103   :   begin  // JALR
            PCSrc = 2'b10;          // jump
            ResultSrcD = 2'b10;      // choose PC+4
            MemWriteD = 3'b0;    
            ALUControlD = 3'b0;      // add immediate offset to rs1  
            ALUSrcD = 1'b1;          // use imm
            ImmSrcD = 2'b1;          // use sign extend
            RegWriteD = 1'b1;        // store return address (PC+4) in rd
        end

        7'd111   :   begin  // JAL
            PCSrc = 2'b1;           // jump
            ResultSrcD = 2'b10;      // choose PC+4
            MemWriteD = 3'b0;    
            ALUControlD = 3'b0;      // add PC with sign extended Imm
            ALUSrcD = 1'b0;          
            ImmSrcD = 2'b1;          // use sign extend (JTA)
            RegWriteD = 1'b1;        // store return address (PC+4) in rd
        end
        //================================================================
        
        7'd3 :   begin      // load type instr
            case (funct3)
                3'b010 : begin  // lw
                    PCSrc = 2'b0;       // no branching
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b0;    // not writing to mem
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                    RegWriteD = 1'b1;    // write to destination reg
                end

                3'b000 : begin  // lb
                    PCSrc = 2'b0;       // no branching
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b10;   // not writing to mem
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                    RegWriteD = 1'b1;    // write to destination reg
                end

                3'b100 : begin  // lbu
                    PCSrc = 2'b0;       // no branching
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b110;  // not writing to mem
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                    RegWriteD = 1'b1;    // write to destination reg
                end
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                    RegWriteD = 1'b0;  
                end
            endcase
        end
        7'd35 : begin       // store type instr
            case (funct3)
                3'b10 :begin    // sw
                    PCSrc = 2'b0;       // no branching
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b1;    // write to memory
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                    RegWriteD = 1'b0;    // not writing to reg (but write to mem)
                end

                3'b0 :begin    // sb
                    PCSrc = 2'b0;       // no branch
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b11;   // write to memory
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                    RegWriteD = 1'b0;    // not writing to reg (but write to mem)
                end
                
                default: begin // do nothing
                    PCSrc = 2'b0;
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                    RegWriteD = 1'b0;  
                end
            endcase
        end
        //=================================================================
        default: begin // do nothing
            PCSrc = 2'b0;
            ResultSrcD = 2'b0;
            MemWriteD = 3'b0;
            ALUControlD = 3'b0; 
            ALUSrcD = 1'b0;
            ImmSrcD = 2'b0;
            RegWriteD = 1'b0;  
        end
    endcase
end

endmodule
