`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2023 03:04:19 AM
// Design Name: 
// Module Name: accelerator_tb
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


module accelerator_tb();
	/**************************** TIMING DECLARATION ******************************/
    timeunit 1ns;
    timeprecision 1ns;
    int timeout = 10000;

    /***************************** CLOCK GENERATION *******************************/
    bit clk;
    always #5 clk = clk === 1'b0;
	default clocking tb_clk @(posedge clk); endclocking

    /*************************** TESTBENCH DECLARATION ****************************/
	logic 			clk_i;
	logic 			reset_n;
	logic [32:0] 	axi_araddr_dma_i;
	logic [7:0] 	axi_arlen_dma_i;
	logic [1:0] 	axi_arburst_dma_i;
	logic 			axi_arvalid_dma_i;
	logic 			axi_rready_dma_i; // dma ready to accept read result
	logic 			axi_arready_mig_i; // mig ready to accept new address
	logic [63:0] 	axi_rdata_mig_i;
	logic [1:0] 	axi_rresp_mig_i;
	logic 			axi_rlast_mig_i;
	logic 			axi_rvalid_mig_i; // read data is available
	logic [32:0] 	axi_araddr_mig_o;
	logic [7:0] 	axi_arlen_mig_o;
	logic [1:0] 	axi_arburst_mig_o;
	logic 			axi_arvalid_mig_o;
	logic 			axi_rready_mig_o; // dma ready to accept read result
	logic 			axi_arready_dma_o;
	logic [63:0] 	axi_rdata_dma_o;
	logic [1:0] 	axi_rresp_dma_o;
	logic 			axi_rlast_dma_o;
	logic 			axi_rvalid_dma_o; // read data is available

	logic 			_is_accel_addr;
	logic [1:0]		_state;
	logic [63:0] 	_counter;
	logic [1:0]		_axi_rresp_accel;
	logic 			_axi_rvalid_accel;

	assign clk_i = clk;

    accelerator tb_i(.*);

	/******************************* TIME OUT TRAP ********************************/
    always @(posedge clk) begin
		if (timeout == 0) begin
			$display("		Timed out ⏳⏳⏳ ❌ ❌ ❌");
			$finish;
		end
		timeout <= timeout - 1;
	end

	task reset();
		reset_n				<= 1'b0;
		axi_araddr_dma_i	<= '0;
		axi_arvalid_dma_i	<= '0;
		axi_rready_dma_i	<= '0;

		axi_arready_mig_i	<= '0;
		axi_rdata_mig_i		<= '0;
		axi_rresp_mig_i		<= '0;
		axi_rvalid_mig_i	<= '0;

		##1;
		reset_n				<= 1'b1;
	endtask

	task accelerator_read();
		##1;
		// mig ready to take address
		axi_arready_mig_i	<= 1'b1;
		axi_rready_dma_i	<= 1'b0;

		##1;
		// set address and valid
		axi_araddr_dma_i	<= 33'hdeadbeef;
		axi_arvalid_dma_i	<= 1'b1;

		@(axi_arready_dma_o);
		axi_arvalid_dma_i	<= 1'b0;

		##5;
		// dma ready to take data back
		axi_rready_dma_i	<= 1'b1;

		@(axi_rvalid_dma_o);
		##1;
		axi_araddr_dma_i	<= '0;
		axi_arvalid_dma_i	<= '0;
		axi_rready_dma_i	<= '0;

		##1;
	endtask

	task main();
		reset();

		##1;
		// mig ready to take address
		axi_arready_mig_i	<= 1'b1;

		##1;
		// set address and valid
		axi_araddr_dma_i	<= 33'd0;
		axi_arvalid_dma_i	<= 1'b1;

		##1;
		// dma ready to take data back
		axi_rready_dma_i	<= 1'b1;

		##3;
		// mig send data back
		axi_rdata_mig_i		<= 64'hb00b;
		axi_rresp_mig_i		<= 2'b00;
		axi_rvalid_mig_i	<= 1'b1;

		reset();

		accelerator_read();
		accelerator_read();
		// accelerator_read();
		// accelerator_read();

		##10;
	endtask

	/**************************** INITIAL DECLARATION ******************************/
    initial begin
		$dumpfile("waveform.vcd");
		$dumpvars();

		main();

		$display("		SUCCESS!!! 💯 💯 💯 ✅ ✅ ✅");
		$finish;
	end

endmodule
