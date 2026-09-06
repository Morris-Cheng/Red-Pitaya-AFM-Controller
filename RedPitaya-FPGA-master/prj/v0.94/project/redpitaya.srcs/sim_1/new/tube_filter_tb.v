`timescale 1ns / 1ps
module tube_filter_tb();
    reg adc_clk = 1;
    always #5 adc_clk = ~adc_clk;
    
    reg reset = 0;
    reg signed [13:0] input_value = 0;
    wire signed [13:0] output_value;
    
    wire signed [23:0] x_d1;
    wire signed [23:0] x_d2;
    wire signed [23:0] y_d1;
    wire signed [23:0] y_d2;

    red_pitaya_dsp_tube tube_filter (
        .clk_i(adc_clk),
        .reset_i(reset),
        .dsp_i(input_value)
        //,
        //.dsp_o(output_value)
        
        ////////////////////////////////////////////////////////
        // Debug
//        ,
//        .raw_sum(output_value),
//        .x_d1(x_d1),
//        .x_d2(x_d2),
//        .y_d1(y_d1),
//        .y_d2(y_d2)
        ////////////////////////////////////////////////////////
    );
    
    initial begin
        reset = 0;
        #10;
        reset = 1;
        #10;
        @(posedge adc_clk);
        input_value = 1;
        @(posedge adc_clk);
        input_value = 2;
        @(posedge adc_clk);
        input_value = 3;
        @(posedge adc_clk);
        input_value = 4;
        @(posedge adc_clk);
        input_value = 5;
        @(posedge adc_clk);
        input_value = 6;
        #100;
        $finish;
    end
endmodule
