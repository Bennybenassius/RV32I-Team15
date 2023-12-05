module Data_mem #(
    parameter ADDRESS_WIDTH = 10, // total 2**5 number of address locations
              DATA_WIDTH = 8     // each location has 1 byte data
) (
    input   logic clk,
    input   logic             WE,          //memory write enable
    input   logic   [31: 0]     A,         //memory read address
    input  logic   [31:0]    WD,           //memory data in 

    output  logic   [31:0]    RD           //memory data out
);

logic [ADDRESS_WIDTH - 1:0] word_addr = {A[ADDRESS_WIDTH - 1:2],2'b0};
logic [DATA_WIDTH - 1: 0] mem_array [2**ADDRESS_WIDTH - 1: 0];

initial begin 
        $display("Lodaing Data_mem.");
        $readmemh("Data.mem", mem_array);
        $display("Load finished.");
        $display("memary ready.");
end;

always_ff @( posedge clk ) begin
    if (!WE) begin //if not write enable -> read data
        RD = {mem_array[word_addr], mem_array[word_addr + 1], mem_array[word_addr + 2], mem_array[word_addr + 3]};
    end
end

always_comb begin
    if (WE) begin
        assign mem_array[word_addr] = WD[31: 24];
        assign mem_array[word_addr + 1] = WD[23: 16];
        assign mem_array[word_addr + 2] = WD[15: 8];
        assign mem_array[word_addr + 3] = WD[7: 0];
    end
end
endmodule