`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2023 09:39:52 PM
// Design Name: 
// Module Name: PE
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

module PE #(
	parameter INPUT_WIDTH 		= 32,
	parameter WEIGHT_WIDTH 		= 32,
	parameter OUTPUT_WIDTH		= 32,
	parameter MAC_ID            = 0,
	parameter USE_1_DSP_ID      = 752
)(
	input 	logic 								clk_i,
	input 	logic 								rst_n,
	input 	logic 			[INPUT_WIDTH-1:0]	input_i,
	input 	logic 								input_valid_i,
	input 	logic			[WEIGHT_WIDTH-1:0]	weight_i,
	input 	logic 								weight_valid_i,

	// input 	int 								i,
	// input 	int  								j,

	output 	logic			[INPUT_WIDTH-1:0]	input_o,
	output 	logic 								input_valid_o,
	output 	logic			[WEIGHT_WIDTH-1:0]	weight_o,
	output 	logic 								weight_valid_o,
	output 	logic 			[OUTPUT_WIDTH-1:0]	output_o,
	output 	logic 								output_valid_o
);

	/**************************** ENUM DECLARATION ******************************/
	// enum logic [1:0] {
	// 	A, B, C
	// } state, next_state;

	/**************************** LOGIC DECLARATION *****************************/
	logic _mac_operands_ready;

	/**************************** MODULE DECLARATION ****************************/
//	pipeline_mac_wrapper _mac(
        pipeline_mac_2 #(.MAC_ID(MAC_ID), .USE_1_DSP_ID(USE_1_DSP_ID))_mac(
		.aclk_0(clk_i),
		.aresetn_0(rst_n),
		.S_AXIS_A_0_tdata(input_i),
		.S_AXIS_A_0_tvalid(_mac_operands_ready),
		.S_AXIS_B_0_tdata(weight_i),
		.S_AXIS_B_0_tvalid(_mac_operands_ready),

		.mac_result(output_o),
//		.M_AXIS_RESULT_0_tlast(),
		.M_AXIS_RESULT_0_tvalid(output_valid_o)
	);

	/**************************** TASK DECLARATION ******************************/
	task reset();
		input_o			<= '0;
		weight_o		<= '0;
		input_valid_o	<= '0;
		weight_valid_o	<= '0;
	endtask : reset

	/**************************** FUNC DECLARATION ******************************/
	function void set_state_defaults();

	endfunction : set_state_defaults

	function void set_action_defaults();
		_mac_operands_ready = input_valid_i & weight_valid_i;
	endfunction

	/******************************* COMB BLOCKS ********************************/
	always_comb begin
		set_action_defaults();
	end

	/******************************* PROC BLOCKS ********************************/
	always_ff @(posedge clk_i) begin
		if(~rst_n) begin
			reset();
		end else begin
			input_o 			<= input_i;
			weight_o 			<= weight_i;
			input_valid_o 		<= input_valid_i;
			weight_valid_o 		<= weight_valid_i;
		end
	end

endmodule
