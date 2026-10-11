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
    // Global clock
    reg adc_clk = 0;
    always #5 adc_clk = ~adc_clk;
    
    reg reset = 1;
    reg signed [13:0] x_i = 0;
    wire signed [13:0] y_o;
    
    biquad_section #(
        .B0(34),
        .B1(68),
        .B2(34),
        .A1(-1073360183),
        .A2(536489407),
        .shift(29)
    ) test_section (
        .clk_i(adc_clk),
        .reset_i(reset),
        .x_i(x_i),
        .y_o(y_o)
    );
    
//    reg signed [13:0] sine_mem [0:999];
//    integer sine_index;

//    // Load MATLAB-generated sine wave
//    initial begin
//        $readmemh("sine.mem", sine_mem);
//        sine_index = 0;
//    end
    
//    always @(posedge adc_clk) begin
//        if (!reset) begin
//            sine_index <= 0;
//            x_i <= 0;
//        end
//        else begin
//            x_i <= sine_mem[sine_index];

//            if (sine_index < 999)
//                sine_index <= sine_index + 1;
//            else
//                sine_index <= 0;
//        end
//    end
    
    initial begin
        @(posedge adc_clk);
        reset <= 0;
        @(posedge adc_clk);
        reset <= 1;
        @(posedge adc_clk);
        x_i <= 8000;
        #999999;
        $finish;
    end
endmodule
