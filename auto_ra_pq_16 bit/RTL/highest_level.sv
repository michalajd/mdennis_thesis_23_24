`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/13/2022 12:49:00 PM
// Design Name: 
// Module Name: highest_level
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import pq_pkg::*;

module highest_level(input logic clk, rst, start,
                     output logic red, blue, green,
                     output logic [6:0] segs_n,
                     output logic [7:0] an_n,
                     output logic dp_n,
                     output logic sigIDLE, sigSTART, sigADD, sigREMOVE, sigDISPLAY, sigFULL, sigEMPTY);
                     
                     // WIRES
                     logic startDB, startSP;
                     logic rstDB, rstSP;
                     logic [2:0] rgb_r, rgb_g, rgb_b;
                     logic [7:0] data1, data2;
                     
                     
                     // START & RESET debounce / single pulse
                     //debounce sDB (.clk, .pb(start), .rst, .pb_debounced(startDB));
                     //single_pulser sSP (.clk, .din(startDB), .d_pulse(startSP));
                     
                     high_level CORE (.clk, .rst, .start(start), .data1, .data2, .red(rgb_r), .green(rgb_g), .blue(rgb_b),
                                      .sigIDLE, .sigSTART, .sigADD, .sigREMOVE, .sigDISPLAY, .sigFULL, .sigEMPTY);
                     
                     rgb_pwm RGB (.clk, .rst, .led_r(rgb_r), .led_g(rgb_g), .led_b(rgb_b), .color_r(red), .color_g(green), .color_b(blue));
                     
                     sevenseg_ctl SEVENSEG (.clk, .rst, .d7(7'b1111111), .d6(7'b1111111), .d5(7'b1111111), .d4(7'b1111111), 
                                            .d3({3'b0, data1[7:4]}), .d2({3'b0, data1[3:0]}), .d1({3'b0, data2[7:4]}), .d0({3'b0, data2[3:0]}), .segs_n, .dp_n, .an_n);
                     
                     
                     
                     
endmodule
