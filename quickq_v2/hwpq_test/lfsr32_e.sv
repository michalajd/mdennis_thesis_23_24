//-----------------------------------------------------------------------------
// Module Name   : lfsr32_e - 32-bit LFSR with enable
// Project       : RTL Hardware Design and Verification using SystemVerilog
//-----------------------------------------------------------------------------
// Author        : John Nestor  <nestorj@lafayette.edu>
// Created       : April 2024
//-----------------------------------------------------------------------------
// Description   : 32-bit linear feedback shift register with enable
// Tap locations taken from Max Maxfield's LFSR Tutorial in EE Times:
// https://www.eetimes.com/tutorial-linear-feedback-shift-registers-lfsrs-part-1/
//-----------------------------------------------------------------------------

module lfsr32_e(
   input logic        clk, rst, enb,
   output logic [31:0] q
);

   logic [0:31] q_int;  // use reversed indexing to match Maxfield's tap numbering

   assign q = q_int;  // just to reverse the bits

   always_ff @(posedge clk)
       if (rst) q_int <= 32'd1;
       else if (enb) q_int <= { (q_int[1] ^ q_int[5] ^ q_int[6] ^ q_int[31]), q_int[0:30] };

endmodule