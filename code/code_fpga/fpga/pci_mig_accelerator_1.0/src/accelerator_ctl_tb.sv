import accelerator_types::*;

module accelerator_ctl_tb(
	input logic clk
);
	/**************************** LOGIC DECLARATION ******************************/
	localparam ADDR_WIDTH 		= 6;
	localparam DATA_WIDTH 		= 32;
	localparam NUM_REG			= 13;
	localparam DATA_PRECISION 	= 16;
	localparam W_STRB_SIZE 		= DATA_WIDTH >> $clog2(`BYTE);
	localparam SYS_ARR_SIZE 	= 2;

	typedef enum logic [$clog2(NUM_REG):0] { 
		MATRIX_A_ADDR 			= 4'd0,
		MATRIX_B_ADDR 			= 4'd1,
		MATRIX_C_ADDR 			= 4'd2,
		MATRIX_A_SIZE 			= 4'd3,		// sizes in terms of bytes
		MATRIX_B_SIZE 			= 4'd4,
		MATRIX_C_SIZE 			= 4'd5,		// TODO: we might want to have fp32 for answer
		MATRIX_M_SIZE 			= 4'd6,
		MATRIX_N_SIZE 			= 4'd7,
		MATRIX_K_SIZE 			= 4'd8,
		ACCEL_INSTR				= 4'd9,
		ACCEL_STATE 			= 4'd10
	} accel_mmio_reg_e;

	logic 					reset_n;
	logic [ADDR_WIDTH-1:0] 	r_addr_i;
	logic 					r_valid_i;
	logic [ADDR_WIDTH-1:0] 	w_addr_i;
	logic [DATA_WIDTH-1:0]	w_data_i;
	logic 					w_valid_i;
	accel_sitf_t			mig_data_i;
	logic [DATA_WIDTH-1:0]	r_data_o;
	accel_mitf_t			mig_addr_o;
	logic [W_STRB_SIZE-1:0]	w_strb_i;

	/************************** CLOCKING DECLARATION *****************************/
	default clocking tb_clk @(posedge clk); endclocking

	/**************************** DUT DECLARATION ********************************/

	accelerator_ctl #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.MIG_DATA_WIDTH(DATA_WIDTH),
		.NUM_REG(NUM_REG)
	) acc_ctl_0  (
		.clk_i(clk),
		.reset_n(reset_n),
		.r_addr_i(r_addr_i),
		.r_valid_i(r_valid_i),
		.w_addr_i(w_addr_i),
		.w_data_i(w_data_i),
		.w_strb_i(4'hf),
		.w_valid_i(w_valid_i),
		.sys_output_i(upk_sys_output_o),
		.sys_output_valid_i(&upk_sys_output_valid_o),

		// .r_data_o(r_data_o),
		.sys_valid_o(sys_valid_o),
		.sys_data_sel_o(sys_data_sel_o)
	);

	logic 	[DATA_PRECISION-1:0] 								sys_output_o		[SYS_ARR_SIZE][SYS_ARR_SIZE];
	logic																sys_output_valid_o 	[SYS_ARR_SIZE][SYS_ARR_SIZE];
	logic 	[SYS_ARR_SIZE*SYS_ARR_SIZE * SYS_ARR_SIZE-1:0]						upk_sys_output_o;
	logic 	[SYS_ARR_SIZE * SYS_ARR_SIZE-1:0]							upk_sys_output_valid_o;
	logic 																sys_valid_o;
	logic 																_sys_valid			[SYS_ARR_SIZE];
	logic 																sys_data_sel_o;
	logic 	[DATA_PRECISION-1:0]									sys_input_i 		[SYS_ARR_SIZE];
	logic 	[DATA_PRECISION-1:0] 									sys_weight_i 		[SYS_ARR_SIZE];
	logic 	[DATA_PRECISION-1:0]									pk_bram_a_dout		[SYS_ARR_SIZE << 1];
	logic 	[DATA_PRECISION-1:0]									pk_bram_b_dout		[SYS_ARR_SIZE << 1];

	systolic_array #(
		.INPUT_WIDTH(DATA_PRECISION),
		.WEIGHT_WIDTH(DATA_PRECISION),
		.OUTPUT_WIDTH(DATA_PRECISION),
		.NUM_ROWS(SYS_ARR_SIZE),
		.NUM_COLS(SYS_ARR_SIZE)
	) sys_array_0(
		.clk_i(clk),
		.rst_n(reset_n),
		.input_i(sys_input_i),
		.input_valid_i(_sys_valid),
		.weight_i(sys_weight_i),
		.weight_valid_i(_sys_valid),

		.output_o(sys_output_o),
		.output_valid_o(sys_output_valid_o)
	);

	// Add user logic here

	assign _sys_valid				= sys_valid_o ? { default: '1 } :  { default: '0 } ;
	assign upk_sys_output_o			= { >> { sys_output_o }};
	assign upk_sys_output_valid_o	= { >> { sys_output_valid_o }};
	
	always_comb begin : unpack_dout
		for (int i = 1; i < (SYS_ARR_SIZE << 1) + 1; i++) begin
			pk_bram_a_dout[i]	= '1;
			pk_bram_b_dout[i]	= '1;
		end
	end
	
	always_comb begin
		for (int i = 0; i < SYS_ARR_SIZE; i++) begin 
			sys_input_i[i]		= sys_data_sel_o ? pk_bram_a_dout[SYS_ARR_SIZE + i] : pk_bram_a_dout[i];
			sys_weight_i[i]		= sys_data_sel_o ? pk_bram_b_dout[SYS_ARR_SIZE + i] : pk_bram_b_dout[i];
		end 
	end

	/***************************** FUNC DECLARATION ******************************/
	function example_func;

	endfunction

	/***************************** TASK DECLARATION ******************************/
	task reset();
		reset_n 	<= '0;
		r_addr_i	<= '0;
		r_valid_i	<= '0;
		w_addr_i	<= '0;
		w_data_i	<= '0;
		w_valid_i	<= '0;
		mig_data_i.data	<= '0;
		mig_data_i.data_valid	<= '0;
		mig_data_i.rw_last	<= '0;
		mig_data_i.arwready	<= '0;

		##1;

		reset_n		<= 1'b1;

		##1;
	endtask

	task test();
		w_addr_i	<= MATRIX_A_ADDR;
		w_data_i	<= 33'hdeadbeef;
		w_valid_i	<= 1'b1;

		##1;

		w_addr_i	<= MATRIX_A_SIZE;
		w_data_i	<= 33'd128;
		w_valid_i	<= 1'b1;

		##1;

		w_addr_i	<= ACCEL_INSTR;
		w_data_i	<= I_R_MAT_A;
		w_valid_i	<= 1'b1;

		##1;
		w_valid_i	<= 1'b0;

		@(mig_addr_o.arvalid);
		##1;
		mig_data_i.arwready	<= 1'b1;
		##1;
		mig_data_i.arwready	<= 1'b0;

		##10;
		mig_data_i.data_valid	<= 1'b1;
		mig_data_i.rw_last		<= 1'b1;
		mig_data_i.data 		<= 32'hb0ba600d;
		##1;
		mig_data_i.data_valid	<= 1'b0;
		mig_data_i.rw_last		<= 1'b0;
		##1;
	endtask

	task main();
		reset();

		##1;

		test();
		##1;

		// $display("➡️➡️➡️➡️➡️ template: %d");
		// reset();

		##1;
	endtask

endmodule