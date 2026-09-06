`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/07/03 22:47:31
// Design Name: 
// Module Name: red_pitaya_data_register
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


module red_pitaya_data_register(
        input wire clk_i,
        input wire reset_i,
        input wire read_enable_i,
        output wire empty_o,
        input wire [15:0] decimation_i,
        input wire [13:0] data_i,
        output wire [13:0] data_o
    );
    
    reg [15:0] counter;
    reg wr_en;
    wire full;
    
    fifo_generator_tube fifo (
      .clk(clk_i),      // input wire clk
      .srst(!reset_i),    // input wire srst
      .din(data_i),      // input wire [15 : 0] din
      .wr_en(wr_en),  // input wire wr_en
      .rd_en(read_enable_i),  // input wire rd_en
      .dout(data_o),    // output wire [15 : 0] dout
      .full(full),    // output wire full
      .empty(empty_o)  // output wire empty
    );
    
    always @(posedge clk_i) begin
        if(!reset_i) begin // active low reset
            counter <= 0;
            wr_en <= 1'b0;
        end
        else begin
            if(counter >= decimation_i- 1) begin
                counter <= 0;
                wr_en <= 1'b1;
            end
            else begin
                counter <= counter + 1'b1;
                wr_en <= 1'b0;
            end
        end
    end
endmodule
