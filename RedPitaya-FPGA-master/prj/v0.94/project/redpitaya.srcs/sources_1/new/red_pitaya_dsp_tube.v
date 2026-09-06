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
        output reg signed [13:0] dsp_o
        
        ////////////////////////////////////////////////////////
        // Debug
//        ,
//        output wire signed [23:0] raw_sum,
//        output wire signed [23:0] x_d1,
//        output wire signed [23:0] x_d2,
//        output wire signed [23:0] y_d1,
//        output wire signed [23:0] y_d2
        ////////////////////////////////////////////////////////
    );
    
    // Stage 1 registers
    wire signed [23:0] stage1_output;
    wire signed [23:0] stage1_input = { {10{dsp_i[13]}}, dsp_i }; // extending the sign of the input
    biquad_section #(
        .B0(32768),
        .B1(65536),
        .B2(32768),
        .A1(-65513),
        .A2(32745),
        .shift(15)
    ) stage1 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .x_i(stage1_input),
        .y_o(stage1_output)
        
        ////////////////////////////////////////////////////////
        // DEBUG
//        ,
//        .x1_o(x_d1),
//        .x2_o(x_d2),
//        .y1_o(y_d1),
//        .y2_o(y_d2)
        ////////////////////////////////////////////////////////
    );
    
    localparam integer DSP_OUTPUT_WIDTH = 14;
    localparam signed [23:0] DSP_O_MAX = (1 <<< (DSP_OUTPUT_WIDTH-1)) - 1;
    localparam signed [23:0] DSP_O_MIN = -(1 <<< (DSP_OUTPUT_WIDTH-1));
    
    always @(posedge clk_i) begin
        if(reset_i) begin
            dsp_o <= 0;
        end
        else begin
            // truncate 24 bit singed value to 14 bit signed value
            if(stage1_output > DSP_O_MAX) begin
                dsp_o <= DSP_O_MAX[DSP_OUTPUT_WIDTH-1:0];
            end
            else if (stage1_output < DSP_O_MIN) begin
                dsp_o <= DSP_O_MIN[DSP_OUTPUT_WIDTH-1:0];
            end
            else begin
                dsp_o <= stage1_output[DSP_OUTPUT_WIDTH-1:0];
            end
        end
    end
endmodule
