module Hazard(
    input logic [4:0]       Rs1D_i,
    input logic [4:0]       Rs2D_i,

    input logic [4:0]       Rs1E_i,
    input logic [4:0]       Rs2E_i,
    input logic [4:0]       RdE_i,
    input logic [1:0]       PCSrcE_i,
    input logic             ResultSrcE_i,
    input logic [4:0]       RdM_i,
    input logic             RegWriteM_i,
    input logic [4:0]       RdW_i,
    input logic             RegWriteW_i,

    output logic            StallF_o,
    output logic            StallD_o,
    output logic            FlushD_o,
    output logic            FlushE_o,
    output logic [1:0]      ForwardAE_o,
    output logic [1:0]      ForwardBE_o
)



endmodule
