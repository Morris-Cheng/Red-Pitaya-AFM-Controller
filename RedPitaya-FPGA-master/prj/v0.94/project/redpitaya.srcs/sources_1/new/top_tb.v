`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/04 14:28:46
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    reg adc_clk = 0;
    
    reg signed [13:0] dsp_i_tube = 10;
    reg signed [13:0] dsp_i_stack = 100;
    reg dac_rst = 0;
    wire signed [13:0] dsp_o_tube;
    
    signal_multiply multiply(
    .input_1(dsp_i_tube),
    .input_2(dsp_i_stack),
    .clk_i(adc_clk),
    .reset_i(dac_rst),
    .output_1(dsp_o_tube)
);
    
    always #5 adc_clk = ~adc_clk;
    
    initial begin
        #5;
        dac_rst = 1;
        #10;
        dac_rst = 0;
        #100;
        $finish;
    end
endmodule
