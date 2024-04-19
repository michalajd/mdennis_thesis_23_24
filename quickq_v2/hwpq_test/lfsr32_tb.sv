//-----------------------------------------------------------------------------
// Module Name   : lfsr32_e_tb - Testbench for 32-bit LFSR with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : 32-bit linear feedback shift register with enable
// Source: https://www.eetimes.com/tutorial-linear-feedback-shift-registers-lfsrs-part-1/
//-----------------------------------------------------------------------------


module lfsr32_e_tb;



    logic clk, rst, enb;
    logic [31:0] q;

    localparam CLKPD_NS = 10;

    always begin
        clk = 0; #(CLKPD_NS/2);
        clk = 1; #(CLKPD_NS/2);
    end

    lfsr32_e DUV (.clk, .rst, .enb, .q);

    initial begin
        rst = 1;
        enb = 0;
        #(CLKPD_NS+1);
        rst = 0;
        #(CLKPD_NS);
        enb = 1;
        #(CLKPD_NS*20);
        $stop;
        #(CLKPD_NS*100);
        $stop;
    end
    
endmodule