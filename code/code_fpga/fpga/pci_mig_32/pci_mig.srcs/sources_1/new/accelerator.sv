`timescale 1ns / 1ps

// docs https://developer.arm.com/documentation/ihi0022/e?_ga=2.67820049.1631882347.1556009271-151447318.1544783517

`define ACCEL_ADDR 32'hdeadbeef

module accelerator (
	input 	logic 			clk_i,
	input	logic 			reset_n,

	input 	logic [32:0] 	axi_araddr_dma_i,
	input 	logic [7:0] 	axi_arlen_dma_i,
	input 	logic [1:0] 	axi_arburst_dma_i,
	input 	logic 			axi_arvalid_dma_i,
	input 	logic 			axi_rready_dma_i, // dma ready to accept read result

	input 	logic 			axi_arready_mig_i, // mig ready to accept new address
	input 	logic [63:0] 	axi_rdata_mig_i,
	input 	logic [1:0] 	axi_rresp_mig_i,
	input 	logic 			axi_rlast_mig_i,
	input 	logic 			axi_rvalid_mig_i, // read data is available

	output 	logic [32:0] 	axi_araddr_mig_o,
	output 	logic [7:0] 	axi_arlen_mig_o,
	output 	logic [1:0] 	axi_arburst_mig_o,
	output 	logic 			axi_arvalid_mig_o,
	output 	logic 			axi_rready_mig_o, // dma ready to accept read result

	output 	logic 			axi_arready_dma_o,
	output 	logic [63:0] 	axi_rdata_dma_o,
	output 	logic [1:0] 	axi_rresp_dma_o,
	output 	logic 			axi_rlast_dma_o,
	output 	logic 			axi_rvalid_dma_o, // read data is available

	// internal logic
	output	logic 			_is_accel_addr,
	output	logic 			_state,
	output	logic [63:0] 	_counter,
	output	logic [1:0]		_axi_rresp_accel,
	output	logic 			_axi_rvalid_accel
);

	// logic 			_is_accel_addr;
	// logic 			_state;
	// logic [63:0] 	_counter;
	// logic [1:0]		_axi_rresp_accel;
	// logic 			_axi_rvalid_accel;
	logic 			_waiting;
	logic 			_axi_rlast_accel;
	logic 			_axi_arready_accel;
	logic 			_plus_one;

	enum logic {
		IDLE, ACK
	} state;

	assign _state = state;

	assign _is_accel_addr 		= (axi_arvalid_dma_i && (axi_araddr_dma_i == {1'b0, `ACCEL_ADDR})) || (state != IDLE);

	assign axi_araddr_mig_o 	= axi_araddr_dma_i;
	assign axi_arlen_mig_o 		= axi_arlen_dma_i;
	assign axi_arburst_mig_o 	= axi_arburst_dma_i;
	assign axi_arvalid_mig_o 	= ~_is_accel_addr ? axi_arvalid_dma_i : '0;
	assign axi_rready_mig_o 	= axi_rready_dma_i;
	assign axi_arready_dma_o 	= ~_is_accel_addr ? axi_arready_mig_i : _axi_arready_accel;

	assign axi_rdata_dma_o 		= ~_is_accel_addr ? axi_rdata_mig_i : _counter << ({3'd0, axi_araddr_dma_i[2:0]} << 3);
	assign axi_rresp_dma_o 		= ~_is_accel_addr ? axi_rresp_mig_i : _axi_rresp_accel;
	assign axi_rlast_dma_o 		= ~_is_accel_addr ? axi_rlast_mig_i : _axi_rlast_accel;
	assign axi_rvalid_dma_o 	= ~_is_accel_addr ? axi_rvalid_mig_i : _axi_rvalid_accel;

	assign _axi_rresp_accel		= 2'b00;

	always_ff @(posedge clk_i) begin
		if (~reset_n) begin 
			state							<= IDLE;
			_axi_rvalid_accel 				<= '0;
			_counter						<= '0;
			_waiting						<= '0;
			_axi_rlast_accel				<= '0;
			_axi_arready_accel				<= 1'b1;
			_plus_one						<= '0;
		end else begin 
			unique case(_state)
				IDLE: begin 
					_axi_rvalid_accel		<= '0;
					_waiting				<= '0;
					_axi_rlast_accel		<= '0;
					_plus_one				<= '0;
					_axi_arready_accel		<= ~_is_accel_addr;
					state					<= _is_accel_addr ? ACK : IDLE;
				end 

				ACK: begin 
					_axi_arready_accel		<= 1'b1;
					if (~axi_arvalid_dma_i & axi_rready_dma_i) begin 
						_axi_rvalid_accel	<= 1'b1;
						_axi_rlast_accel	<= 1'b1;
						_plus_one			<= 1'b1;
					end
					
					if (_plus_one) begin 
						state 				<= IDLE;
						_counter			<= _counter + 1;
						_axi_rvalid_accel	<= '0;
						_axi_rlast_accel	<= '0;
					end 
				end
			endcase
		end 
	end

endmodule