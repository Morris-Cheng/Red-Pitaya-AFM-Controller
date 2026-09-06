module signal_multiply(
        input wire signed [13:0] input_1,
        input wire signed [13:0] input_2,
        input wire clk_i,
        input wire reset_i,
        output reg signed [13:0] output_1
    );
    
    reg signed [63:0] multipler_buffer;
    localparam max_value = 14'sd8191;
    localparam min_value = -14'sd8192;
    
    always @(posedge clk_i) begin
        if(reset_i) begin
            multipler_buffer <= 0;
            output_1 <= 0;
        end
        else begin
            multipler_buffer <= input_1 * input_2;
            
            if(multipler_buffer[13:0] >= max_value) begin
                output_1 <= max_value;
            end
            else if(multipler_buffer[13:0] < max_value && multipler_buffer[13:0] < min_value) begin
                output_1 <= multipler_buffer[13:0];
            end
            else begin  
                output_1 <= min_value;
            end
        end
    end
endmodule