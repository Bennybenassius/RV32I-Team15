module Hazard(
    input logic [4:0]       Rs1D_i_dh,
    input logic [4:0]       Rs2D_i_dh,

    input logic [4:0]       Rs1E_i_eh,
    input logic [4:0]       Rs2E_i_eh,
    input logic [4:0]       RdE_i_eh,
    input logic [1:0]       PCSrcE_i_eh,
    input logic             ResultSrcE_i_eh, // LSB of ResultSrcE_o (tells if writing back data from data_mem)
    input logic [4:0]       RdM_i_mh,
    input logic             RegWriteM_i_mh,
    input logic [4:0]       RdW_i_wh,
    input logic             RegWriteW_i_wh,

    output logic            StallF_o,
    output logic            StallD_o,
    output logic            FlushD_o,
    output logic            FlushE_o,
    output logic [1:0]      ForwardAE_o,
    output logic [1:0]      ForwardBE_o
);

//           FORWARDING
//===================================
always_comb begin
    if (((Rs1E_i_eh == RdM_i_mh) & RegWriteM_i_mh) & (Rs1E_i_eh != 0))  ForwardAE_o = 2'b10;
    else if (((Rs1E_i_eh == RdW_i_wh) & RegWriteW_i_wh) & (Rs1E_i_eh != 0))   ForwardAE_o = 2'b01;
    else    ForwardAE_o = 2'b00;  

    if (((Rs2E_i_eh == RdM_i_mh) & RegWriteM_i_mh) & (Rs2E_i_eh != 0))    ForwardBE_o = 2'b10;
    else if (((Rs2E_i_eh == RdW_i_wh) & RegWriteW_i_wh) & (Rs2E_i_eh != 0))   ForwardBE_o = 2'b01;
    else    ForwardBE_o = 2'b00;  
end
//===================================

//              STALL
//====================================
logic       should_we_stall;
always_comb begin
    should_we_stall = ResultSrcE_i_eh & ((Rs1D_i_dh==RdE_i_eh) | (Rs2D_i_dh==RdE_i_eh));
    StallF_o = should_we_stall;
    StallD_o = should_we_stall;
end
//======================================

//              FLUSH
//======================================
logic       PCSrcE;

always_comb begin
    PCSrcE = PCSrcE_i_eh[0] | PCSrcE_i_eh[1];
    FlushD_o = PCSrcE;
    FlushE_o = should_we_stall | PCSrcE;
end
//======================================

endmodule
