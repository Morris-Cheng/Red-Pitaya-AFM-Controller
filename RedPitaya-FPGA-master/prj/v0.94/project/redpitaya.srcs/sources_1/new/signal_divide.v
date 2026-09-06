module signal_divide(
        input wire signed [13:0] input_1,
        input wire signed [13:0] input_2,
        output wire signed [13:0] output_1
    );
    
    assign output_1 = input_1 / input_2;
endmodule