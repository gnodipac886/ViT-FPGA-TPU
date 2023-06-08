package accelerator_types;
`define BYTE 8

typedef enum logic {
	READ 				= 1'b0,
	WRITE 				= 1'b1
} rd_wr_e;

typedef enum logic [31:0] { 
	I_IDLE				= 32'd0,
	I_R_MAT_A			= 32'd1,
	I_R_MAT_B			= 32'd2,
	I_R_MAT_C			= 32'd3,
	I_GEMM				= 32'd4,
	I_RESET				= 32'd5
} accel_instr_e;

typedef enum logic [31:0] {  
	S_IDLE				= 32'd0,
	S_WAIT_ARW_READY	= 32'd1,
	S_WAIT_RW			= 32'd2,
	S_WAIT_COMPUTE		= 32'd3,
	S_SEND_MAT_C		= 32'd4,
	S_DONE				= 32'd5
} accel_state_e;

typedef enum logic [31:0] {  
	S_W_IDLE			= 32'd0,
	S_W_SEND_WVALID		= 32'd1,
	S_W_LOW_WVALID 		= 32'd2,
	S_W_SEND_DATA		= 32'd3,
	S_W_WAIT_BRESP		= 32'd4,
	S_W_DONE			= 32'd5
} axi_wstate_e;

endpackage

interface accel_mig_itf #(
	parameter ADDR_WIDTH = 32,
	parameter DATA_WIDTH = 512
)();
	logic 	[ADDR_WIDTH-1:0] 		addr;
	logic							arvalid;	// address read valid
	logic 							awvalid;	// address write valid
	logic 	[7:0]					arwlen;		// burst length of read or write
	logic 							awready;	// mig ready to take address
	logic 							arready;	// mig ready to take address

	// w channel
	logic							wvalid;
	logic	[DATA_WIDTH-1:0]		wdata;
	logic	[DATA_WIDTH/`BYTE-1:0]	wstrb;
	logic							wlast;
	logic 							wready;

	// b channel
	logic 							bvalid;
	logic							bready;

	// mig outputs
	logic 	[DATA_WIDTH-1:0] 		data;
	logic 							data_valid;
	logic 							rw_last;
	logic 							arwready;	// mig ready to take address

	modport accel (
		input 	data,
		input 	data_valid,
		input 	rw_last,
		// input 	arwready,
		input	awready,
		input 	arready,

		output	addr,
		output	arvalid,
		output	awvalid,
		output	arwlen,

		// w channel
		output	wvalid,
		output	wdata,
		output	wstrb,
		output	wlast,
		input	wready,

		// b channel
		input	bvalid,
		output 	bready
	);

	modport mig (
		input	addr,
		input	arvalid,
		input	awvalid,
		input	arwlen, 

		// w channel
		input	wvalid,
		input	wdata,
		input	wstrb,
		input	wlast,
		output	wready,

		output 	data,
		output 	data_valid,
		output 	rw_last,
		// output 	arwready
		output	awready,
		output 	arready,

		// b channel
		output	bvalid,
		input 	bready
	);
	
endinterface //accel_mig_itf

interface bram_itf #(
	parameter ADDR_WIDTH = 9,
	parameter DIN_WIDTH	 = 64,
	parameter DOUT_WIDTH = 256
)();
	logic 	[ADDR_WIDTH-1:0]	addr;
	logic 	[DIN_WIDTH-1:0]		bram_din;
	logic 	[DOUT_WIDTH-1:0]	bram_dout;
	logic						we;

	modport ctlr (
		input 	bram_dout,
		output 	addr,
		output 	bram_din,
		output 	we
	);

	modport bram (
		input 	addr,
		input 	bram_din,
		input 	we,
		output 	bram_dout
	);
	
endinterface //bram_itf