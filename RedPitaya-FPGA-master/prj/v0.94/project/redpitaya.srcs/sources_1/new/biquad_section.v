`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/14 10:46:55
// Design Name: 
// Module Name: biquad_section
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


module biquad_section #(
        parameter signed [31:0] B0 = 0,
        parameter signed [31:0] B1 = 0,
        parameter signed [31:0] B2 = 0,
        parameter signed [31:0] A1 = 0,
        parameter signed [31:0] A2 = 0,
        parameter signed shift = 27
    )(
        input wire clk_i,
        input wire reset_i,
        input wire signed [23:0] x_i, // x[n]
        output wire signed [23:0] y_o //y[n] DEBUG : change to wire
        
        ////////////////////////////////////////////////////////
        // Debug
//        ,
//        output wire signed [23:0] x1_o,
//        output wire signed [23:0] x2_o,
//        output wire signed [23:0] y1_o,
//        output wire signed [23:0] y2_o
        ////////////////////////////////////////////////////////
    );
    
    // Biquad delay variables
    //reg signed [23:0] x_reg1;
    reg signed [23:0] x_d1;
    reg signed [23:0] x_d2;
    reg signed [23:0] y_d1;
    reg signed [23:0] y_d2;
    
    // Product registers
    reg signed [63:0] B0_product;
    reg signed [63:0] B1_product;
    reg signed [63:0] B2_product;
    reg signed [63:0] A1_product;
    reg signed [63:0] A2_product;
    
    // Raw sum
    wire signed [63:0] raw_sum;
    //reg signed [63:0] raw_sum;
    
    always @(posedge clk_i) begin
        if(reset_i) begin
            //x_reg1 <= 0;
            x_d1 <= 0;
            x_d2 <= 0;
            y_d1 <= 0;
            y_d2 <= 0;
            B0_product <= 0;
            B1_product <= 0;
            B2_product <= 0;
            A1_product <= 0;
            A2_product <= 0;
            
            ////////////////////////////////////////////////////////
            // DEBUG
            //raw_sum <= 0;
            //y_o <= 0;
            ////////////////////////////////////////////////////////
        end
        else begin
//            x_reg1 <= x_i;
        
            // Calculate products
            B0_product <= B0*x_i;
            B1_product <= B1*x_d1;
            B2_product <= B2*x_d2;
            A1_product <= A1*y_d1;
            A2_product <= A2*y_d2;
            
            //raw_sum <= (B0_product + B1_product + B2_product - A1_product - A2_product);
            //y_o <= raw_sum >>> shift;
            
            // Update previous values
            x_d1 <= x_i;
            x_d2 <= x_d1;
            y_d1 <= y_o;
            y_d2 <= y_d1;
        end
    end
    
    assign raw_sum = B0_product + B1_product + B2_product - A1_product - A2_product;
    assign y_o = raw_sum >>> shift;
    
    ////////////////////////////////////////////////////////
    // DEBUG
//    assign x1_o = x_d1;
//    assign x2_o = x_d2;
//    assign y1_o = y_d1;
//    assign y2_o = y_d2;
    ////////////////////////////////////////////////////////
endmodule
