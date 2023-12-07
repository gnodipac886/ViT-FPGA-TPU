`timescale 1ns / 1ps

module systolic_array_wrapper #(
	parameter INPUT_WIDTH 		= 32,
	parameter WEIGHT_WIDTH 		= 32,
	parameter OUTPUT_WIDTH		= 32,
	parameter NUM_ROWS 			= 16,
	parameter NUM_COLS 			= 16
)(
	input 	logic 						clk_i,
	input 	logic 						rst_n,
	input 	logic                       _input_i,
	input 	logic                       _input_valid_i,
	input 	logic                       _weight_i,
	input 	logic                       _weight_valid_i,

	output 	logic                       _output_o 		[NUM_ROWS]
);
	logic 	[INPUT_WIDTH-1:0] 	input_i 		[NUM_ROWS];
	logic 						input_valid_i	[NUM_ROWS];
	logic   [WEIGHT_WIDTH-1:0] 	weight_i 		[NUM_COLS];
	logic 						weight_valid_i	[NUM_COLS];

	logic 	[OUTPUT_WIDTH-1:0] 	output_o 		[NUM_ROWS][NUM_COLS];

	always_comb begin
		for (int i = 0; i < NUM_ROWS; i++) begin 
			input_i[i]         = {'0, _input_i};
			input_valid_i[i]   = _input_valid_i;
			_output_o[i]		= 1'b1;
			for (int j = 0; j < NUM_COLS; j++) begin
				if (i == 0) begin 
					weight_i[j]			= {'0, _weight_i};
					weight_valid_i[j]	= _weight_valid_i;
				end
				_output_o[i] &= output_o[i][j];
			end
		end
	end

	systolic_array sys_arr(.*);

endmodule