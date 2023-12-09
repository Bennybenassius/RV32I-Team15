module Control_unit (  
    //INPUTS
    input logic [6: 0]   op,
    input logic [2: 0]   funct3,
    input logic          funct7,

    //OUTPUTS
    output logic                RegWriteD,
    output logic [1: 0]         ResultSrcD,
    output logic [2: 0]         MemWriteD,          //memory write enable
    output logic                JumpD,
    output logic                BranchD,
    output logic [2: 0]         ALUControlD,
    output logic                ALUSrcD,
    output logic [1: 0]         ImmSrcD,
);

always_comb begin
    case(op)
        //================================================================
        7'd55   :   begin           // LUI 
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b1;          // use imm
                    ImmSrcD = 2'b1;          // use sign extend
                end

        7'd51   :   begin
            case (funct3)
                3'b000  :   begin   //ADD
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                end
                3'b001  :   begin   // SLL
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b001;    // alu mode: SLL
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                end
                3'b100  :   begin   //XOR (^)
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b100;    // alu mode: XOR
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                end
                3'b101  :   begin   //SRL
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b101;    // alu mode: SRL
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                end
                3'b111  :   begin   //AND (&)
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b111;    // alu mode: AND
                    ALUSrcD = 1'b0;          // use reg
                    ImmSrcD = 2'b0;          // don't care
                end
                default: begin      // do nothing
                    RegWriteD = 1'b0; 
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    JumpD = 1'b0;  
                    BranchD = 1'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                end
            endcase
        end

        7'd19   :   begin   // ADDI
            case (funct3)
                3'b000    :   begin 
                    RegWriteD = 1'b1;        // write to reg
                    ResultSrcD = 2'b0;       // bypass mem
                    MemWriteD = 3'b0;        // not writing to mem
                    JumpD = 1'b0;            // no jump
                    BranchD = 1'b0;          // no branch
                    ALUControlD = 3'b0;      // alu mode: ADD
                    ALUSrcD = 1'b1;          // use imm
                    ImmSrcD = 2'b1;          // use sign extend
                end

                default: begin // do nothing
                    RegWriteD = 1'b0; 
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    JumpD = 1'b0;  
                    BranchD = 1'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                end

            endcase
        end

        7'd99   :   begin   // B-type instr
            case (funct3)
                3'b000    :  begin  // BEQ
                    RegWriteD = 1'b0;               // not writing to reg
                    ResultSrcD = 2'b0;              // don't care
                    MemWriteD = 3'b0;               // don't care
                    JumpD = 1'b0;                   // no jump
                    BranchD = 1'b1;                 // branch
                    ALUControlD = 3'b0;             // don't care
                    ALUSrcD = 1'b0;                 // use reg
                    ImmSrcD = 2'b1;                 // use sign extend 
                end

                3'b001    :  begin  // BNE 
                    RegWriteD = 1'b0;               // not writing to reg
                    ResultSrcD = 2'b0;              // don't care
                    MemWriteD = 3'b0;               // don't care
                    JumpD = 1'b0;                   // no jump
                    BranchD = 1'b1;                 // branch
                    ALUControlD = 3'b0;             // don't care
                    ALUSrcD = 1'b0;                 // use reg
                    ImmSrcD = 2'b1;                 // use sign extend 
                end

                3'b100    :  begin  // BLT 
                    RegWriteD = 1'b0;               // not writing to reg
                    ResultSrcD = 2'b0;              // don't care
                    MemWriteD = 3'b0;               // don't care
                    JumpD = 1'b0;                   // no jump
                    BranchD = 1'b1;                 // branch
                    ALUControlD = 3'b0;             // don't care
                    ALUSrcD = 1'b0;                 // use reg
                    ImmSrcD = 2'b1;                 // use sign extend 
                end 

                3'b101    :  begin  // BGE 
                    RegWriteD = 1'b0;               // not writing to reg
                    ResultSrcD = 2'b0;              // don't care
                    MemWriteD = 3'b0;               // don't care
                    JumpD = 1'b0;                   // no jump
                    BranchD = 1'b1;                 // branch
                    ALUControlD = 3'b0;             // don't care
                    ALUSrcD = 1'b0;                 // use reg
                    ImmSrcD = 2'b1;                 // use sign extend 
                end       

                default: begin // do nothing
                    RegWriteD = 1'b0; 
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    JumpD = 1'b0;  
                    BranchD = 1'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                end

            endcase
        end

        7'd103   :   begin  // JALR
            RegWriteD = 1'b1;        // write to reg
            ResultSrcD = 2'b10;      // store return address (PC+4) in rd
            MemWriteD = 3'b0;        // not writing to mem
            JumpD = 1'b1;            // jump
            BranchD = 1'b0;          // no branch    
            ALUControlD = 3'b0;      // add immediate offset to rs1  
            ALUSrcD = 1'b1;          // use imm
            ImmSrcD = 2'b1;          // use sign extend
        end

        7'd111   :   begin  // JAL
            RegWriteD = 1'b1;        // write to reg
            ResultSrcD = 2'b10;      // store return address (PC+4) in rd
            MemWriteD = 3'b0;        // not writing to mem
            JumpD = 1'b1;            // jump
            BranchD = 1'b0;          // no branch    
            ALUControlD = 3'b0;      // add PC with sign extended Imm
            ALUSrcD = 1'b0;          // use reg
            ImmSrcD = 2'b1;          // use sign extend (JTA)
        end
        //================================================================
        
        7'd3 :   begin      // load type instr
            case (funct3)
                3'b010 : begin  // lw
                    RegWriteD = 1'b1;    // write to reg
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b0;    // not writing to mem
                    JumpD = 1'b0;        // no jump
                    BranchD = 1'b0;      // no branch
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                end

                3'b000 : begin  // lb
                    RegWriteD = 1'b1;    // write to reg
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b10;   // not writing to mem
                    JumpD = 1'b0;        // no jump
                    BranchD = 1'b0;      // no branch
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                end

                3'b100 : begin  // lbu
                    RegWriteD = 1'b1;    // write to reg
                    ResultSrcD = 2'b1;   // load word from mem
                    MemWriteD = 3'b110;  // not writing to mem
                    JumpD = 1'b0;        // no jump
                    BranchD = 1'b0;      // no branch
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                end
                default: begin // do nothing
                    RegWriteD = 1'b0;  
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    JumpD = 1'b0;  
                    BranchD = 1'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                end
            endcase
        end
        7'd35 : begin       // store type instr
            case (funct3)
                3'b10 :begin    // sw
                    RegWriteD = 1'b0;    // not writing to reg
                    ResultSrcD = 2'b0;   // don't care
                    MemWriteD = 3'b1;    // write to mem
                    JumpD = 1'b0;        // no jump
                    BranchD = 1'b0;      // no branch
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                end

                3'b0 :begin    // sb
                    RegWriteD = 1'b0;    // not writing to reg
                    ResultSrcD = 2'b0;   // don't care
                    MemWriteD = 3'b11;   // write to mem
                    JumpD = 1'b0;        // no jump
                    BranchD = 1'b0;      // no branch
                    ALUControlD = 3'b0;  // alu mode: ADD
                    ALUSrcD = 1'b1;      // use imm
                    ImmSrcD = 2'b1;      // use sign extend
                end
                
                default: begin // do nothing
                    RegWriteD = 1'b0;  
                    ResultSrcD = 2'b0;
                    MemWriteD = 3'b0;
                    JumpD = 1'b0;  
                    BranchD = 1'b0;
                    ALUControlD = 3'b0; 
                    ALUSrcD = 1'b0;
                    ImmSrcD = 2'b0;
                end
            endcase
        end
        //=================================================================
        default: begin // do nothing
            RegWriteD = 1'b0;  
            ResultSrcD = 2'b0;
            MemWriteD = 3'b0;
            JumpD = 1'b0;  
            BranchD = 1'b0;
            ALUControlD = 3'b0; 
            ALUSrcD = 1'b0;
            ImmSrcD = 2'b0;
        end
    endcase
end

endmodule
