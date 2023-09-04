`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2021 02:25:22 PM
// Design Name: 
// Module Name: rgb_pwm
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


module rgb_pwm(input logic clk, rst,
               input logic [2:0]led_r, led_g, led_b,
               output logic color_r, color_g, color_b);
           
           // The internal wire for the counter     
           logic [3:0]q;
           
           always_ff @(posedge clk)
                if(rst) q <= 0;
                else q = q + 1;    
             
           // Converts the three bit led inputs into a single bit color output.
                
                    assign color_r = (q < {1'b0, led_r});
                    
                    assign color_g = (q < {1'b0, led_g});
                    
                    assign color_b = (q < {1'b0, led_b});
                    
                
       
endmodule
