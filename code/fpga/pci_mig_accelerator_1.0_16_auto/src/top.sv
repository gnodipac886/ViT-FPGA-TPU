module top;
	/**************************** TIMING DECLARATION ******************************/
    timeunit 1ns;
    timeprecision 1ns;
    int timeout = 10000;

    /***************************** CLOCK GENERATION *******************************/
    bit clk;
    always #5 clk = clk === 1'b0;
    default clocking tb_clk @(posedge clk); endclocking

    /*************************** TESTBENCH DECLARATION ****************************/
    accelerator_ctl_tb tb_i(.*);

	/******************************* TIME OUT TRAP ********************************/
    always @(posedge clk) begin
		if (timeout == 0) begin
			$display("		Timed out ⏳⏳⏳ ❌ ❌ ❌");
			$finish;
		end
		timeout <= timeout - 1;
	end

	/**************************** INITIAL DECLARATION ******************************/
    initial begin
		$dumpfile("waveform.vcd");
		$dumpvars();

		tb_i.main();

		$display("		SUCCESS!!! 💯 💯 💯 ✅ ✅ ✅");
		$finish;
	end

endmodule
