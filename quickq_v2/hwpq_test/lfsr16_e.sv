//-----------------------------------------------------------------------------
// Module Name   : lfsr16_e - 16-bit LFSR with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : 32-bit linear feedback shift register with enable
// Tap locations taken from Max Maxfield's LFSR Tutorial in EE Times:
// https://www.eetimes.com/tutorial-linear-feedback-shift-registers-lfsrs-part-1/
//-----------------------------------------------------------------------------

module lfsr16_e(
   input logic        clk, rst, enb,
   output logic [15:0] q
);

   logic [0:15] q_int;  // use reversed indexing to match Maxfield's tap numbering

   assign q = q_int;  // just to reverse the bits

   always_ff @(posedge clk)
       if (rst) q_int <= 32'd1;
       else if (enb) q_int <= { (q_int[1] ^ q_int[2] ^ q_int[4] ^ q_int[15]), q_int[0:14] };

endmodule