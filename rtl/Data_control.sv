module Data_control #(
    parameter D_WIDTH = 32
)(
    input logic [D_WIDTH-1:0]   instr, // instruction is 32 bits long
    input logic                 EQ,
    output logic                RegWrite,
    output logic                ALUctrl,
    output logic                ALUsrc,
    output logic                ImmSrc,
    output logic                PCsrc,
    output logic                MemWrite,          //memory write enable
    output logic                ResultSrc
);

logic   [6:0]   op      = instr[6:0];
logic   [2:0]   funct3  = instr[14:12];

always_comb begin
    case(op)
        //================================================================
        7'd19   :   begin
            case (funct3)
                3'b000    :   begin
                    RegWrite = 1'b1; // if addi then we want to write to destination reg
                    ALUctrl = 1'b1; // in the ALU we defined 1 for add and 0 for subtract
                    ALUsrc = 1'b1; // need to add with imm
                    ImmSrc = 1'b1; // need to sign extend the imm to make it 32 bits
                    PCsrc = 1'b0; // no branching
                    ResultSrc = 1'b0;
                    MemWrite = 1'b0;// disable WE in mem
                end
            endcase
        end
        7'd99   :   begin
            case (funct3)
                3'b001    :  begin      //bne instruction
                    RegWrite = 1'b0; // not writing to any reg
                    ALUctrl = 1'b0; // need subtraction to calc branch target addr
                    ALUsrc = 1'b0; // not using imm, need both operands coming from reg
                    ImmSrc = 1'b1; // need to sign extend the branch target address
                    case(EQ)
                        1'b0    :   begin 
                            PCsrc = 1'b1; // need branching
                        end
                    endcase
                    ResultSrc = 1'b0;
                    MemWrite = 1'b0;// disable WE in mem
                end
            endcase
        end
        //================================================================
        //Data control part

        7'd3 :   begin        // load types
            case (funct3)
                3'b010 : begin  //lw
                    RegWrite = 1'b1;    // allow reg to be loaded
                    ALUctrl = 1'b1;     // alu mode: add
                    ALUsrc = 1'b1;      // use imm
                    ImmSrc = 1'b1;      // use signextend
                    PCsrc = 1'b0;       // no branch
                    MemWrite = 1'b0;          // not write to memory
                    ResultSrc = 1'b1;// load word from mem

                end

            endcase
        end
        7'd35 : begin
            case (funct3)
                3'b10 :begin    //sw
                    RegWrite = 1'b0;    // not write to reg (but write to mem)
                    ALUctrl = 1'b1;     // alu mode: add
                    ALUsrc = 1'b1;      // use imm
                    ImmSrc = 1'b1;      // use signextend
                    PCsrc = 1'b0;       // no branch
                    MemWrite = 1'b1;          // write to memory
                    ResultSrc = 1'b0;
                end
            endcase
        end
    endcase
       
end

endmodule
