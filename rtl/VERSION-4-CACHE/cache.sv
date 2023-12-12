module cache (
    input clk,
    input logic WECache_i,
    input logic [2: 0] setNmb,
    input logic [26: 0] tag,
    input logic [31: 0] WriteDataCache_i,

    output logic hit,
    output logic [31: 0] ReadDataCache_o,

);
    

logic [59: 0] cache_array [7: 0]

always_ff @( posedge clk ) begin
    case (WECache_i)
        1'b1:   begin
            cache_array[setNmb] = {1'b1,tag,WriteDataCache_i}
        end
        default:;
    endcase
end

always_comb begin
    case (WECache_i)
        1'b0:   begin
            hit = cache_array[setNmb][59] && (cache_array[setNmb][58: 32] == tag);
            ReadDataCache_o = cache_array[setNmb][31: 0];
        end
        default:;
    endcase
end

endmodule
