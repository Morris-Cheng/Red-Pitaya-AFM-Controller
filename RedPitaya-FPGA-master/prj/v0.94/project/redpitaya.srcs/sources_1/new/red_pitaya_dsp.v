`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/01 13:16:33
// Design Name: 
// Module Name: red_pitaya_dsp
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


module red_pitaya_dsp(
        input wire clk_i,
        input wire reset_i,
        input wire signed [13:0] dsp_i,
        output wire signed [13:0] dsp_o
    );
    
    reg signed [13:0] dsp_o_d;
    reg signed [31:0] dsp_o_scaled;
    
    localparam signed [31:0] COEFF_A = 32'd1054;
    localparam signed [31:0] COEFF_B = 32'd4193250;
    
    always @(posedge clk_i) begin
        if(!reset_i) begin
            dsp_o_d <= 0;
            dsp_o_scaled <= 0;
        end
        else begin
            dsp_o_scaled <= (COEFF_A * dsp_i) + (COEFF_B * dsp_o_d);
            dsp_o_d <= dsp_o_scaled >>> 22;
        end
    end
    
    assign dsp_o = dsp_o_scaled >>> 22;
endmodule
