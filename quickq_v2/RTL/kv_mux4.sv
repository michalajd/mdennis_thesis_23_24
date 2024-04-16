`timescale 1ns / 1ps
import pq_pkg::*;

module kv_mux4(
    input kv_t a, b, c, d,
    input [1:0] s,
    output kv_t y
    );

     always_comb
        case (s)
            2'd0 : y = a;
            2'd1 : y = b;
            2'd2 : y = c;
            2'd3 : y = d;
            default : y = KV_EMPTY;
        endcase

endmodule
