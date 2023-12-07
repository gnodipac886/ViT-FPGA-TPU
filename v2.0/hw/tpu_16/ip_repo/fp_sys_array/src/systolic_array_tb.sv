module systolic_array_OS_tb(
	input logic clk
);
	/***************************** PARAMETERS ************************************/
	localparam INPUT_WIDTH 		= 32;
	localparam WEIGHT_WIDTH 	= 32;
	localparam OUTPUT_WIDTH		= 32;
	localparam NUM_ROWS 		= 16;
	localparam NUM_COLS 		= 16;

	/**************************** LOGIC DECLARATION ******************************/
	logic 								clk_i;
	logic 								rst_n;
	logic 	[INPUT_WIDTH-1:0] 			input_i 		[NUM_ROWS];
	logic 								input_valid_i	[NUM_ROWS];
	logic   [WEIGHT_WIDTH-1:0] 			weight_i 		[NUM_COLS];
	logic 								weight_valid_i	[NUM_COLS];
	logic 	[OUTPUT_WIDTH-1:0] 			output_o 		[NUM_ROWS][NUM_COLS];
	logic 	[NUM_ROWS-1:0]				output_valid_o;

	shortreal 		                    real_input_i 	[NUM_ROWS];
	shortreal 		                    real_weight_i 	[NUM_COLS];
	shortreal 							real_output_o 	[NUM_ROWS][NUM_COLS];

	assign 								clk_i = clk;

	always_comb begin
		for(int i = 0; i < NUM_ROWS; i++) begin 
			real_input_i[i] = $bitstoshortreal(input_i[i]);
			output_valid_o[i] = 1'b1;
			for(int j = 0; j < NUM_COLS; j++) begin 
				if (i == 0) begin 
					real_weight_i[j] = $bitstoshortreal(weight_i[j]);
				end 
				real_output_o[i][j] = $bitstoshortreal(output_o[i][j]);
				output_valid_o[i] &= dut._output_valid_o[i][j];
			end
		end
	end
	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/
	systolic_array #(
		.INPUT_WIDTH		(INPUT_WIDTH),
		.OUTPUT_WIDTH		(OUTPUT_WIDTH),
		.NUM_ROWS			(NUM_ROWS),
		.NUM_COLS			(NUM_COLS)
	) dut (
		.clk_i(clk_i),
		.*
	);

	/***************************** FUNC DECLARATION ******************************/

	/***************************** TASK DECLARATION ******************************/
	task reset();
		rst_n <= 1'b0;
		// set_inputs('{{INPUT_WIDTH{1'b0}}, {INPUT_WIDTH{1'b0}}}, 1'b0);
		set_inputs('{NUM_ROWS{'{INPUT_WIDTH{1'b0}}}}, 1'b0);
		set_weights('{NUM_COLS{'{WEIGHT_WIDTH{1'b0}}}}, 1'b0);
		##1;
		rst_n <= 1'b1;
	endtask

	task set_inputs(logic [INPUT_WIDTH-1:0] set_input_i [NUM_ROWS], logic valid);
		for (int i = 0; i < NUM_ROWS; i++) begin
			input_i[i] 			<= set_input_i[i];
			input_valid_i[i] 	<= valid;
		end
	endtask

	task set_weights(logic [WEIGHT_WIDTH-1:0] set_weight_i [NUM_COLS], logic valid);
		for (int i = 0; i < NUM_COLS; i++) begin
			weight_i[i] 		<= set_weight_i[i];
			weight_valid_i[i] 	<= valid;
		end
	endtask

	task eye_matrix(output logic [WEIGHT_WIDTH-1:0] weight_matrix [NUM_ROWS][NUM_COLS]);
		for (int i = 0; i < NUM_ROWS; i++) begin
			for (int j = 0; j < NUM_COLS; j++) begin
				if (i==j) begin // (j % 2) == 0
					weight_matrix[i][j] = $shortrealtobits(2.0);
				end else begin
					weight_matrix[i][j] = $shortrealtobits(0.0);
				end
			end
		end
	endtask

	task ones(output logic [INPUT_WIDTH-1:0] ones_matrix [NUM_ROWS][NUM_COLS]);
		for (int i = 0; i < NUM_ROWS; i++) begin
			for (int j = 0; j < NUM_COLS; j++) begin
				ones_matrix[i][j] = $shortrealtobits(2.5);
			end
		end
	endtask

	task get_slant_input_matrix(input logic [INPUT_WIDTH-1:0] input_matrix [NUM_ROWS][NUM_COLS], output logic [INPUT_WIDTH-1:0] slant_matrix [NUM_ROWS][NUM_ROWS+NUM_COLS-1]);
		for (int i = 0; i < NUM_ROWS; i++) begin
			for (int j = 0; j < NUM_ROWS+NUM_COLS-1; j++) begin
				slant_matrix[i][j] = $shortrealtobits(0.0);
			end
			for (int j = 0; j < NUM_COLS; j++) begin
				slant_matrix[i][(NUM_COLS - 1 - i) + j] = input_matrix[i][j];
			end
		end
	endtask

	task get_slant_weight_matrix(input logic [WEIGHT_WIDTH-1:0] input_matrix [NUM_ROWS][NUM_COLS], output logic [WEIGHT_WIDTH-1:0] slant_matrix [NUM_ROWS+NUM_COLS-1][NUM_COLS]);
		for (int j = 0; j < NUM_COLS; j++) begin
			for (int i = 0; i < NUM_ROWS+NUM_COLS-1; i++) begin
				slant_matrix[i][j] = $shortrealtobits(0.0);
			end
			for (int i = 0; i < NUM_ROWS; i++) begin
				slant_matrix[(NUM_ROWS - 1 - j) + i][j] = input_matrix[i][j];
			end
		end
	endtask

	task send_input_weights(logic [INPUT_WIDTH-1:0] input_matrix [NUM_ROWS][NUM_ROWS+NUM_COLS-1], logic [WEIGHT_WIDTH-1:0] weight_matrix [NUM_ROWS+NUM_COLS-1][NUM_COLS]);
		logic [INPUT_WIDTH-1:0] col_data [NUM_ROWS];
		for (int j = (NUM_ROWS+NUM_COLS-1-1); j >= 0; j--) begin
			for (int i = 0; i < NUM_ROWS; i++) begin
				col_data[i] = input_matrix[i][j];
			end
			set_inputs(col_data, 1'b1);
			set_weights(weight_matrix[j], 1'b1);
			##1;
			print_output();
		end
		set_inputs(col_data, 1'b0);
		set_weights(weight_matrix[1], 1'b0);
	endtask

	task print_output();
		for (int i = 0; i < NUM_ROWS; i++) begin
			for (int j = 0; j < NUM_COLS; j++) begin
				$display("output_o[%0d][%0d] = %0d", i, j, output_o[i][j]);
			end
		end
	endtask

	task test();
		logic [WEIGHT_WIDTH-1:0] weight_matrix [NUM_ROWS][NUM_COLS];
		logic [WEIGHT_WIDTH-1:0] slant_weight_matrix [NUM_ROWS+NUM_COLS-1][NUM_COLS];
		logic [INPUT_WIDTH-1:0] input_matrix [NUM_ROWS][NUM_COLS];
		logic [INPUT_WIDTH-1:0] slant_input_matrix [NUM_ROWS][NUM_ROWS+NUM_COLS-1];

		eye_matrix(weight_matrix);
		ones(input_matrix);

		get_slant_input_matrix(input_matrix, slant_input_matrix);
		get_slant_weight_matrix(weight_matrix, slant_weight_matrix);

		send_input_weights(slant_input_matrix, slant_weight_matrix);
		##10;
	endtask

	task main();
		reset();
		##10;
		test();
		##1;
		@(&output_valid_o);
		@(~(|output_valid_o));
		##4;
		// for (int i = 0; i < 100; i++) begin 
		// 	reset();
		// 	##10;
		// 	test();
		// 	##1;
		// end
	endtask

endmodule