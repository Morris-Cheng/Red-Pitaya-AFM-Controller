`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 20:27:43
// Design Name: 
// Module Name: red_pitaya_dsp_tube
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


module red_pitaya_dsp_tube(
        input wire clk_i,
        input wire reset_i,
        input wire signed [13:0] dsp_i,
        output wire signed [13:0] dsp_o
    );
    
    // Stage 1 registers
    wire signed [13:0] stage1_output;
    wire signed [13:0] stage1_input = dsp_i;
    
    biquad_section #(
        .B0(34),
        .B1(68),
        .B2(34),
        .A1(-1073360183),
        .A2(536489407),
        .shift(29)
    ) stage1 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_i(stage1_input),
        .y_o(dsp_o)
    );
endmodule
