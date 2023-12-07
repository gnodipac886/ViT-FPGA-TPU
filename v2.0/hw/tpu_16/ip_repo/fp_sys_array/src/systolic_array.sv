`timescale 1ns / 1ps

module systolic_array #(
	parameter INPUT_WIDTH 		= 32,
	parameter WEIGHT_WIDTH 		= 32,
	parameter OUTPUT_WIDTH		= 32,
	parameter NUM_ROWS 			= 16,
	parameter NUM_COLS 			= 16
)(
	input 	logic 						clk_i,
	input 	logic 						rst_n,
	input 	logic 	[INPUT_WIDTH-1:0] 	input_i 		[NUM_ROWS],
	input 	logic 						input_valid_i	[NUM_ROWS],
	input 	logic   [WEIGHT_WIDTH-1:0] 	weight_i 		[NUM_COLS],
	input 	logic 						weight_valid_i	[NUM_COLS],

	output 	logic 	[OUTPUT_WIDTH-1:0] 	output_o 		[NUM_ROWS][NUM_COLS],
	output	logic 						output_valid_o	[NUM_ROWS][NUM_COLS]
);

	/**************************** LOGIC DECLARATION *****************************/
	// assuming input is on the left
	// assuming weight is on the top
	logic 	[INPUT_WIDTH-1:0] 	_input_i 		[NUM_ROWS][NUM_COLS];
	logic 						_input_valid_i	[NUM_ROWS][NUM_COLS];
	logic   [WEIGHT_WIDTH-1:0] 	_weight_i 		[NUM_ROWS][NUM_COLS];
	logic 						_weight_valid_i	[NUM_ROWS][NUM_COLS];

	logic 	[INPUT_WIDTH-1:0] 	_input_o 		[NUM_ROWS][NUM_COLS];
	logic 						_input_valid_o	[NUM_ROWS][NUM_COLS];
	logic   [WEIGHT_WIDTH-1:0] 	_weight_o 		[NUM_ROWS][NUM_COLS];
	logic 						_weight_valid_o	[NUM_ROWS][NUM_COLS];
	// logic 						_output_valid_o	[NUM_ROWS][NUM_COLS];

	// logic 	[OUTPUT_WIDTH-1:0] 	output_o 		[NUM_ROWS][NUM_COLS];


	/**************************** GENERATE BLOCKS *******************************/
	generate
		for(genvar i = 0; i < NUM_ROWS; i++) begin
			for(genvar j = 0; j < NUM_COLS; j++) begin
				PE #(
					.INPUT_WIDTH		(INPUT_WIDTH),
					.OUTPUT_WIDTH		(OUTPUT_WIDTH)
				) pe (
					.clk_i				(clk_i),
					.rst_n				(rst_n),
					.input_i			(_input_i[i][j]),
					.input_valid_i		(_input_valid_i[i][j]),
					.weight_i			(_weight_i[i][j]),
					.weight_valid_i		(_weight_valid_i[i][j]),
					// .i					(i),
					// .j 					(j),
					.input_o			(_input_o[i][j]),
					.input_valid_o		(_input_valid_o[i][j]),
					.weight_o			(_weight_o[i][j]),
					.weight_valid_o		(_weight_valid_o[i][j]),
					.output_o			(output_o[i][j]),
					.output_valid_o		(output_valid_o[i][j])
				);
				if (i == 0) begin
					assign _weight_i[i][j] 			= weight_i[j];
					assign _weight_valid_i[i][j] 	= weight_valid_i[j];
				end

				if (j == 0) begin
					assign _input_i[i][j] 			= input_i[i];
					assign _input_valid_i[i][j] 	= input_valid_i[i];
				end

				if (i < NUM_ROWS - 1) begin 
					assign _weight_i[i+1][j] 		= _weight_o[i][j];
					assign _weight_valid_i[i+1][j] 	= _weight_valid_o[i][j];
				end

				if (j < NUM_COLS - 1) begin 
					assign _input_i[i][j+1] 		= _input_o[i][j];
					assign _input_valid_i[i][j+1] 	= _input_valid_o[i][j];
				end
			end
		end
	endgenerate

	/**************************** TASK DECLARATION ******************************/
	// task reset();

	// endtask : reset

	/**************************** FUNC DECLARATION ******************************/

	// function void set_action_defaults();
		
	// endfunction : set_action_defaults

	/******************************* COMB BLOCKS ********************************/
	// always_comb begin : NEXT_STATE_LOGIC
	// 	set_action_defaults();
	// end

	/******************************* PROC BLOCKS ********************************/
	// always_ff @(posedge clk_i) begin
	// 	if(~rst_n) begin
	// 		reset();
	// 	end else begin
			
	// 	end
	// end

endmodule