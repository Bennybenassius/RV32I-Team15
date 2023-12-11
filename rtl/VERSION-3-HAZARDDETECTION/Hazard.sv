module Hazard(
    input logic [4:0]       Rs1D_i_dh,
    input logic [4:0]       Rs2D_i_dh,

    input logic [4:0]       Rs1E_i_eh,
    input logic [4:0]       Rs2E_i_eh,
    input logic [4:0]       RdE_i_eh,
    input logic [1:0]       PCSrcE_i_eh,
    input logic             ResultSrcE_i_eh,
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



endmodule
