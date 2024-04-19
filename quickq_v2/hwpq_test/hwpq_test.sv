//-----------------------------------------------------------------------------
// Name          : hwpq_test
// Project       : HWPQ: Hardware Priority Queue Study
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : Hardware test apprartus for testing Hardware Priority Queues
// 
//-----------------------------------------------------------------------------


module hwpq_test (
    input logic clk, rst, fill_pb, empty_pb, enq_pb, deq_pb,
    input logic [15:0] SW,
    output empty_led, full_led, busy_led,
    output logic [7:0] an_n,
    output logic dp_n,
    output logic [6:0] segs_n
);

    logic fill_in, empty_in, enq_in, deq_in;
    logic r_enb, busy, full, empty;
    logic enq, deq;
    logic enb_lfsr, sel_in;
    

    single_pulser FILLSP (.clk, .din(fill_pb), .d_pulse(fill_in));
    single_pulser EMPTYSP (.clk, .din(empty_pb), .d_pulse(empty_in));
    single_pulser ENQSP (.clk, .din(enq_pb), .d_pulse(enq_in));
    single_pulser DEQSP (.clk, .din(deq_pb), .d_pulse(deq_in));


    period_enb #(.PERIOD_MS(250)) PENB (.clk, .rst, .clr(1'b0), .enb_out(r_enb));

    logic [7:0] key_in, value_in, count, lfsr_out, key_out, value_out;

    lfsr8_e LFSR (.clk, .rst, .enb(enb_lfsr), .q(lfsr_out));

    counter #(.W(8)) CTR (.clk, .rst, .enb(enb_lfsr), .q(count));
    
    assign key_in = (sel_in ? SW[15:8] : lfsr_out);
    assign value_in = (sel_in ? SW[7:0] : count);


    hwpq_test_ctl CTL (
        .clk, .rst, .fill_in, .empty_in, .enq_in, .deq_in, .r_enb,
        .busy, .full, .empty, .enb_lfsr, .sel_in, .enq, .deq
    );

    heap_pq_wrapper HWWRAP (
        .clk, .rst, .key_in, .value_in, .enq, .full, .busy, .empty, .key_out, .value_out, .deq
    );

    assign busy_led = busy;
    assign full_led = full;
    assign empty_led = empty;

    logic [6:0] BLD;
    assign BLD = 7'b1000000;
    
    logic [6:0] d7, d6, d5, d4, d3, d2, d1, d0;
    
    assign d7 = {3'b000, key_in[7:4]};
    assign d6 = {3'b000, key_in[3:0]};
    assign d5 = {3'b000, value_in[7:4]};
    assign d4 = {3'b000, value_in[3:0]};
    assign d3 = {3'b000, key_out[7:4]};
    assign d2 = {3'b000, key_out[3:0]};
    assign d1 = {3'b000, value_out[7:4]};
    assign d0 = {3'b000, value_out[3:0]};

     sevenseg_ctl SSEG(
        .clk, .rst, .d7, .d6,
        .d5, .d4, .d3, .d2, .d1, .d0,
        .segs_n, .dp_n, .an_n
     );





    
    
endmodule