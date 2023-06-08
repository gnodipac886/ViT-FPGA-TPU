module accelerator_wrapper (
	input 	wire  			clk_i,
	input	wire  			reset_n,

	input 	wire  [32:0] 	axi_araddr_dma_i,
	input 	wire  [7:0] 	axi_arlen_dma_i,
	input 	wire  [1:0] 	axi_arburst_dma_i,
	input 	wire  			axi_arvalid_dma_i,
	input 	wire  			axi_rready_dma_i, // dma ready to accept read result

	input 	wire  			axi_arready_mig_i, // mig ready to accept new address
	input 	wire  [63:0] 	axi_rdata_mig_i,
	input 	wire  [1:0] 	axi_rresp_mig_i,
	input 	wire  			axi_rlast_mig_i,
	input 	wire  			axi_rvalid_mig_i, // read data is available

	output 	wire  [32:0] 	axi_araddr_mig_o,
	output 	wire  [7:0] 	axi_arlen_mig_o,
	output 	wire  [1:0] 	axi_arburst_mig_o,
	output 	wire  			axi_arvalid_mig_o,
	output 	wire  			axi_rready_mig_o, // dma ready to accept read result

	output 	wire  			axi_arready_dma_o,
	output 	wire  [63:0] 	axi_rdata_dma_o,
	output 	wire  [1:0] 	axi_rresp_dma_o,
	output 	wire  			axi_rlast_dma_o,
	output 	wire  			axi_rvalid_dma_o, // read data is available

	output	wire 			_is_accel_addr,
	output	wire 			_state,
	output	wire [63:0] 	_counter,
	output	wire [1:0]		_axi_rresp_accel,
	output	wire 			_axi_rvalid_accel
);

	accelerator acc_0(
		.clk_i(clk_i),
		.reset_n(reset_n),
		.axi_araddr_dma_i(axi_araddr_dma_i),
		.axi_arlen_dma_i(axi_arlen_dma_i),
		.axi_arburst_dma_i(axi_arburst_dma_i),
		.axi_arvalid_dma_i(axi_arvalid_dma_i),
		.axi_rready_dma_i(axi_rready_dma_i),
		.axi_arready_mig_i(axi_arready_mig_i),
		.axi_rdata_mig_i(axi_rdata_mig_i),
		.axi_rresp_mig_i(axi_rresp_mig_i),
		.axi_rlast_mig_i(axi_rlast_mig_i),
		.axi_rvalid_mig_i(axi_rvalid_mig_i),
		.axi_araddr_mig_o(axi_araddr_mig_o),
		.axi_arlen_mig_o(axi_arlen_mig_o),
		.axi_arburst_mig_o(axi_arburst_mig_o),
		.axi_arvalid_mig_o(axi_arvalid_mig_o),
		.axi_rready_mig_o(axi_rready_mig_o),
		.axi_arready_dma_o(axi_arready_dma_o),
		.axi_rdata_dma_o(axi_rdata_dma_o),
		.axi_rresp_dma_o(axi_rresp_dma_o),
		.axi_rlast_dma_o(axi_rlast_dma_o),
		.axi_rvalid_dma_o(axi_rvalid_dma_o),

		._is_accel_addr(_is_accel_addr),
		._state(_state),
		._counter(_counter),
		._axi_rresp_accel(_axi_rresp_accel),
		._axi_rvalid_accel(_axi_rvalid_accel)
	);

endmodule