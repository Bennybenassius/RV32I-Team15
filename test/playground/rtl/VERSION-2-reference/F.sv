module F #(
    parameter WIDTH = 32
)(
    // INPUTS
    input logic                 clk,
    input logic                 rst, 
    input logic  [WIDTH-1: 0]   PCTargetE_i,    //This is after adding PC with Imm offset
    input logic  [1:0]          PCSrcE_i,       //This is the mux input from control and execution unit (Stage D, E)
    input logic  [WIDTH-1: 0]   ALUResultE_i,   //This is for jalr

    // OUTPUTS
    output logic [WIDTH-1: 0]   PCF_o,          //The value of the current PC
    output logic [WIDTH-1: 0]   PCPlus4F_o,     //PC+4 value
    output logic [WIDTH-1: 0]   InstrF_o        //Instruction output
);

logic   [WIDTH-1:0] PCNextF;
logic   [WIDTH-1:0] PCF = 0;


assign  PCPlus4F_o = PCF + 32'b100;   //PC + 4

always_comb begin // 4 input MUX
    
    PCF_o = PCF;                                    //Wire PCF straight out 
    
    case (rst)
        1'b1:   PCNextF = 0;
        1'b0:   begin
            case (PCSrcE_i)
                2'b00 :  PCNextF = PCPlus4F_o;
                2'b01 :  PCNextF = PCTargetE_i;     //PC +Imm
                2'b10 :  PCNextF = ALUResultE_i;    //jalr
                default: PCNextF = PCPlus4F_o;
            endcase
        end
    endcase
end

always_ff @ (posedge clk)begin
    PCF <= PCNextF;
end;

Instr_mem Instr_mem (
    //INPUTS
    .A(PCF),
    //OUTPUTS
    .RD(InstrF_o)
);

endmodule
