// import pysv::*;

module top;
	/**************************** TIMING DECLARATION ******************************/
    timeunit 1ns;
    timeprecision 1ns;
    int timeout = 100000;

    /***************************** CLOCK GENERATION *******************************/
    bit clk;
    always #5 clk = clk === 1'b0;

    /*************************** TESTBENCH DECLARATION ****************************/
    // SystolicArrayTB pytb;
    // PE_tb tb_i(.*);
	systolic_array_OS_tb tb_i(.*);

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
		// $vcdpluson;
		$dumpfile("waveform.vcd");
		$dumpvars();

        // pytb = new();
        // pytb.print_hello();

		tb_i.main();

		$display("		SUCCESS!!! 💯 💯 💯 ✅ ✅ ✅");
		$finish;
		// $vcdplusclose;
	end

endmodule