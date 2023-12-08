module Instr_mem #(
    parameter   DATA_WIDTH = 8     // byte addressing, each byte contains 8 bits
)(
    input  logic     [31:0]     A,
    output logic    [31:0]      RD
);

logic [31:0] addr_word = {A[31:2],2'b0};                        // masking
logic [DATA_WIDTH-1:0] rom_array [32'hBFC00FFF:32'hBFC00000];   // memory mapping

initial begin 
        $display("Lodaing rom.");
        $readmemh("instruction_code.mem", rom_array);
end;

assign RD = {rom_array[addr_word], rom_array[addr_word+1], rom_array[addr_word+2], rom_array[addr_word+3]}; 
// concatenate the 4 byte address to make the full word address (little endian addressing)

endmodule
