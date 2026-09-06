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
    reg signed [13:0] dsp_i_tube = 0;
    wire signed [13:0] dsp_o_tube;

    red_pitaya_dsp tube_filter (
        .clk_i(adc_clk),    //clock
        .dsp_i(dsp_i_tube), //dsp input signal
        .dsp_o(dsp_o_tube)  //dsp output signal
    );
    
    logic sys_ren_d;
    reg adc_rstn = 0;
    reg sys_ren = 0;

    always @(posedge adc_clk) begin
        if(adc_rstn) begin
            sys_ren_d <= 0;
        end
        else begin
            sys_ren_d <= sys_ren;
        end
    end
    
    logic read_enable_rising_edge;
    logic tube_read_enable;
    
    assign read_enable_rising_edge = sys_ren && !sys_ren_d;
//    assign tube_read_enable = read_enable_rising_edge;

    wire fifo_empty_tube;
    reg [15:0] fifo_decimation_o;
    reg [13:0] fifo_data_tube;

    red_pitaya_data_register data_register_tube (
        .clk_i(adc_clk),
        .reset_i(adc_rstn),
        .read_enable_i(tube_read_enable), // only reads when C++ script asks for data
        .empty_o(fifo_empty_tube),
        .decimation_i(fifo_decimation_o),
        .data_i(dsp_o_tube),
        .data_o(fifo_data_tube)
    );

    always #5 adc_clk = ~adc_clk;
    always @(posedge adc_clk) begin
        dsp_i_tube <= dsp_i_tube + 2;
    end
    
    initial begin
        fifo_decimation_o = 2;
        adc_rstn <= 0;
        #5;
        adc_rstn <= 1;
        #50;
        tube_read_enable = 1;
        #5;
        tube_read_enable = 0;
        #35;
        tube_read_enable = 1;
        #5;
        tube_read_enable = 0;
        #50;
        tube_read_enable = 1;
        #5;
        tube_read_enable = 0;
        #500;
        $finish;
    end
endmodule
