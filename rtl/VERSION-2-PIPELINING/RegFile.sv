module RegFile(
    //INPUTS
    input   logic             clk,               //clock
    input   logic             RegWrite,          //read register write enable
    input   logic   [4:0]     rs1,               //rs1 register addr
    input   logic   [4:0]     rs2,               //rs2 register addr
    input   logic   [4:0]     rd,                //write register addrs
    input   logic   [31:0]    WD3,               //Data to write to destination register rd
    input   logic             trigger,           //trigger (external input)

    //OUTPUTS    
    output  logic   [31:0]    RD1D,              //reg output 1
    output  logic   [31:0]    RD2D,              //reg output 2
    output  logic   [31:0]    a0                 //Output a0
);
    
logic [31:0] Reg_File [31:0];                    //Register file is made of 32, 32-bit registers

always_ff @(posedge clk) begin
    if (RegWrite)                                //If RegWrite is enabled, write to regsiter file
        if (rd==5'b0) Reg_File[rd] <= 32'b0;     //If writing to reg zero, just write 0 since it should be always 0
        else Reg_File[rd] <= WD3;                //Else if writing to any other registers, business as usual
end

always_comb begin
    RD1 = Reg_File[rs1];                         //Output the contents of the registers
    RD2 = Reg_File[rs2];
    if (trigger)    Reg_File[5] = 32'b1;
    a0 = Reg_File[10];                           //a0 is the 10th register, read out should be un-synced
end

endmodule
