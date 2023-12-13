//new data memery for cache
module Data_mem #(
    parameter ADDRESS_WIDTH = 5,           // total 2**5 number of address locations
              DATA_WIDTH = 8                // each location has 1 byte data
)(
    //INPUTS
    input   logic             clk,
    input   logic   [2:0]     WE,           //memory write enable
    input   logic   [31:0]    A,            //memory read/write address
    input   logic   [31:0]    WD,           //memory data in
    input   logic             cache_hit,

    //OUTPUTS
    output  logic   [31:0]    RD,            //memory data out
    output  logic             mem_ready
);

logic [ADDRESS_WIDTH - 1:0] addr;
logic [ADDRESS_WIDTH - 1:0] addr_2_cache;
logic [DATA_WIDTH - 1: 0] mem_array [2**ADDRESS_WIDTH - 1: 0];

always_comb begin
    case (WE[1])
        1'b1:   begin   //byte instr
            addr = A[ADDRESS_WIDTH - 1:0];  //convert A to 10 bit address length
        end

        1'b0:   begin   //word instr
            addr = {A[ADDRESS_WIDTH - 1:2],2'b0};
        end
    endcase

    addr_2_cache = {A[ADDRESS_WIDTH - 1:2],2'b0};
end

initial begin 
        $display("Lodaing Data_mem.");
        $readmemh("Data.mem", mem_array);
        $display("Load finished.");
        $display("memory ready.");

        // for running reference program
        // $display("Lodaing Data_mem.");
        // $readmemh("Data.mem", mem_array, 20'h10000, 20'h1FFFF);
        // $display("Load finished.");
        // $display("memory ready.");
end;

/*synced write*/
always_ff @( posedge clk ) begin
    case (WE[0])
        1'b0:   mem_ready <= 1;
        1'b1:   mem_ready <= 0;
    endcase
    case (WE)
        3'b1:   begin   //sw (store word)
            mem_array[addr + 3] <= WD[31: 24];
            mem_array[addr + 2] <= WD[23: 16];
            mem_array[addr + 1] <= WD[15: 8];
            mem_array[addr] <= WD[7: 0];
            if ((mem_array[addr + 3] == WD[31: 24]) && (mem_array[addr + 2] == WD[23: 16]) && (mem_array[addr + 1] == WD[15: 8]) && (mem_array[addr] == WD[7: 0])) mem_ready <= 1;
            else mem_ready <= 0;
        end

        3'b11:  begin   //sb (store byte)
            mem_array[addr] <= WD[7: 0];
            if (mem_array[addr] == WD[7: 0]) mem_ready <= 1;
            else mem_ready <= 0;
        end
        default:;
    endcase
end

/*async read*/
always_comb begin
    case (WE[0])
        1'b0: begin//load
            case (cache_hit)
                1'b0:   RD <= {mem_array[addr_2_cache + 3], mem_array[addr_2_cache + 2], mem_array[addr_2_cache + 1], mem_array[addr_2_cache]};
                1'b1:   RD <= {mem_array[addr_2_cache + 7], mem_array[addr_2_cache + 6], mem_array[addr_2_cache + 5], mem_array[addr_2_cache + 4]};
            endcase
        end
        1'b1: begin//store
            RD <= WD;
        end
    endcase
end

endmodule
