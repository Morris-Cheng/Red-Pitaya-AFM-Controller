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
        parameter signed shift = 29
    )(
        input wire clk_i,
        input wire reset_i,
        input wire signed [13:0] x_i, // x[n]
        output wire signed [13:0] y_o //y[n]
        
        ///////////////////////////////////////////////////////////////////////
        // Debug
        ,
        output wire signed [51:0] sum,
        output wire signed [51:0] scaled_sum,
        output wire signed [13:0] x_input,
        output wire signed [13:0] x_input_d1,
        output wire signed [13:0] x_input_d2,
        output wire signed [13:0] y_output,
        output wire signed [13:0] y_output_d1,
        output wire signed [13:0] y_output_d2,
        output wire signed [49:0] b0_product_out,
        output wire signed [49:0] b1_product_out,
        output wire signed [49:0] b2_product_out,
        output wire signed [49:0] a1_product_out,
        output wire signed [49:0] a2_product_out
        ///////////////////////////////////////////////////////////////////////
    );
    
    // Biquad delay variables
    reg signed [13:0] x_d1;
    reg signed [13:0] x_d2;
    wire signed [51:0] y_d1; // y[n-1] stores scaled version of raw sum
    reg signed [51:0] y_d2;
    
    // Product registers
    reg signed [49:0] B0_product;
    reg signed [49:0] B1_product;
    reg signed [49:0] B2_product;
    // larger size to account for feedback term (y[n-1] y[n-2]) is much larger than the feedforward term (x[n], x[n-1], x[n-2])
    // Size calculation: final bit size is original size (29) + shift to for accumulator
    wire signed [83:0] A1_product;
    wire signed [83:0] A2_product;
    
    // Extra registers used to store the scaled back version (back to raw_sum) of the A1 and A2 products
    wire signed [54:0] A1_product_raw_sum_scale;
    wire signed [54:0] A2_product_raw_sum_scale;
    
    // Extra registers used to store the satuarted products
    wire signed [49:0] A1_product_raw_sum_scale_saturated;
    wire signed [49:0] A2_product_raw_sum_scale_saturated;
    
    // Raw sum
    wire signed [51:0] raw_sum;
    
    // Scaled output (not saturated yet)
    wire signed [51:0] scaled_y;
    
    // Final y_o (with saturation)
    wire signed [13:0] y_o_final;
    
    mult_gen_0 a1_multiplier (
      .CLK(clk_i),  // input wire CLK
      .A(A1),      // input wire [31 : 0] A
      .B(y_d1),      // input wire [51 : 0] B
      .SCLR(!reset_i),
      .P(A1_product)      // output wire [83 : 0] P
    );
    
    mult_gen_0 a2_multiplier (
      .CLK(clk_i),  // input wire CLK
      .A(A2),      // input wire [31 : 0] A
      .B(y_d2),      // input wire [51 : 0] B
      .SCLR(!reset_i),
      .P(A2_product)      // output wire [83 : 0] P
    );
    
    always @(posedge clk_i) begin
        if(!reset_i) begin
            x_d1 <= 0;
            x_d2 <= 0;
            y_d2 <= 0;
            B0_product <= 0;
            B1_product <= 0;
            B2_product <= 0;
        end
        else begin
            // Calculate products
            B0_product <= B0 * x_i;
            B1_product <= B1*x_d1;
            B2_product <= B2*x_d2;
            
            // Update previous values
            x_d1 <= x_i;
            x_d2 <= x_d1;
            y_d2 <= y_d1;
        end
    end
    
    // Scale A1_proudct and A2_product back to raw_sum scale
    assign A1_product_raw_sum_scale = A1_product >>> shift;
    assign A2_product_raw_sum_scale = A2_product >>> shift;
    
    // Saturation logic for the scaled products
    assign A1_product_raw_sum_scale_saturated = (A1_product_raw_sum_scale > 55'sd562949953421311) ? 50'sd562949953421311 :
                                           (A1_product_raw_sum_scale < -55'sd562949953421312) ? -50'sd562949953421312 :
                                            A1_product_raw_sum_scale[49:0];
    assign A2_product_raw_sum_scale_saturated = (A2_product_raw_sum_scale > 55'sd562949953421311) ? 50'sd562949953421311 :
                                           (A2_product_raw_sum_scale < -55'sd562949953421312) ? -50'sd562949953421312 :
                                            A2_product_raw_sum_scale[49:0];
    
    // Summing up all products together
    assign raw_sum = {{2{B0_product[49]}}, B0_product}
                 + {{2{B1_product[49]}}, B1_product}
                 + {{2{B2_product[49]}}, B2_product}
                 - {{2{A1_product_raw_sum_scale_saturated[49]}}, A1_product_raw_sum_scale_saturated}
                 - {{2{A2_product_raw_sum_scale_saturated[49]}}, A2_product_raw_sum_scale_saturated};
                 
    assign scaled_y = raw_sum >>> shift;
                 
    // Saturation logic for output y
    assign y_o_final = (scaled_y > 52'sd8191)  ? 14'sd8191 :
                     (scaled_y < -52'sd8192) ? -14'sd8192 : 
                     scaled_y[13:0];
                              
    assign y_o = y_o_final;
    
    // Feeding back raw_sum for higher precision
    assign y_d1 = raw_sum;
    
    ///////////////////////////////////////////////////////////////////////
    // Debug
    assign sum = raw_sum;
    assign scaled_sum = scaled_y;
    assign x_input = x_i;
    assign x_input_d1 = x_d1;
    assign x_input_d2 = x_d2;
    assign y_output = y_o;
    assign y_output_d1 = y_d1;
    assign y_output_d2 = y_d2;
    assign b0_product_out = B0_product;
    assign b1_product_out = B1_product;
    assign b2_product_out = B2_product;
    assign a1_product_out = A1_product_raw_sum_scale_saturated;
    assign a2_product_out = A2_product_raw_sum_scale_saturated;
    ///////////////////////////////////////////////////////////////////////
endmodule
