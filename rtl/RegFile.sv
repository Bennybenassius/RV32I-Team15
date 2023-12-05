module RegFile(
    input   logic             clk,        //clock
    input   logic             RegWrite,   //read register write enable
    input   logic   [4:0]     rs1,        //rs1 register addr
    input   logic   [4:0]     rs2,        //rs2 register addr
    input   logic   [4:0]     rd,         //read register addrs
    input   logic   [31:0]    WD3,        //Data to write to destination register rd
    
    output  logic   [31:0]    RD1,     //reg output 1
    output  logic   [31:0]    RD2,     //reg output 2
    output  logic   [31:0]    a0          //Output a0
);
    
logic [31:0] Reg_File [31:0]; //Register file is made of 32, 32-bit registers

always_ff @(posedge clk) begin
    if (RegWrite)               //If RegWrite is enabled, write to regsiter file
        Reg_File[rd] <= WD3; 
end

always_comb begin
    RD1 = Reg_File[rs1];    //Output the contents of the registers
    RD2 = Reg_File[rs2];
    a0 = Reg_File[10];         //a0 is the 10th register, read out should be un-synced
end

endmodule
