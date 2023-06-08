`timescale 1 ps / 1 ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2023 08:27:47 PM
// Design Name: 
// Module Name: led_driver
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
`define KHZ 100000
`define KHZ_HALF `KHZ >> 1

module led_driver(
    input wire clk_i,
    input wire rst_n_i,
    input wire [63:0] src_i,
    input wire override_i,
    output reg [7:0] led_o
    );

    wire slow_clk_i;
    reg [31:0] _counter;
    reg [7:0] _buffer;
    integer i;

    assign slow_clk_i = _counter >= `KHZ_HALF;

    always @(clk_i) begin
        if(~rst_n_i) begin 
            _buffer <= 7'd0;
            _counter <= 32'd0;
        end else begin
            if (_counter == `KHZ) begin 
                _counter <= 32'd0;
            end else begin 
                _counter <= _counter + 1;
            end 
            if (|src_i) begin 
                for (i = 0; i < 8; i = i + 1) begin 
                    _buffer[i] <= |src_i[i<<3 +: 8];
                end
            end
        end 
    end

    always @(slow_clk_i) begin 
        led_o <= override_i | _buffer[7];
        led_o[6:0] <= _buffer[6:0];
    end 
endmodule
