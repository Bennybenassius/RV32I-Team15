module cache (
    //INPUT
    input clk,
    input logic [2: 1]  WE,
    input logic [31: 0] A,
    input logic [31: 0] WriteDataCache_i,

    //OUTPUT
    output logic cache_hit,
    output logic [31: 0] ReadDataCache_o

);

logic [59: 0] cache_array [7: 0];
logic [2: 0] setNmb;
logic [2: 0] setNmb_pluse1;
logic [1: 0] byte_setNmb;
logic [26: 0] tag;

always_comb begin
    setNmb = A[4: 2];
    setNmb_pluse1 = setNmb + 1;
    byte_setNmb = A[1: 0];
    tag = A[31: 5];
    cache_hit <= cache_array[setNmb][59] && (cache_array[setNmb][58: 32] == tag);
    if (cache_hit) begin
        cache_array[setNmb][59] <= 1'b0; 
    end
end

// we do data replacement at negedge
always_ff @( negedge clk ) begin
    case (cache_hit)
        1'b1:   begin   //if hit do: replacement for set + 1
            cache_array[setNmb_pluse1] = {1'b1,tag,WriteDataCache_i};
        end
        1'b0: begin     //if not hit do: replacememnt for current set
            cache_array[setNmb] = {1'b1,tag,WriteDataCache_i};
        end
        default:;
    endcase
end

// we do write in data at posedge
always_ff @( posedge clk ) begin
    case (WE)
        3'b01:   begin   //sw, if write memory, also write cache
            cache_array[setNmb] <= {1'b1,tag,WriteDataCache_i};
        end
        3'b11:   begin  //sb, if write memory, also write cache
            case (byte_setNmb)
                2'b00:  cache_array[setNmb] <= {1'b1, cache_array[setNmb][58:32], cache_array[setNmb][31:24], cache_array[setNmb][23:16], cache_array[setNmb][15:8],  WriteDataCache_i[7:0]};
                2'b01:  cache_array[setNmb] <= {1'b1, cache_array[setNmb][58:32], cache_array[setNmb][31:24], cache_array[setNmb][23:16], WriteDataCache_i[7:0]    ,  cache_array[setNmb][7:0]};
                2'b10:  cache_array[setNmb] <= {1'b1, cache_array[setNmb][58:32], cache_array[setNmb][31:24], WriteDataCache_i[7:0]     , cache_array[setNmb][15:8],  cache_array[setNmb][7:0]};
                2'b11:  cache_array[setNmb] <= {1'b1, cache_array[setNmb][58:32], WriteDataCache_i[7:0]     , cache_array[setNmb][23:16], cache_array[setNmb][15:8],  cache_array[setNmb][7:0]};
                default:;
            endcase
        end
        default:;
    endcase
end

//always cache read out (the incorrect read out will not be accepted by MW register, and that is controled by stall_all output signal in M_cache.sv depend on cache_hit)
always_comb begin
    case (WE)
        3'b00:   begin  //lw
            ReadDataCache_o = cache_array[setNmb][31: 0];
        end
        3'b10:   begin  //lb
            case (byte_setNmb)
                2'b00:  ReadDataCache_o <= {24*{cache_array[setNmb][7]}, cache_array[setNmb][7: 0]};
                2'b01:  ReadDataCache_o <= {24*{cache_array[setNmb][15]}, cache_array[setNmb][15: 8]};
                2'b10:  ReadDataCache_o <= {24*{cache_array[setNmb][23]}, cache_array[setNmb][23: 16]};
                2'b11:  ReadDataCache_o <= {24*{cache_array[setNmb][31]}, cache_array[setNmb][31: 24]};
                default:;
            endcase
        end
        3'b110:   begin //lbu
            case (byte_setNmb)
                2'b00:  ReadDataCache_o <= {24'b0, cache_array[setNmb][7: 0]};
                2'b01:  ReadDataCache_o <= {24'b0, cache_array[setNmb][15: 8]};
                2'b10:  ReadDataCache_o <= {24'b0, cache_array[setNmb][23: 16]};
                2'b11:  ReadDataCache_o <= {24'b0, cache_array[setNmb][31: 24]};
                default:;
            endcase
        end
        default:;
    endcase
end

endmodule
