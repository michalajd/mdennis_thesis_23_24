`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2024 10:48:20 PM
// Design Name: 
// Module Name: quickq_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: code from sr_pq tb for now
// 
//////////////////////////////////////////////////////////////////////////////////
//`include "../pk_pkg.sv"
import pq_pkg::*;

module quickq_tb (pq_if.tb ti);

    task do_enq (input logic [KEY_WIDTH-1:0] key, input logic [VAL_WIDTH-1:0] val);
        ti.cb.kvi <= {key,val};
        ti.cb.enq <= 1;
        ti.cb.deq <= 0;
        @ti.cb;
        ti.cb.enq <=0;
        @ti.cb;
        while (ti.cb.busy) @ti.cb;
    endtask

    task do_deq();
        // while (ti.cb.ovalid==0) @ti.cb; // wait until there is something to remove
        assert(ti.cb.empty==0);
        ti.cb.enq <= 0;
        ti.cb.deq <= 1;
        @ti.cb;
        ti.cb.deq <= 0;
        @ti.cb;
        while (ti.cb.busy) @ti.cb;
    endtask

    task do_enq_and_deq(input logic [KEY_WIDTH-1:0] key, input logic [VAL_WIDTH-1:0] val);
        ti.cb.kvi <= {key,val};
        ti.cb.enq <= 1;
        ti.cb.deq <= 1;
        @ti.cb;
        ti.cb.enq <= 0;
        ti.cb.deq <= 0;
        @ti.cb;
        while (ti.cb.busy) @ti.cb;
    endtask

  initial begin
      @ti.cb;
      ti.cb.rst <= 1;
      ti.cb.enq <= 0;
      ti.deq <= 0;

      @ti.cb;
      ti.cb.rst <= 0;
      @ti.cb;
      @ti.cb;
      @ti.cb;
      @ti.cb;
      @ti.cb;
      do_enq(5,3);
      do_enq(10,1);
      do_enq(3,4);
      do_enq(20,10);
      do_enq(2,6);
      do_enq(12,7);
      do_enq(27,24);
      do_enq(8,17);
      @ti.cb;  // something funny here!
      do_enq_and_deq(9,9);
      do_enq_and_deq(4,1);
      do_enq_and_deq(15,16);
      do_enq_and_deq(30,0);
      while (!ti.cb.empty) do_deq();
      repeat (4) @ti.cb;
//      do_enq (12,12);
//      @(ti.cb);
//      do_enq(3,13);
//      do_enq(10,10);
//      @ti.cb;  // shoud register full here
//      do_deq();
//      do_enq(2,13);
//      @ti.cb;  // should register full again
//      do_enq_and_deq(1,11);
//      @ti.cb;
//      repeat(4) do_deq();
     $stop;
  end

endmodule: quickq_tb
