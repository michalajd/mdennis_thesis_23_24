import pq_pkg::*;

module quickqHW_wrapper(
    input logic clk, rst,
    input logic [7:0] key_in, value_in,
    input logic enq,
    output logic full,
    output logic busy,
    output logic empty,
    output logic [7:0] key_out, value_out,
    input logic deq
    );
    
    kv_t kvi, kvo;
    assign kvi.key = key_in;
    assign kvi.value = value_in;
    assign value_out = kvo.value;
    assign key_out = kvo.key;
    pq_if U_PQ_IF (.clk);

    quickq U_QUICKQ(U_PQ_IF.dev);

   // is it really this easy?
    assign U_PQ_IF.rst = rst;
    assign U_PQ_IF.kvi = kvi;
    assign U_PQ_IF.enq = enq;
    assign full = U_PQ_IF.full;
    assign busy = U_PQ_IF.busy;
    assign empty = U_PQ_IF.empty;
    assign kvo = U_PQ_IF.kvo;
    assign U_PQ_IF.deq = deq;

endmodule
