module M_cache(
    //INPUTS
    input logic           clk,
    input logic [2: 0]    MemWriteM_i,
    input logic [31:0]    ALUResultM_i,
    input logic [31:0]    WriteDataM_i,
    input logic           EN,

    //OUTPUTS
    output logic [31:0]   ReadDataM_o,
    output logic StallAllM_o

);
//=======================================
logic cache_hit;
logic mem_ready;
logic [31: 0] ReadData2Cache;

Data_mem Data_mem(
    //INPUTS
    .clk(clk),
    .WE(MemWriteM_i),
    .A(ALUResultM_i),
    .WD(WriteDataM_i),
    .cache_hit(cache_hit),

    //OUTPUTS
    .RD(ReadData2Cache),
    .mem_ready(mem_ready)
);

cache cache(
    //INPUTS
    .clk(clk),
    .WE(MemWriteM_i),
    .A(ALUResultM_i),
    .WriteDataCache_i(ReadData2Cache),
    .EN(EN),

    //OUTPUT
    .cache_hit(cache_hit),
    .ReadDataCache_o(ReadDataM_o)
);

always_comb begin
    if (EN) begin
        StallAllM_o = ~ (mem_ready && cache_hit);
    end
    else StallAllM_o = 0;
end

endmodule
