`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/06 20:27:43
// Design Name: 
// Module Name: red_pitaya_dsp_stack
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


module red_pitaya_dsp_stack(
    input wire clk_i,
    input wire reset_i,
    input wire signed [13:0] dsp_i,
    output wire signed [13:0] dsp_o
    );

    assign dsp_o = dsp_i;
endmodule