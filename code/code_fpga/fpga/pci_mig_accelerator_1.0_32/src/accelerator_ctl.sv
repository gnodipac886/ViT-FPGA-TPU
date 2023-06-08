import accelerator_types::*;

module accelerator_ctl #(
	parameter ADDR_WIDTH 			= 32,
	parameter DATA_WIDTH 			= 1024,
	parameter DATA_WIDTH_SHIFT 		= $clog2(DATA_WIDTH),
	parameter NUM_REG				= 13,
	parameter REG_WIDTH				= 32,
	parameter REG_BYTES				= REG_WIDTH / `BYTE,
	parameter REG_B_SHIFT 			= $clog2(REG_BYTES),
	parameter DATA_PRECISION 		= 16,	// fp16
	parameter MIG_DATA_WIDTH 		= 1024,
	parameter MIG_BYTE_WIDTH 		= MIG_DATA_WIDTH / `BYTE,
	parameter MIG_BYTE_SHIFT 		= $clog2(MIG_BYTE_WIDTH),
	parameter W_STRB_SIZE 			= DATA_WIDTH >> $clog2(`BYTE),

	parameter SYS_ARR_IN_PRECISION	= 16, 
	parameter SYS_ARR_OUT_PRECISION	= SYS_ARR_IN_PRECISION,
	parameter SYS_ARR_SIZE			= 32,
	parameter SYS_ARR_OUT_WIDTH 	= SYS_ARR_OUT_PRECISION * SYS_ARR_SIZE * SYS_ARR_SIZE,
	parameter SYS_BRAM_R_STRIDE		= SYS_ARR_SIZE * SYS_ARR_IN_PRECISION* 2 / BRAM_DIN_WIDTH, // address stride = array size * bits per pe / bits per addr
	parameter SYS_MAC_LATENCY		= 12,
	parameter SYS_COMP_COUNTER_LIMIT= (SYS_ARR_SIZE << 1) - 1 + SYS_MAC_LATENCY + SYS_ARR_SIZE,
	parameter SYS_COUNTER_WIDTH		= $clog2(SYS_ARR_OUT_WIDTH / DATA_WIDTH),
	parameter SYS_SKEW_LEN 			= (SYS_ARR_SIZE << 1) - 1,
	parameter SYS_RD_COUNTER_LIMIT 	= SYS_ARR_SIZE * SYS_ARR_SIZE * DATA_PRECISION / DATA_WIDTH,
	parameter SYS_MIG_LEN 			= SYS_ARR_OUT_WIDTH / `BYTE / MIG_BYTE_WIDTH,

	parameter BRAM_ADDR_WIDTH		= 32,
	parameter BRAM_DIN_WIDTH		= SYS_ARR_IN_PRECISION * SYS_ARR_SIZE * 2,
	parameter BRAM_DOUT_WIDTH		= SYS_ARR_IN_PRECISION * SYS_ARR_SIZE * 2
) (
	input	logic 								clk_i,
	input	logic 								reset_n,
	input	logic [ADDR_WIDTH-1:0] 				r_addr_i,
	input	logic 								r_valid_i,
	input	logic [ADDR_WIDTH-1:0] 				w_addr_i,
	input	logic [DATA_WIDTH-1:0]				w_data_i,
	input 	logic [W_STRB_SIZE-1:0]				w_strb_i,
	input	logic 								w_valid_i,
	input	logic [SYS_ARR_OUT_WIDTH-1:0] 		sys_output_i,
	input	logic 								sys_output_valid_i,

	output	logic [DATA_WIDTH-1:0]				r_data_o,
	output	logic 								sys_valid_o,
	output	logic 								sys_data_sel_o,
	output	logic 								sys_reset_o,
	output 	logic 								accel_reset_o,

	accel_mig_itf								mig_port,
	bram_itf									bram_a_port,
	bram_itf									bram_b_port
);
	logic 	[REG_WIDTH-1:0] 					_mmio_reg 	[NUM_REG];
	logic 	[BRAM_DOUT_WIDTH-1:0]				_bram_a_dout, _bram_b_dout;
	logic 	[ADDR_WIDTH-1:0] 					_r_addr_i, _w_addr_i;
	logic	[BRAM_ADDR_WIDTH-1:0]				_bram_a_addr, _bram_b_addr;
	logic	[SYS_COUNTER_WIDTH:0]				_sys_read_counter;
	logic	[$clog2(SYS_COMP_COUNTER_LIMIT):0]	_sys_compute_counter;
	logic 	[DATA_WIDTH-1:0]					_sys_read_data, _sys_read_data_rev;
	logic 										_sys_valid, _sys_valid_1; // compensate for 2 cycle delay on the bram read port
	logic 										_accel_reset_count;
	accel_instr_e								_saved_instruction;

	assign bram_a_port.addr 		= _bram_a_addr;
	assign bram_a_port.bram_din		= mig_port.data;
	assign bram_a_port.we			= mig_port.data_valid & (_saved_instruction == I_R_MAT_A);
	assign _bram_a_dout				= bram_a_port.bram_dout;

	assign bram_b_port.addr 		= _bram_b_addr;
	assign bram_b_port.bram_din		= mig_port.data;
	assign bram_b_port.we			= mig_port.data_valid & (_saved_instruction == I_R_MAT_B);
	assign _bram_b_dout				= bram_b_port.bram_dout;

	assign sys_data_sel_o			= _sys_compute_counter[0];
	
	typedef enum logic [$clog2(NUM_REG)-1:0] { 
		MATRIX_A_ADDR 			= 'd0,
		MATRIX_B_ADDR 			= 'd1,
		MATRIX_C_ADDR 			= 'd2,
		MATRIX_A_SIZE 			= 'd3,		// sizes in terms of bytes
		MATRIX_B_SIZE 			= 'd4,
		MATRIX_C_SIZE 			= 'd5,		// TODO: we might want to have fp32 for answer
		MATRIX_M_SIZE 			= 'd6,
		MATRIX_N_SIZE 			= 'd7,
		MATRIX_K_SIZE 			= 'd8,
		ACCEL_INSTR				= 'd9,
		ACCEL_STATE 			= 'd10,
		ACCEL_DATA				= 'd11,
		SYS_ARR_OUTPUT			= 'd12		// TODO: need this to be 512 bits
	} accel_mmio_reg_e;

	// ila_0 accel_reg(
	// 	.clk(clk_i),
	// 	.probe0 (sys_output_i),
	// 	.probe1 (_sys_read_data_rev),
	// 	.probe2  (mig_port.wdata),

	// 	.probe3 (_mmio_reg[MATRIX_A_ADDR]),
	// 	.probe4 (_mmio_reg[MATRIX_B_ADDR]),
	// 	.probe5 (_mmio_reg[MATRIX_C_ADDR]),
	// 	// .probe5 (_mmio_reg[MATRIX_A_SIZE]),
	// 	// .probe6 (_mmio_reg[MATRIX_B_SIZE]),
	// 	.probe6	(_sys_read_counter),
	// 	.probe7	(_mmio_reg[ACCEL_INSTR]),
	// 	.probe8	(_mmio_reg[ACCEL_STATE]),
	// 	// .probe10(_mmio_reg[ACCEL_DATA]),
	// 	// .probe11(_mmio_reg[SYS_ARR_OUTPUT]),
	// 	.probe9(r_addr_i),
	// 	.probe10(w_addr_i),
	// 	.probe11(w_data_i),
	// 	.probe12(mig_port.arwlen),
	// 	.probe13(w_strb_i),

	// 	.probe14(mig_port.wvalid),
	// 	.probe15(sys_reset_o),
	// 	.probe16(r_valid_i),
	// 	.probe17(w_valid_i)
	// );

	task reset();
		for (int i = 0; i < NUM_REG; i += 1) begin
			_mmio_reg[i] 		<= '0;
		end

		mig_port.addr			<= '0;
		reset_arwvalid();
		mig_port.arwlen			<= '0;
		mig_port.wvalid			<= '0;
		mig_port.wstrb			<= '0;
		mig_port.wlast			<= '0;
		mig_port.bready			<= '1;

		_saved_instruction		<= I_IDLE;

		_bram_a_addr			<= '0;
		_bram_b_addr			<= '0;

		_sys_read_counter		<= '0;
		_sys_compute_counter	<= '0;
		_sys_read_data_rev		<= '0;
		_sys_valid				<= '0;
		_sys_valid_1			<= '0;
		sys_valid_o				<= '0;
		sys_reset_o				<= '1;
		accel_reset_o			<= '1;
		_accel_reset_count		<= '0;
	endtask;

	// TODO: simply this, causing timing issues
	task mmio_reg_write(logic [$clog2(NUM_REG)-1:0] addr, logic [DATA_WIDTH-1:0] data);
		_mmio_reg[addr] <= data[REG_WIDTH-1:0];
		// for (int i = 1; i <= W_STRB_SIZE >> REG_B_SHIFT; i += 1) begin
		// 	if (w_strb_i[i*REG_BYTES-1 -: REG_BYTES] == '1) begin 
		// 		_mmio_reg[addr] <= data[i*REG_WIDTH-1 -:REG_WIDTH];
		// 	end 
		// end
	endtask

	task handle_reg_write();
		if (w_valid_i) begin
			mmio_reg_write(_w_addr_i, w_data_i);
		end 
	endtask

	task mig_send_rq(input logic[DATA_WIDTH-1:0] addr, input logic [7:0] len, input logic rd_wr);
		mig_port.addr			<= addr;
		mig_port.arvalid		<= READ == rd_wr;
		mig_port.awvalid		<= WRITE == rd_wr;
		mig_port.arwlen			<= len - 1;
	endtask

	task reset_arwvalid();
		mig_port.arvalid		<= '0;
		mig_port.awvalid		<= '0;
	endtask

	task accel_mig_instr_logic();
		unique case(_mmio_reg[ACCEL_INSTR])
			I_R_MAT_A: begin 
				mig_send_rq(_mmio_reg[MATRIX_A_ADDR], (_mmio_reg[MATRIX_A_SIZE] >> MIG_BYTE_SHIFT) + |(_mmio_reg[MATRIX_A_SIZE][$clog2(MIG_DATA_WIDTH):0]), READ); // right shift 2 for 32 bits = 4 bytes, burst len = total bytes / bytes per burst
			end 

			I_R_MAT_B: begin 
				mig_send_rq(_mmio_reg[MATRIX_B_ADDR], (_mmio_reg[MATRIX_B_SIZE] >> MIG_BYTE_SHIFT) + |(_mmio_reg[MATRIX_B_SIZE][$clog2(MIG_DATA_WIDTH):0]), READ); // right shift 2 for 32 bits = 4 bytes, burst len = total bytes / bytes per burst
			end 

			default:;
		endcase
	endtask

	task idle_next_state_logic();
		_saved_instruction				<= accel_instr_e'(_mmio_reg[ACCEL_INSTR]);
		unique case (_mmio_reg[ACCEL_INSTR])
			I_R_MAT_A, I_R_MAT_B: begin 
				_mmio_reg[ACCEL_STATE] 	<= S_WAIT_ARW_READY;
				_mmio_reg[ACCEL_INSTR]	<= I_IDLE;
				_bram_a_addr			<= '0;
				_bram_b_addr			<= '0;
			end

			I_R_MAT_C: begin 
				_mmio_reg[ACCEL_STATE] 	<= S_SEND_MAT_C;
				_mmio_reg[ACCEL_INSTR]	<= I_IDLE;
			end 

			I_GEMM: begin
				_mmio_reg[ACCEL_STATE] 	<= S_WAIT_COMPUTE;
				_mmio_reg[ACCEL_INSTR]	<= I_IDLE;
				_bram_a_addr			<= '0;
				_bram_b_addr			<= '0;
				_sys_valid				<= 1'b1;
				sys_reset_o				<= 1'b1;
			end

			I_RESET: begin 
				if (accel_reset_o) begin 
					accel_reset_o				<= '0;
				end else begin 
					_accel_reset_count			<= ~_accel_reset_count;
					if (_accel_reset_count) begin 
						accel_reset_o			<= '1;
						_mmio_reg[ACCEL_INSTR]	<= I_IDLE;
					end 
				end 
			end

			default:;
		endcase
	endtask

	task accel_ctl_logic();
		unique case(_mmio_reg[ACCEL_STATE])
			S_IDLE: begin 
				accel_mig_instr_logic();
				idle_next_state_logic();
			end

			S_WAIT_ARW_READY: begin 
				if (mig_port.arready) begin 
					_mmio_reg[ACCEL_STATE]			<= S_WAIT_RW;
					reset_arwvalid();
				end 
			end 

			S_WAIT_RW: begin 
				if (mig_port.data_valid) begin 
					if (mig_port.rw_last) begin 
						_mmio_reg[ACCEL_STATE]		<= S_IDLE;
						_saved_instruction			<= I_IDLE;
					end 

					unique case(_saved_instruction)
						I_R_MAT_A: begin
							_bram_a_addr			<= _bram_a_addr + 1;
						end 

						I_R_MAT_B: begin 
							_bram_b_addr			<= _bram_b_addr + 1;
						end 
						
						default:;
					endcase
				end 
			end 

			S_SEND_MAT_C: begin 
				// first send the write request if ready
				if (~mig_port.awvalid && _sys_read_counter == '0) begin
					mig_send_rq(_mmio_reg[MATRIX_C_ADDR], SYS_MIG_LEN, WRITE);
				end

				// turn off the valid signal when ready
				if (mig_port.awvalid & mig_port.awready) begin 
					reset_arwvalid();
					_sys_read_counter			<= 'd1;
					_sys_read_data_rev			<= sys_output_i[((SYS_RD_COUNTER_LIMIT) << DATA_WIDTH_SHIFT) - 1 -: DATA_WIDTH];
				end

				// start sending to dram
				mig_port.wvalid					<= (_sys_read_counter > '0) && (_sys_read_counter < SYS_RD_COUNTER_LIMIT);
				mig_port.wstrb					<= (_sys_read_counter) <= SYS_RD_COUNTER_LIMIT ? '1 : '0;
				
				if (_sys_read_counter > '0 && (_sys_read_counter-1 < SYS_RD_COUNTER_LIMIT) && mig_port.wready && mig_port.wvalid) begin 
					_sys_read_counter			<= _sys_read_counter + 1;
					_sys_read_data_rev			<= sys_output_i[((SYS_RD_COUNTER_LIMIT - (_sys_read_counter)) << DATA_WIDTH_SHIFT) - 1 -: DATA_WIDTH];
					mig_port.wlast				<= (_sys_read_counter+1) == SYS_RD_COUNTER_LIMIT;
				end

				// wait for the b channel response
				if (_sys_read_counter == (SYS_RD_COUNTER_LIMIT+1) && mig_port.bvalid) begin 
					_sys_read_counter			<= _sys_read_counter + 1;
					mig_port.bready				<= '0;
				end 

				// done with txn
				if ((_sys_read_counter) == (SYS_RD_COUNTER_LIMIT+2) && ~mig_port.bready) begin 
					mig_port.bready				<= '1;
					_mmio_reg[ACCEL_STATE] 		<= S_IDLE;
					sys_reset_o					<= '0;
					_sys_read_counter			<= '0;
				end 

				// _sys_read_data_rev				<= sys_output_i[((SYS_RD_COUNTER_LIMIT - _sys_read_counter) << DATA_WIDTH_SHIFT) - 1 -: DATA_WIDTH];
				
				// if (_sys_read_counter == (SYS_RD_COUNTER_LIMIT)) begin 
				// 	_mmio_reg[ACCEL_STATE] 		<= S_IDLE;
				// 	sys_reset_o					<= '0;
				// 	_sys_read_counter			<= '0;
				// end else if (r_valid_i) begin 
				// 	_sys_read_counter			<= _sys_read_counter + 1;
				// end 
			end 

			S_WAIT_COMPUTE: begin 
				if (_sys_compute_counter[0]) begin // increment every 2 cycles since bram has read latency of 2
					_bram_a_addr				<= _bram_a_addr + SYS_BRAM_R_STRIDE;
					_bram_b_addr				<= _bram_b_addr + SYS_BRAM_R_STRIDE;
				end 

				if (_sys_compute_counter == (SYS_SKEW_LEN - 1)) begin 
					_sys_valid					<= '0;
				end 

				if (_sys_compute_counter == (SYS_COMP_COUNTER_LIMIT - 1)) begin 
					_mmio_reg[ACCEL_STATE] 		<= S_SEND_MAT_C;	// TODO: change back to idle if don't want to write result to mem
					_sys_compute_counter		<= '0;
				end else begin 
					_sys_compute_counter		<= _sys_compute_counter + 1;
				end 
			end 

			default:;
		endcase
	endtask

	task misc();
		_r_addr_i		<= r_addr_i;
		_w_addr_i		<= w_addr_i;

		_sys_valid_1	<= _sys_valid;
		sys_valid_o		<= _sys_valid_1;
	endtask;

	function void handle_reg_read();
		r_data_o				= '0; 
		if (r_valid_i) begin 
			// r_data_o			= _mmio_reg[ACCEL_STATE] == S_SEND_MAT_C ? _sys_read_data : _mmio_reg[_r_addr_i];
			r_data_o			= _mmio_reg[_r_addr_i];
		end
	endfunction

	always_ff @( posedge clk_i ) begin
		if (~reset_n) begin
			reset();
		end else begin 
			misc();
			handle_reg_write();
			accel_ctl_logic();
		end 
	end

	always_comb begin
		handle_reg_read();
	end

	always_comb begin : rev_sys_read_data
		for (int i = 0; i < DATA_WIDTH / DATA_PRECISION; i++) begin 
			_sys_read_data[(i+1) * DATA_PRECISION - 1 -: DATA_PRECISION] = 
				_sys_read_data_rev[((DATA_WIDTH / DATA_PRECISION) - i) * DATA_PRECISION - 1 -: DATA_PRECISION];
		end 
		mig_port.wdata	= _sys_read_data;
	end

endmodule