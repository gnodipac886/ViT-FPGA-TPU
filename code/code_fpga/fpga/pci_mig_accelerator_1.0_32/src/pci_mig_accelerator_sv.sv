
`timescale 1 ns / 1 ps
import accelerator_types::*;

module pci_mig_accelerator_sv #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_ID_WIDTH	= 1,
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 6,
		parameter integer C_S00_AXI_AWUSER_WIDTH= 0,
		parameter integer C_S00_AXI_ARUSER_WIDTH= 0,
		parameter integer C_S00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_S00_AXI_BUSER_WIDTH	= 0,

		// Parameters of Axi Master Bus Interface M00_AXI
		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_BURST_LEN	= 16,
		parameter integer C_M00_AXI_ID_WIDTH	= 1,
		parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M00_AXI_DATA_WIDTH	= 32,
		parameter integer C_M00_AXI_AWUSER_WIDTH= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0,

		parameter integer SYS_ARR_IN_PRECISION	= 16, 
		parameter integer SYS_ARR_OUT_PRECISION	= SYS_ARR_IN_PRECISION,
		parameter integer SYS_ARR_SIZE			= 32,
		parameter integer SYS_MAC_LATENCY		= 16,
		parameter integer SYS_ARR_ROW_WIDTH		= SYS_ARR_IN_PRECISION * SYS_ARR_SIZE,
		
		parameter integer NUM_REG				= 13,
		parameter integer BRAM_DIN_WIDTH		= SYS_ARR_IN_PRECISION * SYS_ARR_SIZE * 2,
		parameter integer BRAM_DOUT_WIDTH		= SYS_ARR_IN_PRECISION * SYS_ARR_SIZE * 2,
		parameter integer BRAM_DEPTH			= SYS_ARR_ROW_WIDTH * SYS_ARR_SIZE * 2 / BRAM_DOUT_WIDTH,
		parameter integer BRAM_ADDR_WIDTH		= $clog2(BRAM_DEPTH)
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input logic  s00_axi_aclk,
		input logic  s00_axi_aresetn,
		input logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_awid,
		input logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input logic [7 : 0] s00_axi_awlen,
		input logic [2 : 0] s00_axi_awsize,
		input logic [1 : 0] s00_axi_awburst,
		input logic  s00_axi_awlock,
		input logic [3 : 0] s00_axi_awcache,
		input logic [2 : 0] s00_axi_awprot,
		input logic [3 : 0] s00_axi_awqos,
		input logic [3 : 0] s00_axi_awregion,
		input logic [C_S00_AXI_AWUSER_WIDTH-1 : 0] s00_axi_awuser,
		input logic  s00_axi_awvalid,
		output logic  s00_axi_awready,
		input logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input logic  s00_axi_wlast,
		input logic [C_S00_AXI_WUSER_WIDTH-1 : 0] s00_axi_wuser,
		input logic  s00_axi_wvalid,
		output logic  s00_axi_wready,
		output logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_bid,
		output logic [1 : 0] s00_axi_bresp,
		output logic [C_S00_AXI_BUSER_WIDTH-1 : 0] s00_axi_buser,
		output logic  s00_axi_bvalid,
		input logic  s00_axi_bready,
		input logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_arid,
		input logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input logic [7 : 0] s00_axi_arlen,
		input logic [2 : 0] s00_axi_arsize,
		input logic [1 : 0] s00_axi_arburst,
		input logic  s00_axi_arlock,
		input logic [3 : 0] s00_axi_arcache,
		input logic [2 : 0] s00_axi_arprot,
		input logic [3 : 0] s00_axi_arqos,
		input logic [3 : 0] s00_axi_arregion,
		input logic [C_S00_AXI_ARUSER_WIDTH-1 : 0] s00_axi_aruser,
		input logic  s00_axi_arvalid,
		output logic  s00_axi_arready,
		output logic [C_S00_AXI_ID_WIDTH-1 : 0] s00_axi_rid,
		output logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output logic [1 : 0] s00_axi_rresp,
		output logic  s00_axi_rlast,
		output logic [C_S00_AXI_RUSER_WIDTH-1 : 0] s00_axi_ruser,
		output logic  s00_axi_rvalid,
		input logic  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXI
		input logic  m00_axi_init_axi_txn,
		output logic  m00_axi_txn_done,
		output logic  m00_axi_error,
		input logic  m00_axi_aclk,
		input logic  m00_axi_aresetn,
		output logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
		output logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output logic [7 : 0] m00_axi_awlen,
		output logic [2 : 0] m00_axi_awsize,
		output logic [1 : 0] m00_axi_awburst,
		output logic  m00_axi_awlock,
		output logic [3 : 0] m00_axi_awcache,
		output logic [2 : 0] m00_axi_awprot,
		output logic [3 : 0] m00_axi_awqos,
		output logic [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
		output logic  m00_axi_awvalid,
		input logic  m00_axi_awready,
		output logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output logic [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output logic  m00_axi_wlast,
		output logic [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
		output logic  m00_axi_wvalid,
		input logic  m00_axi_wready,
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input logic [1 : 0] m00_axi_bresp,
		input logic [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input logic  m00_axi_bvalid,
		output logic  m00_axi_bready,
		output logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
		output logic [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output logic [7 : 0] m00_axi_arlen,
		output logic [2 : 0] m00_axi_arsize,
		output logic [1 : 0] m00_axi_arburst,
		output logic  m00_axi_arlock,
		output logic [3 : 0] m00_axi_arcache,
		output logic [2 : 0] m00_axi_arprot,
		output logic [3 : 0] m00_axi_arqos,
		output logic [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
		output logic  m00_axi_arvalid,
		input logic  m00_axi_arready,
		input logic [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
		input logic [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input logic [1 : 0] m00_axi_rresp,
		input logic  m00_axi_rlast,
		input logic [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
		input logic  m00_axi_rvalid,
		output logic  m00_axi_rready,

		output logic [C_S00_AXI_ADDR_WIDTH-1:0] 	r_addr_i,
		output logic 							r_valid_i,
		output logic [C_S00_AXI_ADDR_WIDTH-1:0] 	w_addr_i,
		output logic [C_S00_AXI_DATA_WIDTH-1:0]	w_data_i,
		output logic 							w_valid_i,
		output logic [C_S00_AXI_DATA_WIDTH-1:0]	r_data_o
		// output logic [C_S00_AXI_DATA_WIDTH-1:0] 	mig_addr_addr,
		// output logic 							mig_addr_arvalid,
		// output logic [7:0]						mig_addr_arwlen,
		// output logic [C_M00_AXI_DATA_WIDTH-1:0] 	mig_data_data,
		// output logic 							mig_data_data_valid,
		// output logic 							mig_data_arwready
	);

	// declarations
	accel_mig_itf #(
		.ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.DATA_WIDTH(C_M00_AXI_DATA_WIDTH)
	) mig_port();

	bram_itf #(
		.ADDR_WIDTH(BRAM_ADDR_WIDTH),
		.DIN_WIDTH(BRAM_DIN_WIDTH),
		.DOUT_WIDTH(BRAM_DOUT_WIDTH)
	) bram_a_port();

	bram_itf #(
		.ADDR_WIDTH(BRAM_ADDR_WIDTH),
		.DIN_WIDTH(BRAM_DIN_WIDTH),
		.DOUT_WIDTH(BRAM_DOUT_WIDTH)
	) bram_b_port();

// Instantiation of Axi Bus Interface S00_AXI
	pci_mig_accelerator_v1_0_S00_AXI # ( 
		.C_S_AXI_ID_WIDTH(C_S00_AXI_ID_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.C_S_AXI_AWUSER_WIDTH(C_S00_AXI_AWUSER_WIDTH),
		.C_S_AXI_ARUSER_WIDTH(C_S00_AXI_ARUSER_WIDTH),
		.C_S_AXI_WUSER_WIDTH(C_S00_AXI_WUSER_WIDTH),
		.C_S_AXI_RUSER_WIDTH(C_S00_AXI_RUSER_WIDTH),
		.C_S_AXI_BUSER_WIDTH(C_S00_AXI_BUSER_WIDTH)
	) pci_mig_accelerator_v1_0_S00_AXI_inst (
		.r_addr_i(r_addr_i),
		.r_valid_i(r_valid_i),
		.w_addr_i(w_addr_i),
		.w_data_i(w_data_i),
		.w_valid_i(w_valid_i),
		.r_data_o(r_data_o),

		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(combined_reset_n),
		.S_AXI_AWID(s00_axi_awid),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWLEN(s00_axi_awlen),
		.S_AXI_AWSIZE(s00_axi_awsize),
		.S_AXI_AWBURST(s00_axi_awburst),
		.S_AXI_AWLOCK(s00_axi_awlock),
		.S_AXI_AWCACHE(s00_axi_awcache),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWQOS(s00_axi_awqos),
		.S_AXI_AWREGION(s00_axi_awregion),
		.S_AXI_AWUSER(s00_axi_awuser),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WLAST(s00_axi_wlast),
		.S_AXI_WUSER(s00_axi_wuser),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BID(s00_axi_bid),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BUSER(s00_axi_buser),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARID(s00_axi_arid),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARLEN(s00_axi_arlen),
		.S_AXI_ARSIZE(s00_axi_arsize),
		.S_AXI_ARBURST(s00_axi_arburst),
		.S_AXI_ARLOCK(s00_axi_arlock),
		.S_AXI_ARCACHE(s00_axi_arcache),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARQOS(s00_axi_arqos),
		.S_AXI_ARREGION(s00_axi_arregion),
		.S_AXI_ARUSER(s00_axi_aruser),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RID(s00_axi_rid),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RLAST(s00_axi_rlast),
		.S_AXI_RUSER(s00_axi_ruser),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

// Instantiation of Axi Bus Interface M00_AXI
	pci_mig_accelerator_v1_0_M00_AXI # ( 
		.C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_BURST_LEN(C_M00_AXI_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_M00_AXI_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_M00_AXI_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_M00_AXI_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_M00_AXI_BUSER_WIDTH)
	) pci_mig_accelerator_v1_0_M00_AXI_inst (
		// .accel_port(mig_port.mig),

		.INIT_AXI_TXN(m00_axi_init_axi_txn),
		.TXN_DONE(m00_axi_txn_done),
		.ERROR(m00_axi_error),
		.M_AXI_ACLK(m00_axi_aclk),
		.M_AXI_ARESETN(combined_reset_n),
		.M_AXI_AWID(m00_axi_awid),
		// .M_AXI_AWADDR(m00_axi_awaddr),
		// .M_AXI_AWLEN(m00_axi_awlen),
		.M_AXI_AWSIZE(m00_axi_awsize),
		.M_AXI_AWBURST(m00_axi_awburst),
		.M_AXI_AWLOCK(m00_axi_awlock),
		.M_AXI_AWCACHE(m00_axi_awcache),
		.M_AXI_AWPROT(m00_axi_awprot),
		.M_AXI_AWQOS(m00_axi_awqos),
		.M_AXI_AWUSER(m00_axi_awuser),
		// .M_AXI_AWVALID(m00_axi_awvalid),
		.M_AXI_AWREADY(m00_axi_awready),
		// .M_AXI_WDATA(m00_axi_wdata),
		// .M_AXI_WSTRB(m00_axi_wstrb),
		// .M_AXI_WLAST(m00_axi_wlast),
		.M_AXI_WUSER(m00_axi_wuser),
		// .M_AXI_WVALID(m00_axi_wvalid),
		// .M_AXI_WREADY(m00_axi_wready),
		.M_AXI_BID(m00_axi_bid),
		.M_AXI_BRESP(m00_axi_bresp),
		.M_AXI_BUSER(m00_axi_buser),
		// .M_AXI_BVALID(m00_axi_bvalid),
		// .M_AXI_BREADY(m00_axi_bready),
		.M_AXI_ARID(m00_axi_arid),
		// .M_AXI_ARADDR(m00_axi_araddr),
		// .M_AXI_ARLEN(m00_axi_arlen),
		.M_AXI_ARSIZE(m00_axi_arsize),
		.M_AXI_ARBURST(m00_axi_arburst),
		.M_AXI_ARLOCK(m00_axi_arlock),
		.M_AXI_ARCACHE(m00_axi_arcache),
		.M_AXI_ARPROT(m00_axi_arprot),
		.M_AXI_ARQOS(m00_axi_arqos),
		.M_AXI_ARUSER(m00_axi_aruser),
		// .M_AXI_ARVALID(m00_axi_arvalid),
		.M_AXI_ARREADY(m00_axi_arready),
		.M_AXI_RID(m00_axi_rid),
		.M_AXI_RDATA(m00_axi_rdata),
		.M_AXI_RRESP(m00_axi_rresp),
		.M_AXI_RLAST(m00_axi_rlast),
		.M_AXI_RUSER(m00_axi_ruser),
		.M_AXI_RVALID(m00_axi_rvalid),
		.M_AXI_RREADY(m00_axi_rready)
	);

	accelerator_ctl #(
		.ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.MIG_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
		.NUM_REG(NUM_REG),
		.BRAM_ADDR_WIDTH(BRAM_ADDR_WIDTH),
		.BRAM_DIN_WIDTH(BRAM_DIN_WIDTH),
		.BRAM_DOUT_WIDTH(BRAM_DOUT_WIDTH),
		.SYS_ARR_IN_PRECISION(SYS_ARR_IN_PRECISION),
		.SYS_ARR_OUT_PRECISION(SYS_ARR_OUT_PRECISION),
		.SYS_ARR_SIZE(SYS_ARR_SIZE),
		.SYS_MAC_LATENCY(SYS_MAC_LATENCY)
	) acc_ctl_0  (
		.clk_i(s00_axi_aclk),
		.reset_n(combined_reset_n),
		.r_addr_i(r_addr_i),
		.r_valid_i(s00_axi_rvalid),
		.w_addr_i(w_addr_i),
		.w_data_i(w_data_i),
		.w_strb_i(s00_axi_wstrb),
		.w_valid_i(w_valid_i),
		.sys_output_i(upk_sys_output_o),
		.sys_output_valid_i(&upk_sys_output_valid_o),

		.r_data_o(r_data_o),
		.sys_valid_o(sys_valid_o),
		.sys_data_sel_o(sys_data_sel_o),
		.sys_reset_o(sys_reset_o),
		.accel_reset_o(accel_reset_o),

		// itfs
		.mig_port(mig_port.accel),
		.bram_a_port(bram_a_port.ctlr),
		.bram_b_port(bram_b_port.ctlr)
	);

	blk_mem_gen_0 bram_a (
		.clka(s00_axi_aclk),
		.addra(bram_a_port.addr),
		.dina(bram_a_port.bram_din),
		.douta(bram_a_port.bram_dout),
		.wea(bram_a_port.we)
	);

	blk_mem_gen_0 bram_b (
		.clka(s00_axi_aclk),
		.addra(bram_b_port.addr),
		.dina(bram_b_port.bram_din),
		.douta(bram_b_port.bram_dout),
		.wea(bram_b_port.we)
	);

	logic 																combined_reset_n;
	logic 	[SYS_ARR_OUT_PRECISION-1:0] 								sys_output_o		[SYS_ARR_SIZE][SYS_ARR_SIZE];
	logic																sys_output_valid_o 	[SYS_ARR_SIZE][SYS_ARR_SIZE];
	logic 	[SYS_ARR_ROW_WIDTH * SYS_ARR_SIZE-1:0]						upk_sys_output_o;
	logic 	[SYS_ARR_SIZE * SYS_ARR_SIZE-1:0]							upk_sys_output_valid_o;
	logic 																sys_valid_o;
	logic 																accel_reset_o;
	logic 																_sys_valid			[SYS_ARR_SIZE];
	logic 																sys_reset_o;
	logic 																sys_data_sel_o;
	logic 	[SYS_ARR_IN_PRECISION-1:0]									sys_input_i 		[SYS_ARR_SIZE];
	logic 	[SYS_ARR_IN_PRECISION-1:0] 									sys_weight_i 		[SYS_ARR_SIZE];
	logic 	[SYS_ARR_IN_PRECISION-1:0]									pk_bram_a_dout		[SYS_ARR_SIZE << 1];
	logic 	[SYS_ARR_IN_PRECISION-1:0]									pk_bram_b_dout		[SYS_ARR_SIZE << 1];

	systolic_array #(
		.INPUT_WIDTH(SYS_ARR_IN_PRECISION),
		.WEIGHT_WIDTH(SYS_ARR_IN_PRECISION),
		.OUTPUT_WIDTH(SYS_ARR_OUT_PRECISION),
		.NUM_ROWS(SYS_ARR_SIZE),
		.NUM_COLS(SYS_ARR_SIZE)
	) sys_array_0(
		.clk_i(s00_axi_aclk),
		.rst_n(combined_reset_n & sys_reset_o),
		.input_i(sys_input_i),
		.input_valid_i(_sys_valid),
		.weight_i(sys_weight_i),
		.weight_valid_i(_sys_valid),

		.output_o(sys_output_o),
		.output_valid_o(sys_output_valid_o)
	);

//	accel_ila_0 accel_ila(
//		.clk(s00_axi_aclk),
//		.probe0(mig_port.wdata),
//		.probe1(bram_a_port.bram_din),
//		.probe2(bram_a_port.bram_dout),
//		// .probe3(),
//		.probe4(sys_input_i[1]),
//		.probe5(sys_weight_i[1]),
//		// .probe3(upk_sys_output_valid_o),
//		// .probe4(acc_ctl_0._mmio_reg[MATRIX_A_ADDR]),
//		// .probe5(acc_ctl_0._mmio_reg[MATRIX_B_ADDR]),
//		.probe6(acc_ctl_0._bram_a_addr),
//		.probe7(acc_ctl_0._bram_b_addr),
//		.probe8(sys_output_o[0][1]),
//		.probe9(acc_ctl_0._sys_read_counter),
//		// .probe8(acc_ctl_0._mmio_reg[ACCEL_INSTR]),
//		// .probe9(acc_ctl_0._mmio_reg[ACCEL_STATE]),

//		// .probe10(acc_ctl_0._mmio_reg[SYS_ARR_OUTPUT]),

//		.probe11(bram_a_port.bram_dout),
//		.probe12(bram_b_port.bram_dout),
//		.probe13(mig_port.addr),
//		.probe14(mig_port.data),
//		// .probe12(acc_ctl_0._sys_arr_counter),
//		.probe15(acc_ctl_0._sys_compute_counter),

//		.probe24(mig_port.wvalid),
//		.probe25(mig_port.arvalid),
//		.probe26(acc_ctl_0.sys_output_valid_i),
//		.probe27(sys_output_valid_o[0][1]),
//		.probe28(acc_ctl_0.r_valid_i),
//		.probe29(acc_ctl_0.sys_valid_o),
//		.probe30(acc_ctl_0.bram_a_port.we),
//		.probe31(acc_ctl_0.bram_b_port.we)
//	);

	// Add user logic here

	assign combined_reset_n			= s00_axi_aresetn & accel_reset_o;
	assign _sys_valid				= sys_valid_o ? { default: '1 } :  { default: '0 } ;
	assign upk_sys_output_o			= { >> { sys_output_o }};
	assign upk_sys_output_valid_o	= { >> { sys_output_valid_o }};

	// always_comb begin
	// 	for (int i = 0; i < SYS_ARR_SIZE; i++) begin
	// 		for (int j = 0; j < SYS_ARR_SIZE; j++) begin
	// 			upk_sys_output_valid_o[i * SYS_ARR_SIZE + j] = sys_output_valid_o[i][j];
	// 			upk_sys_output_o[i * SYS_ARR_SIZE * SYS_ARR_OUT_PRECISION + (j+1) * SYS_ARR_OUT_PRECISION - 1 -: SYS_ARR_OUT_PRECISION] = sys_output_o[i][j];
	// 		end
	// 	end
	// end
	
	always_comb begin : unpack_dout
		for (int i = 1; i < (SYS_ARR_SIZE << 1) + 1; i++) begin
			pk_bram_a_dout[i-1]	= bram_a_port.bram_dout[i * SYS_ARR_IN_PRECISION - 1 -: SYS_ARR_IN_PRECISION];
			pk_bram_b_dout[i-1]	= bram_b_port.bram_dout[i * SYS_ARR_IN_PRECISION - 1 -: SYS_ARR_IN_PRECISION];
		end
	end
	
	always_comb begin
		for (int i = 0; i < SYS_ARR_SIZE; i++) begin 
			sys_input_i[i]		= sys_data_sel_o ? pk_bram_a_dout[SYS_ARR_SIZE + i] : pk_bram_a_dout[i];
			sys_weight_i[i]		= sys_data_sel_o ? pk_bram_b_dout[SYS_ARR_SIZE + i] : pk_bram_b_dout[i];
		end 
	end

	always_ff @( s00_axi_aclk ) begin
		mig_port.arready 		<= m00_axi_arready;
		mig_port.awready		<= m00_axi_awready;
		mig_port.rw_last		<= m00_axi_rlast;
		mig_port.data_valid		<= m00_axi_rvalid & m00_axi_rready & |(~m00_axi_rresp);
		mig_port.data			<= m00_axi_rdata;

		mig_port.wready			<= m00_axi_wready;
		mig_port.bvalid			<= m00_axi_bvalid;
	end

	always_ff @( m00_axi_aclk ) begin
		m00_axi_araddr			<= mig_port.addr;
		m00_axi_awaddr			<= mig_port.addr;
		m00_axi_arvalid			<= mig_port.arvalid;
		m00_axi_arlen			<= mig_port.arwlen;
		m00_axi_awlen			<= mig_port.arwlen;
		m00_axi_awvalid			<= mig_port.awvalid;

		// w channel
		m00_axi_wdata			<= mig_port.wdata;
		m00_axi_wstrb			<= mig_port.wstrb;
		m00_axi_wlast			<= mig_port.wlast;
		m00_axi_wvalid			<= mig_port.wvalid;
		m00_axi_bready			<= mig_port.bready;
	end
	// User logic ends

endmodule
