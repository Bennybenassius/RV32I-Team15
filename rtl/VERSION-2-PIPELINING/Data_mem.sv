module Data_mem #(
    parameter ADDRESS_WIDTH = 17,           //2^17 locations in data mem
              DATA_WIDTH = 8                //each location has 1 byte data
)(
    //INPUTS
    input   logic             clk,
    input   logic   [2:0]     WE,           //memory write enable
    input   logic   [31:0]    A,            //memory read/write address
    input   logic   [31:0]    WD,           //memory data in 

    //OUTPUTS
    output  logic   [31:0]    RD            //memory data out
);

logic [ADDRESS_WIDTH - 1:0] addr;
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
end

initial begin 
        // uncomment this section to run F1
        $display("Lodaing Data_mem.");
        $readmemh("Data.mem", mem_array);
        $display("Load finished.");
        $display("memory ready.");

        // uncomment this section to run reference program
        // $display("Lodaing Data_mem.");
        // $readmemh("Data.mem", mem_array, 20'h10000, 20'h1FFFF);
        // $display("Load finished.");
        // $display("memory ready.");
end;

/*synced write*/
always_ff @( posedge clk ) begin
    case (WE)
        3'b1:   begin   //sw (store word)
            mem_array[addr + 3] <= WD[31: 24];
            mem_array[addr + 2] <= WD[23: 16];
            mem_array[addr + 1] <= WD[15: 8];
            mem_array[addr] <= WD[7: 0];
        end

        3'b11:  begin   //sb (store byte)
            mem_array[addr] <= WD[7: 0];
        end
        default:;
    endcase
end

/*async read*/
always_comb begin
    case (WE)
        3'b0:   begin   //lw (load word)
            RD = {mem_array[addr + 3], mem_array[addr + 2], mem_array[addr + 1], mem_array[addr]};
        end 

        3'b10:  begin   //lb (load byte)
            RD = {{24{mem_array[addr][DATA_WIDTH- 1]}}, mem_array[addr]};  //sign extend immediately and output
        end

        3'b110: begin   //lbu (load byte unsigned)
            RD = {24'b0, mem_array[addr]};  //zero extend immediately and output
        end
        default:;
    endcase
end
endmodule
