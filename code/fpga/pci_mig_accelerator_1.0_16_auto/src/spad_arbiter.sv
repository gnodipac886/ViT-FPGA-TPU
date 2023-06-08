`timescale 1ns / 1ps

import accelerator_types::*;

module spad_arbiter #(
	parameter ADDR_WIDTH 			= 32,
	parameter DATA_WIDTH 			= 1024,
	parameter REG_WIDTH				= 32
) (
	input 	logic 								clk_i,
	input 	logic 								rst_n,
	input 	logic		[ADDR_WIDTH-1:0]		mat_a_addr_i,
	input 	logic		[ADDR_WIDTH-1:0]		mat_b_addr_i,
	input 	logic 		[REG_WIDTH-1:0]			mat_a_len,
	input 	logic 		[REG_WIDTH-1:0]			mat_b_len,
	input 	logic								bram_rd_sel_i,
	input	accel_state_e 						accel_state,

	output	logic 								spad_mat_ab_rd_done_o,

	// from the accelerator controller
	accel_mig_itf								ctl_mig_port,
	bram_itf									ctl_bram_a_port,
	bram_itf									ctl_bram_b_port,

	// to scratchpad bram
	accel_mig_itf								out_mig_port,
	bram_itf									out_bram_a_port_0,
	bram_itf									out_bram_b_port_0,
	bram_itf									out_bram_a_port_1,
	bram_itf									out_bram_b_port_1

);
	// internal migport signals
	logic 	[ADDR_WIDTH-1:0] 		_mig_port_addr;
	logic							_mig_port_arvalid;	
	logic 							_mig_port_awvalid;	
	logic 	[7:0]					_mig_port_arwlen;		
	logic 							_mig_port_awready;	
	logic 							_mig_port_arready;	

	// w channel
	logic							_mig_port_wvalid;
	logic	[DATA_WIDTH-1:0]		_mig_port_wdata;
	logic	[DATA_WIDTH/`BYTE-1:0]	_mig_port_wstrb;
	logic							_mig_port_wlast;
	logic 							_mig_port_wready;

	// b channel
	logic 							_mig_port_bvalid;
	logic							_mig_port_bready;
	
	// mig outputs
	logic 	[DATA_WIDTH-1:0] 		_mig_port_data;
	logic 							_mig_port_data_valid;
	logic 							_mig_port_rw_last;
	logic 							_mig_port_arwready;

	// internal bram signals
	logic 	[ADDR_WIDTH-1:0]		_bram_addr;
	logic 	[DATA_WIDTH-1:0]		_bram_bram_din;
	// logic 	[DOUT_WIDTH-1:0]	bram_dout;
	logic							_bram_we_a, _bram_we_b;
	
	logic							_bram_a_done, _bram_b_done;
	accel_state_e					_arbiter_state;

	assign _bram_bram_din 				= _mig_port_data;
	assign _bram_we_a					= _mig_port_data_valid && (_arbiter_state == S_WAIT_RW) && ~_bram_a_done;
	assign _bram_we_b					= _mig_port_data_valid && (_arbiter_state == S_WAIT_RW) && (_bram_a_done & ~_bram_b_done);
	assign spad_mat_ab_rd_done_o		= _bram_a_done & _bram_b_done;

	task reset();
		// mig port
		_mig_port_addr					<= '0;
		_mig_port_arvalid				<= '0;
		_mig_port_awvalid				<= '0;
		_mig_port_arwlen				<= '0;
		_mig_port_wvalid				<= '0;
		// _mig_port_wdata					<= '0;
		_mig_port_wstrb					<= '0;
		_mig_port_wlast					<= '0;
		_mig_port_bready				<= '0;

		// bram port
		_bram_addr						<= '0;

		// state
		_bram_a_done					<= '0;
		_bram_b_done					<= '0;
		_arbiter_state					<= S_IDLE;
	endtask

	task mig_send_rq(input logic[DATA_WIDTH-1:0] addr, input logic [7:0] len, input logic rd_wr);
		_mig_port_addr			<= addr;
		_mig_port_arvalid		<= READ == rd_wr;
		_mig_port_awvalid		<= WRITE == rd_wr;
		_mig_port_arwlen		<= len - 1;
	endtask

	task reset_arwvalid();
		_mig_port_arvalid		<= '0;
		_mig_port_awvalid		<= '0;
	endtask

	always_ff @(posedge clk_i ) begin
		if (~rst_n) begin 
			reset();
		end else if (accel_state == S_WAIT_COMPUTE) begin 
			unique case (_arbiter_state) 
				S_IDLE: begin 
					_bram_addr				<= '0;

					unique case({_bram_a_done, _bram_b_done})
						2'b00: begin 
							mig_send_rq(mat_a_addr_i, mat_a_len, READ);
							_arbiter_state 	<= S_WAIT_ARW_READY;
						end 

						2'b10: begin 
							mig_send_rq(mat_b_addr_i, mat_b_len, READ);
							_arbiter_state 	<= S_WAIT_ARW_READY;
						end 

						default:;
					
					endcase
				end 
				
				S_WAIT_ARW_READY: begin 
					if (_mig_port_arready) begin 
						_arbiter_state		<= S_WAIT_RW;
						reset_arwvalid();
					end 
				end 
				
				S_WAIT_RW: begin 
					if (_mig_port_data_valid) begin 
						if (_mig_port_rw_last) begin 
							_arbiter_state	<= S_IDLE;
							_bram_a_done	<= '1;
							_bram_b_done	<= _bram_a_done;
						end 
						_bram_addr			<= _bram_addr + 1;
					end 
				end 
				
			endcase
		end else begin 
			reset();
		end 
	end

	always @(posedge clk_i) begin
		arbit_mig();
		arbit_bram();
	end

	always_comb begin
		ctl_mig_port.wready		= out_mig_port.wready;
		out_mig_port.wdata		= ctl_mig_port.wdata;
		out_mig_port.wvalid		= ctl_mig_port.wvalid;
	end

	// always_comb begin : arbiter
	task arbit_mig();
		unique case(accel_state == S_WAIT_COMPUTE)
			1'b0: begin 
				out_mig_port.addr		<= ctl_mig_port.addr;
				out_mig_port.arvalid	<= ctl_mig_port.arvalid;
				out_mig_port.awvalid	<= ctl_mig_port.awvalid;
				out_mig_port.arwlen		<= ctl_mig_port.arwlen;
				// out_mig_port.wvalid		<= ctl_mig_port.wvalid;
				// out_mig_port.wdata		<= ctl_mig_port.wdata;
				out_mig_port.wstrb		<= ctl_mig_port.wstrb;
				out_mig_port.wlast		<= ctl_mig_port.wlast;
				out_mig_port.bready		<= ctl_mig_port.bready;

				// ctl_mig_port.wready		<= out_mig_port.wready;
				ctl_mig_port.data		<= out_mig_port.data;
				ctl_mig_port.data_valid	<= out_mig_port.data_valid;
				ctl_mig_port.rw_last	<= out_mig_port.rw_last;
				ctl_mig_port.awready	<= out_mig_port.awready;
				ctl_mig_port.arready	<= out_mig_port.arready;
				ctl_mig_port.bvalid		<= out_mig_port.bvalid;
			end 

			1'b1: begin 
				out_mig_port.addr		<= _mig_port_addr;
				out_mig_port.arvalid	<= _mig_port_arvalid;
				out_mig_port.awvalid	<= _mig_port_awvalid;
				out_mig_port.arwlen		<= _mig_port_arwlen;
				// out_mig_port.wvalid		<= _mig_port_wvalid;
				// out_mig_port.wdata		<= _mig_port_wdata;
				out_mig_port.wstrb		<= _mig_port_wstrb;
				out_mig_port.wlast		<= _mig_port_wlast;
				out_mig_port.bready		<= _mig_port_bready;

				// _mig_port_wready		<= out_mig_port.wready;
				_mig_port_data			<= out_mig_port.data;
				_mig_port_data_valid	<= out_mig_port.data_valid;
				_mig_port_rw_last		<= out_mig_port.rw_last;
				_mig_port_awready		<= out_mig_port.awready;
				_mig_port_arready		<= out_mig_port.arready;
				_mig_port_bvalid		<= out_mig_port.bvalid;
			end

			default:;
		endcase
	endtask
	// end

	// always_comb begin : bram_arbiter
	task arbit_bram();
		unique case(bram_rd_sel_i)
			1'b0: begin // read into bram 0, controller controlls bram 1
				// out_bram_a_port_0.bram_dout
				out_bram_a_port_0.addr		<= _bram_addr;
				out_bram_a_port_0.bram_din	<= _bram_bram_din;
				out_bram_a_port_0.we		<= _bram_we_a;

				// out_bram_b_port_0.bram_dout
				out_bram_b_port_0.addr		<= _bram_addr;
				out_bram_b_port_0.bram_din	<= _bram_bram_din;
				out_bram_b_port_0.we		<= _bram_we_b;

				// out_bram_a_port_1.bram_dout
				out_bram_a_port_1.addr		<= ctl_bram_a_port.addr;
				out_bram_a_port_1.bram_din	<= ctl_bram_a_port.bram_din;
				out_bram_a_port_1.we		<= ctl_bram_a_port.we;

				// out_bram_b_port_1.bram_dout
				out_bram_b_port_1.addr		<= ctl_bram_b_port.addr;
				out_bram_b_port_1.bram_din	<= ctl_bram_b_port.bram_din;
				out_bram_b_port_1.we		<= ctl_bram_b_port.we;
			end 

			1'b1: begin // read into bram 1, controller controlls bram 0
				// out_bram_a_port_1.bram_dout
				out_bram_a_port_1.addr		<= _bram_addr;
				out_bram_a_port_1.bram_din	<= _bram_bram_din;
				out_bram_a_port_1.we		<= _bram_we_a;

				// out_bram_b_port_1.bram_dout
				out_bram_b_port_1.addr		<= _bram_addr;
				out_bram_b_port_1.bram_din	<= _bram_bram_din;
				out_bram_b_port_1.we		<= _bram_we_b;

				// out_bram_a_port_0.bram_dout
				out_bram_a_port_0.addr		<= ctl_bram_a_port.addr;
				out_bram_a_port_0.bram_din	<= ctl_bram_a_port.bram_din;
				out_bram_a_port_0.we		<= ctl_bram_a_port.we;

				// out_bram_b_port_0.bram_dout
				out_bram_b_port_0.addr		<= ctl_bram_b_port.addr;
				out_bram_b_port_0.bram_din	<= ctl_bram_b_port.bram_din;
				out_bram_b_port_0.we		<= ctl_bram_b_port.we;
			end 

			default:; 
		endcase
	endtask
	// end

endmodule
