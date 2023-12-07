module Data_mem #(
    parameter ADDRESS_WIDTH = 10,           // total 2**5 number of address locations
              DATA_WIDTH = 8                // each location has 1 byte data
) (
    input   logic clk,
    input   logic   [2:0]     WE,           //memory write enable
    input   logic   [31: 0]   A,            //memory read address
    input   logic   [31:0]    WD,           //memory data in 
    output  logic   [31:0]    RD            //memory data out
);

logic [ADDRESS_WIDTH - 1:0] addr;
logic [DATA_WIDTH - 1: 0] mem_array [2**ADDRESS_WIDTH - 1: 0];

always_comb begin
    case (WE[1])
        1'b1:   begin   //byte instr
            addr = A;
        end

        1'b0:   begin   //word instr
            addr = {A[ADDRESS_WIDTH - 1:2],2'b0};
        end
    endcase
end

initial begin 
        $display("Lodaing Data_mem.");
        $readmemh("Data.mem", mem_array);
        $display("Load finished.");
        $display("memary ready.");
end;

/*synced write*/
always_ff @( posedge clk ) begin
    case (WE)
        3'b1:   begin   //sw (store word)
            mem_array[addr] <= WD[31: 24];
            mem_array[addr + 1] <= WD[23: 16];
            mem_array[addr + 2] <= WD[15: 8];
            mem_array[addr + 3] <= WD[7: 0];
        end

        3'b11:  begin   //sb (store byte)
            mem_array[addr] <= WD[7: 0];
        end
    endcase
end

/*unsynced read*/
always_comb begin
    case (WE)
        3'b0:   begin   //lw (load word)
            RD <= {mem_array[addr], mem_array[addr + 1], mem_array[addr + 2], mem_array[addr + 3]};
        end 

        3'b10:  begin   //lb (load byte)
            RD <= {{8{mem_array[addr][DATA_WIDTH- 1]}}, {8{mem_array[addr][DATA_WIDTH- 1]}}, {8{mem_array[addr][DATA_WIDTH- 1]}}, mem_array[addr]}  //sign extend immediately and output
        end

        3'b110: begin
            RD <= {8'b0, 8'b0, 8'b0, mem_array[addr]}  //zero extend immediately and output
        end
    endcase
end
endmodule
