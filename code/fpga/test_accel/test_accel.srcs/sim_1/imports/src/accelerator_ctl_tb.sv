import accelerator_types::*;
`define BYTE 8

module accelerator_ctl_tb(
	input logic clk
);
	/**************************** LOGIC DECLARATION ******************************/
	localparam ADDR_WIDTH 		= 32;
	localparam REG_WIDTH 		= 32;
	localparam DATA_WIDTH 		= 1024;
	localparam NUM_REG			= 13;
	localparam DATA_PRECISION 	= 16;
	localparam W_STRB_SIZE 		= DATA_WIDTH >> $clog2(8);
	localparam SYS_ARR_SIZE 	= 32;
	localparam SYS_ARR_OUT_WIDTH= SYS_ARR_SIZE * SYS_ARR_SIZE * DATA_PRECISION;

	typedef enum logic [$clog2(NUM_REG)-1:0] { 
		MATRIX_A_ADDR 			= 'd0,
		MATRIX_B_ADDR 			= 'd1,
		MATRIX_C_ADDR 			= 'd2,
		MATRIX_A_SIZE 			= 'd3,		// sizes in terms of bytes
		MATRIX_B_SIZE 			= 'd4,
		MATRIX_RD_CNT 			= 'd5,		// TODO: we might want to have fp32 for answer
		MATRIX_M_SIZE 			= 'd6,
		MATRIX_N_SIZE 			= 'd7,
		MATRIX_K_SIZE 			= 'd8,
		ACCEL_INSTR				= 'd9,
		ACCEL_STATE 			= 'd10,
		ACCEL_DATA				= 'd11,
		SYS_ARR_OUTPUT			= 'd12
	} accel_mmio_reg_e;

	logic 						reset_n;
	logic [ADDR_WIDTH-1:0] 		r_addr_i;
	logic 						r_valid_i;
	logic [ADDR_WIDTH-1:0] 		w_addr_i;
	logic [DATA_WIDTH-1:0]		w_data_i;
	logic 						w_valid_i;
	logic [DATA_WIDTH-1:0]		r_data_o;
	logic [W_STRB_SIZE-1:0]		w_strb_i;
	logic [SYS_ARR_OUT_WIDTH-1:0]	sys_output_i;

	logic [REG_WIDTH-1:0]		mat_a_addr_o;
	logic [REG_WIDTH-1:0]		mat_b_addr_o;
	logic [REG_WIDTH-1:0]		mat_a_len_o;
	logic [REG_WIDTH-1:0]		mat_b_len_o;
	logic 						bram_rd_sel_o;
	accel_state_e				accel_state_o;
	logic 						spad_mat_ab_rd_done_i;

	assign out_mig_port.data 	= {'0, clk};

	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/

	// pci_mig_accelerator_v1_0 dut(
	// 	.s00_axi_aclk(clk),
	// 	.s00_axi_aresetn(reset_n),

	// 	.r_addr_i(r_addr_i),
	// 	.r_valid_i(r_valid_i),
	// 	.w_addr_i(w_addr_i),
	// 	.w_data_i(w_data_i),
	// 	.w_valid_i(w_valid_i)
	// );

	// declarations
	accel_mig_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) ctl_mig_port();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) ctl_bram_a_port();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) ctl_bram_b_port();

	// to "mig"
	accel_mig_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) out_mig_port();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) bram_a_port_0();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) bram_b_port_0();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) bram_a_port_1();

	bram_itf #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DIN_WIDTH(DATA_WIDTH),
		.DOUT_WIDTH(DATA_WIDTH)
	) bram_b_port_1();

	spad_arbiter #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.REG_WIDTH(REG_WIDTH)
	) arb (
		.clk_i(clk),
		.rst_n(reset_n),
		.ctl_mig_port(ctl_mig_port.mig),
		.ctl_bram_a_port(ctl_bram_a_port.bram),
		.ctl_bram_b_port(ctl_bram_b_port.bram),
		.mat_a_addr_i(mat_a_addr_o),
		.mat_b_addr_i(mat_b_addr_o),
		.mat_a_len(mat_a_len_o),
		.mat_b_len(mat_b_len_o),
		.bram_rd_sel_i(bram_rd_sel_o),
		.accel_state(accel_state_o),
		.spad_mat_ab_rd_done_o(spad_mat_ab_rd_done_i),

		.out_mig_port(out_mig_port.accel),
		.out_bram_a_port_0(bram_a_port_0.ctlr),
		.out_bram_b_port_0(bram_b_port_0.ctlr),
		.out_bram_a_port_1(bram_a_port_1.ctlr),
		.out_bram_b_port_1(bram_b_port_1.ctlr)
	);

	accelerator_ctl #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) dut (
		.clk_i(clk),
		.reset_n(reset_n),
		.r_addr_i(r_addr_i),
		.r_valid_i(r_valid_i),
		.w_addr_i(w_addr_i),
		.w_data_i(w_data_i),
		.w_valid_i(w_valid_i),
		.r_data_o(r_data_o),
		.w_strb_i(w_strb_i),
		.sys_output_i(sys_output_i),
		.spad_mat_ab_rd_done_i(spad_mat_ab_rd_done_i),

		.mat_a_addr_o(mat_a_addr_o),
		.mat_b_addr_o(mat_b_addr_o),
		.mat_a_len_o(mat_a_len_o),
		.mat_b_len_o(mat_b_len_o),
		.bram_rd_sel_o(bram_rd_sel_o),
		.accel_state_o(accel_state_o),

		// itfs
		.mig_port(ctl_mig_port.accel),
		.bram_a_port(ctl_bram_a_port.ctlr),
		.bram_b_port(ctl_bram_b_port.ctlr)
	);

	task reset();
		reset_n 				<= '0;
		r_addr_i				<= '0;
		r_valid_i				<= '0;
		w_addr_i				<= '0;
		w_data_i				<= '0;
		w_valid_i				<= '0;
		w_strb_i				<= '0;
		out_mig_port.awready	<= '1;
		out_mig_port.arready 	<= '0;
		out_mig_port.bvalid		<= '0;
		out_mig_port.wready		<= '1;
		out_mig_port.data_valid <= '0;
		out_mig_port.rw_last	<= '0;
		for (int i = 0; i < SYS_ARR_OUT_WIDTH / 4; i++) begin 
			// $display("%d, %d, %d", SYS_ARR_OUT_WIDTH, i, i / 16);
			sys_output_i[(i+1)*4 - 1-:4] <= i / 64;
		end

		##1;

		reset_n <= 1;
	endtask

	task write_reg(accel_mmio_reg_e accel_reg, logic [REG_WIDTH-1:0] data);
		w_addr_i	<= accel_reg;
		##1;
		w_data_i	<= data;
		w_valid_i	<= '1;
		w_strb_i	<= '1;

		##1;
		w_valid_i	<= '0;
		w_strb_i	<= '0;
		##1;
	endtask

	task wait_read_mat_ab();
		$display("%b arvalid", out_mig_port.arvalid);
	 	@(out_mig_port.arvalid == 1'b1);
		##1;
		out_mig_port.arready 	<= '1;
		##1;
		out_mig_port.arready 	<= '0;

		##10;
		out_mig_port.data_valid <= '1;
		out_mig_port.rw_last	<= '1;
		##1;
		out_mig_port.data_valid <= '0;
		out_mig_port.rw_last	<= '0;
		##1;
	endtask

	always @(posedge out_mig_port.arvalid) begin 
		##1;
		out_mig_port.arready 	<= '1;
		##1;
		out_mig_port.arready 	<= '0;
		out_mig_port.data_valid <= '1;

		##16;
		out_mig_port.data_valid <= '0;
		##2;
		out_mig_port.data_valid <= '1;
		##14;

		out_mig_port.rw_last	<= '1;
		##1;
		out_mig_port.data_valid <= '0;
		out_mig_port.rw_last	<= '0;
	end 

	task wait_write_mat_c();
		@(dut._mmio_reg[ACCEL_STATE] == S_SEND_MAT_C);
		@(out_mig_port.wvalid);

		##2;
		out_mig_port.wready <= '0;
		##1;
		out_mig_port.wready <= '1;

		// handle the sys write to C
		@(out_mig_port.wlast);
		##1;
		out_mig_port.wready <= '0;
		##10;

		out_mig_port.bvalid	<= '1;
		##1;
		out_mig_port.bvalid	<= '0;
	endtask

	task test_auto(int num_times);
		int m_size = num_times;
		write_reg(MATRIX_RD_CNT, num_times);
		write_reg(MATRIX_M_SIZE, m_size);
		write_reg(ACCEL_INSTR, I_R_MAT_A);
		// wait_read_mat_ab();
		// wait_read_mat_ab();

		for (int i = 0; i < num_times/m_size; i++) begin 
			wait_write_mat_c();
		end 

		##100;
	endtask

	task test();
		// w_addr_i	<= MATRIX_A_SIZE;
		// ##1;
		// w_data_i	<= 'd992;
		// w_valid_i	<= '1;
		// w_strb_i	<= 'hf;
		// ##1;

		// w_valid_i	<= '0;
		// w_strb_i	<= '0;

		w_addr_i	<= ACCEL_INSTR;
		##1;
		w_data_i	<= I_GEMM;
		w_valid_i	<= '1;
		w_strb_i	<= 'hf;

		for (int i = 0; i < SYS_ARR_OUT_WIDTH / 4; i++) begin 
			// $display("%d, %d, %d", SYS_ARR_OUT_WIDTH, i, i / 16);
			sys_output_i[(i+1)*4 - 1-:4] <= i / 64;
		end

		##1;
		$display("%h", sys_output_i);
		w_valid_i	<= '0;
		w_strb_i	<= '0;

		@(out_mig_port.wvalid);
		// ##1;
		// ##10;
		##2;
		out_mig_port.wready	<= '0;
		##1;
		out_mig_port.wready	<= '1;

		@(out_mig_port.wlast);
		##10;

		out_mig_port.bvalid	<= '1;
		##1;
		out_mig_port.bvalid	<= '0;

		##100;
		
	endtask

	task main();
		reset();

		##1;
		// test();
		test_auto(2);
		##1;

		// $display("➡️➡️➡️➡️➡️ template: %d");
		// reset();

		##1;
	endtask

endmodule