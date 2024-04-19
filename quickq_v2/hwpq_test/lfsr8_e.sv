//-----------------------------------------------------------------------------
// Module Name   : lfsr8_e - 8-bit LFSR with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : 8-bit linear feedback shift register with enable
// Tap locations taken from Max Maxfield's LFSR Tutorial in EE Times:
// https://www.eetimes.com/tutorial-linear-feedback-shift-registers-lfsrs-part-1/
//-----------------------------------------------------------------------------

module lfsr8_e(
   input logic        clk, rst, enb,
   output logic [7:0] q
);

   logic [0:7] q_int;  // use reversed indexing to match Maxfield's tap numbering

   assign q = q_int;

   always_ff @(posedge clk)
       if (rst) q_int <= 8'hff;
       else if (enb) q_int <= { (q_int[1] ^ q_int[2] ^ q_int[3] ^ q_int[7]), q_int[0:6] };

endmodule