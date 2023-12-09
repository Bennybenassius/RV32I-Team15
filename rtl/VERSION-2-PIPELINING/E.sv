    module E#(

        input logic           RegWriteE_i,
        input logic [1:0]     ResultSrcE_i,
        input logic           MemWriteE_i,
        input logic           JumpE_i,
        input logic           BranchE_i,
        input logic [2:0]     ALUControlE_i,
        input logic           ALUSrcE_i,

        input logic [31:0]    RD1E_i,
        input logic [31:0]    RD2E_i,
        input logic [31:0]    PCE_i,
        input logic [11:7]    RdE_i,
        input logic [31:7]    ImmExtE_i,
        input logic [31:0]    PCPlus4E_i,

        output logic [31:0]   PCTargetE_o,
        output logic [31:0]   PCPlus4E_o,
        output logic [31:0]   RdE_o,
        output logic [31:0]   WriteDataE_o,
        output logic [31:0]   ALUResultE_o,

        output logic          MemWriteE_o,
        output logic [1:0]    ResultSrcE_o,
        output logic          RegWriteE_o,
        output logic          PCSrcE_o,
        output logic          ZeroE

    );
    //=======================================
    //          WIRE

    assign logic [31:0]    PCTargetE_o    = PCE_i   + ImmExtE;
    assign logic [31:0]    WriteDataE_o = RD2E_i;
    logic        [31:0]    SrcBE        = (ALUSrcE_i) ? ImmExtE_i : RD2E_i; 
    assign logic           RegWriteE_o = RegWriteE_i;
    assign logic [1:0]     ResultSrcE_o = ResultSrcE_i;
    assign logic           MemWriteE_o = MemWriteE_i;
    assign logic [11:7]    RdE_o = RdE_i;
    assign logic [31:0]    PCPlus4E_o = PCPlus4E_i;

    always_comb begin
        case({JumpE_i, BranchE_i, ZeroE})
            3'b000:  PCSrcE_o = 1'b0;
            3'b001:  PCSrcE_o = 1'b0;
            3'b010:  PCSrcE_o = 1'b0;
            3'b011:  PCSrcE_o = 1'b1;
            3'b100:  PCSrcE_o = 1'b1;
            3'b101:  PCSrcE_o = 1'b1;
            3'b110:  PCSrcE_o = 1'b1;
            3'b111:  PCSrcE_o = 1'b1;
            default: PCSrcE_o = 1'b0; 
        endcase
    end

    ALU ALU(
        //INPUT
        .SrcAE(RD1E_i),
        .SrcBE(SrcBE)
        .ALUControlE(ALUControlE_i)

        //OUTPUTS
        .ALUResultE(ALUResultE_o),
        .ZeroE(ZeroE),
    );

    endmodule