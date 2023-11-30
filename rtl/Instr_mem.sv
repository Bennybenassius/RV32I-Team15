module Instr_mem #(
    parameter ADDRESS_WIDTH = 5, // total 2**5 number of address locations
              DATA_WIDTH = 8     // each instruction word is 32 bits long
)(
    input logic [31:0]   A,
    output logic [31:0]  RD
);

logic [31:0] word_addr = {A[31:2],2'b0};
logic [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin 
        $display("Lodaing rom.");
        $readmemh("instruction_code.mem", rom_array);
end;

assign RD = {rom_array[word_addr], rom_array[word_addr+1], rom_array[word_addr+2], rom_array[word_addr+3]}; // concatenate the 4 byte address to make the full word address

endmodule
