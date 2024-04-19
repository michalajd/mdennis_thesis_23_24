//-----------------------------------------------------------------------------
// Name          : hwpq_test_ctl
// Project       : HWPQ: Hardware Priority Queue Study
//-----------------------------------------------------------------------------
// Author        : John Nestor
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : Controller to fill and empty a priority queue using
// an LFSR to generate psuedorandom key values.
// 
//-----------------------------------------------------------------------------

module hwpq_test_ctl(
    input logic clk, rst, fill_in, empty_in, enq_in, deq_in, r_enb,
    input logic busy, full, empty,
    output logic enb_lfsr, sel_in, enq, deq
);

    typedef enum logic [1:0] { IDLE, FILL_Q, EMPTY_Q } state_t;

    state_t state, next;

    always_ff @(posedge clk) begin
        if (rst) state <= IDLE;
        else state <= next;
    end

    always_comb begin
        enb_lfsr = 0;
        sel_in = 0;
        enq = 0;
        deq = 0;
        next = IDLE;
        case (state)
        IDLE: begin
            if (fill_in) next = FILL_Q;
            else if (empty_in) next = EMPTY_Q;
            else if (enq_in) begin
                sel_in = 1;
                enq = 1;
                next = IDLE;
            end
            else if (deq_in) begin
                deq = 1;
                next = IDLE;
            end
            else next = IDLE;
        end
        FILL_Q: begin
            if (!busy && r_enb) begin
                if (full) begin
                    next = IDLE;
                end
                else begin
                    enb_lfsr = 1;
                    enq = 1;
                    next = FILL_Q;
                end
            end
            else begin
                next = FILL_Q;
            end
        end
        EMPTY_Q: begin
            if (!busy && r_enb) begin
                if (empty) begin
                    next = IDLE;
                end
                else begin
                    deq = 1;
                    next = EMPTY_Q;
                end
            end
            else begin
                next = EMPTY_Q;
            end
        end
        endcase
    end

endmodule