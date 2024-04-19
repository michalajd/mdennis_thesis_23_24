module hwpq_test_tb;
    logic clk, rst, start_pb;
    logic empty_led, full_led, busy_led;
    logic [7:0] an_n;
    logic dp_n;
    logic segs_n;

    localparam CLKPD_NS = 10;

    always begin
        clk = 0; #(CLKPD_NS/2);
        clk = 1; #(CLKPD_NS/2);
    end

    hwpq_test DUV (
        .clk, .rst, .start_pb, .empty_led, .full_led, .busy_led,
        .an_n, .dp_n, .segs_n
        );

    initial begin
        rst = 1;
        start_pb = 0;
        #(CLKPD_NS + 1);
        rst = 0;
        start_pb = 1;
        #(CLKPD_NS);
        start_pb = 0;
        #(CLKPD_NS*512);
        $stop;
        start_pb = 1;
        #(CLKPD_NS);
        start_pb = 0;
        #(CLKPD_NS*512);
        $stop;
    end
endmodule

