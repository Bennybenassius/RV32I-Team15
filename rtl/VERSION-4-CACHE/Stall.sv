module Stall (
    //INPUT
    input logic StallAllM_i,
    input logic StallF_i,
    input logic StallD_i,
    //OUTPUT
    output logic Stall_F,
    output logic Stall_D,
    output logic Stall_E,
    output logic Stall_M,
    output logic Stall_W
);

always_comb begin
    Stall_F = StallAllM_i | StallF_i;
    Stall_D = StallAllM_i | StallD_i;
    Stall_E = StallAllM_i;
    Stall_M = StallAllM_i;
    Stall_W = StallAllM_i;
end

endmodule
