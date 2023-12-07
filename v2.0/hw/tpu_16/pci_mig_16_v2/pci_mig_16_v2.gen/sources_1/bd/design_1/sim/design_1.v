//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Tue Dec  5 19:26:34 2023
//Host        : the-cow running 64-bit Ubuntu 22.04.3 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=5,da_board_cnt=8,da_bram_cntlr_cnt=2,da_clkrst_cnt=6,da_xdma_cnt=3,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (pcie_7x_mgt_rtl_rxn,
    pcie_7x_mgt_rtl_rxp,
    pcie_7x_mgt_rtl_txn,
    pcie_7x_mgt_rtl_txp,
    pcie_ref_clk_n,
    pcie_ref_clk_p,
    sys_rst);
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl rxn" *) input [7:0]pcie_7x_mgt_rtl_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl rxp" *) input [7:0]pcie_7x_mgt_rtl_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl txn" *) output [7:0]pcie_7x_mgt_rtl_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl txp" *) output [7:0]pcie_7x_mgt_rtl_txp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_ref CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pcie_ref, CAN_DEBUG false, FREQ_HZ 100000000" *) input [0:0]pcie_ref_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_ref CLK_P" *) input [0:0]pcie_ref_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYS_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYS_RST, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input sys_rst;

  wire [0:0]CLK_IN_D_0_1_CLK_N;
  wire [0:0]CLK_IN_D_0_1_CLK_P;
  wire [14:0]axi_bram_ctrl_1_BRAM_PORTA_ADDR;
  wire axi_bram_ctrl_1_BRAM_PORTA_CLK;
  wire [511:0]axi_bram_ctrl_1_BRAM_PORTA_DIN;
  wire [511:0]axi_bram_ctrl_1_BRAM_PORTA_DOUT;
  wire axi_bram_ctrl_1_BRAM_PORTA_EN;
  wire axi_bram_ctrl_1_BRAM_PORTA_RST;
  wire [63:0]axi_bram_ctrl_1_BRAM_PORTA_WE;
  wire [14:0]axi_bram_ctrl_1_BRAM_PORTB_ADDR;
  wire axi_bram_ctrl_1_BRAM_PORTB_CLK;
  wire [511:0]axi_bram_ctrl_1_BRAM_PORTB_DIN;
  wire [511:0]axi_bram_ctrl_1_BRAM_PORTB_DOUT;
  wire axi_bram_ctrl_1_BRAM_PORTB_EN;
  wire axi_bram_ctrl_1_BRAM_PORTB_RST;
  wire [63:0]axi_bram_ctrl_1_BRAM_PORTB_WE;
  wire [32:0]pci_mig_accelerator_0_m00_axi_ARADDR;
  wire [1:0]pci_mig_accelerator_0_m00_axi_ARBURST;
  wire [3:0]pci_mig_accelerator_0_m00_axi_ARCACHE;
  wire [0:0]pci_mig_accelerator_0_m00_axi_ARID;
  wire [7:0]pci_mig_accelerator_0_m00_axi_ARLEN;
  wire pci_mig_accelerator_0_m00_axi_ARLOCK;
  wire [2:0]pci_mig_accelerator_0_m00_axi_ARPROT;
  wire [3:0]pci_mig_accelerator_0_m00_axi_ARQOS;
  wire pci_mig_accelerator_0_m00_axi_ARREADY;
  wire [2:0]pci_mig_accelerator_0_m00_axi_ARSIZE;
  wire [0:0]pci_mig_accelerator_0_m00_axi_ARUSER;
  wire pci_mig_accelerator_0_m00_axi_ARVALID;
  wire [32:0]pci_mig_accelerator_0_m00_axi_AWADDR;
  wire [1:0]pci_mig_accelerator_0_m00_axi_AWBURST;
  wire [3:0]pci_mig_accelerator_0_m00_axi_AWCACHE;
  wire [0:0]pci_mig_accelerator_0_m00_axi_AWID;
  wire [7:0]pci_mig_accelerator_0_m00_axi_AWLEN;
  wire pci_mig_accelerator_0_m00_axi_AWLOCK;
  wire [2:0]pci_mig_accelerator_0_m00_axi_AWPROT;
  wire [3:0]pci_mig_accelerator_0_m00_axi_AWQOS;
  wire pci_mig_accelerator_0_m00_axi_AWREADY;
  wire [2:0]pci_mig_accelerator_0_m00_axi_AWSIZE;
  wire [0:0]pci_mig_accelerator_0_m00_axi_AWUSER;
  wire pci_mig_accelerator_0_m00_axi_AWVALID;
  wire [0:0]pci_mig_accelerator_0_m00_axi_BID;
  wire pci_mig_accelerator_0_m00_axi_BREADY;
  wire [1:0]pci_mig_accelerator_0_m00_axi_BRESP;
  wire [0:0]pci_mig_accelerator_0_m00_axi_BUSER;
  wire pci_mig_accelerator_0_m00_axi_BVALID;
  wire [511:0]pci_mig_accelerator_0_m00_axi_RDATA;
  wire [0:0]pci_mig_accelerator_0_m00_axi_RID;
  wire pci_mig_accelerator_0_m00_axi_RLAST;
  wire pci_mig_accelerator_0_m00_axi_RREADY;
  wire [1:0]pci_mig_accelerator_0_m00_axi_RRESP;
  wire pci_mig_accelerator_0_m00_axi_RVALID;
  wire [511:0]pci_mig_accelerator_0_m00_axi_WDATA;
  wire pci_mig_accelerator_0_m00_axi_WLAST;
  wire pci_mig_accelerator_0_m00_axi_WREADY;
  wire [63:0]pci_mig_accelerator_0_m00_axi_WSTRB;
  wire pci_mig_accelerator_0_m00_axi_WVALID;
  wire reset_rtl_1;
  wire [14:0]smartconnect_0_M00_AXI_ARADDR;
  wire [1:0]smartconnect_0_M00_AXI_ARBURST;
  wire [3:0]smartconnect_0_M00_AXI_ARCACHE;
  wire [7:0]smartconnect_0_M00_AXI_ARLEN;
  wire [0:0]smartconnect_0_M00_AXI_ARLOCK;
  wire [2:0]smartconnect_0_M00_AXI_ARPROT;
  wire smartconnect_0_M00_AXI_ARREADY;
  wire [2:0]smartconnect_0_M00_AXI_ARSIZE;
  wire smartconnect_0_M00_AXI_ARVALID;
  wire [14:0]smartconnect_0_M00_AXI_AWADDR;
  wire [1:0]smartconnect_0_M00_AXI_AWBURST;
  wire [3:0]smartconnect_0_M00_AXI_AWCACHE;
  wire [7:0]smartconnect_0_M00_AXI_AWLEN;
  wire [0:0]smartconnect_0_M00_AXI_AWLOCK;
  wire [2:0]smartconnect_0_M00_AXI_AWPROT;
  wire smartconnect_0_M00_AXI_AWREADY;
  wire [2:0]smartconnect_0_M00_AXI_AWSIZE;
  wire smartconnect_0_M00_AXI_AWVALID;
  wire smartconnect_0_M00_AXI_BREADY;
  wire [1:0]smartconnect_0_M00_AXI_BRESP;
  wire smartconnect_0_M00_AXI_BVALID;
  wire [511:0]smartconnect_0_M00_AXI_RDATA;
  wire smartconnect_0_M00_AXI_RLAST;
  wire smartconnect_0_M00_AXI_RREADY;
  wire [1:0]smartconnect_0_M00_AXI_RRESP;
  wire smartconnect_0_M00_AXI_RVALID;
  wire [511:0]smartconnect_0_M00_AXI_WDATA;
  wire smartconnect_0_M00_AXI_WLAST;
  wire smartconnect_0_M00_AXI_WREADY;
  wire [63:0]smartconnect_0_M00_AXI_WSTRB;
  wire smartconnect_0_M00_AXI_WVALID;
  wire [31:0]smartconnect_0_M01_AXI_ARADDR;
  wire [1:0]smartconnect_0_M01_AXI_ARBURST;
  wire [3:0]smartconnect_0_M01_AXI_ARCACHE;
  wire [7:0]smartconnect_0_M01_AXI_ARLEN;
  wire [0:0]smartconnect_0_M01_AXI_ARLOCK;
  wire [2:0]smartconnect_0_M01_AXI_ARPROT;
  wire [3:0]smartconnect_0_M01_AXI_ARQOS;
  wire smartconnect_0_M01_AXI_ARREADY;
  wire [2:0]smartconnect_0_M01_AXI_ARSIZE;
  wire [0:0]smartconnect_0_M01_AXI_ARUSER;
  wire smartconnect_0_M01_AXI_ARVALID;
  wire [31:0]smartconnect_0_M01_AXI_AWADDR;
  wire [1:0]smartconnect_0_M01_AXI_AWBURST;
  wire [3:0]smartconnect_0_M01_AXI_AWCACHE;
  wire [7:0]smartconnect_0_M01_AXI_AWLEN;
  wire [0:0]smartconnect_0_M01_AXI_AWLOCK;
  wire [2:0]smartconnect_0_M01_AXI_AWPROT;
  wire [3:0]smartconnect_0_M01_AXI_AWQOS;
  wire smartconnect_0_M01_AXI_AWREADY;
  wire [2:0]smartconnect_0_M01_AXI_AWSIZE;
  wire [0:0]smartconnect_0_M01_AXI_AWUSER;
  wire smartconnect_0_M01_AXI_AWVALID;
  wire smartconnect_0_M01_AXI_BREADY;
  wire [1:0]smartconnect_0_M01_AXI_BRESP;
  wire [0:0]smartconnect_0_M01_AXI_BUSER;
  wire smartconnect_0_M01_AXI_BVALID;
  wire [511:0]smartconnect_0_M01_AXI_RDATA;
  wire smartconnect_0_M01_AXI_RLAST;
  wire smartconnect_0_M01_AXI_RREADY;
  wire [1:0]smartconnect_0_M01_AXI_RRESP;
  wire smartconnect_0_M01_AXI_RVALID;
  wire [511:0]smartconnect_0_M01_AXI_WDATA;
  wire smartconnect_0_M01_AXI_WLAST;
  wire smartconnect_0_M01_AXI_WREADY;
  wire [63:0]smartconnect_0_M01_AXI_WSTRB;
  wire smartconnect_0_M01_AXI_WVALID;
  wire [0:0]util_ds_buf_0_IBUF_OUT;
  wire [63:0]xdma_0_M_AXI_ARADDR;
  wire [1:0]xdma_0_M_AXI_ARBURST;
  wire [3:0]xdma_0_M_AXI_ARCACHE;
  wire [3:0]xdma_0_M_AXI_ARID;
  wire [7:0]xdma_0_M_AXI_ARLEN;
  wire xdma_0_M_AXI_ARLOCK;
  wire [2:0]xdma_0_M_AXI_ARPROT;
  wire xdma_0_M_AXI_ARREADY;
  wire [2:0]xdma_0_M_AXI_ARSIZE;
  wire xdma_0_M_AXI_ARVALID;
  wire [63:0]xdma_0_M_AXI_AWADDR;
  wire [1:0]xdma_0_M_AXI_AWBURST;
  wire [3:0]xdma_0_M_AXI_AWCACHE;
  wire [3:0]xdma_0_M_AXI_AWID;
  wire [7:0]xdma_0_M_AXI_AWLEN;
  wire xdma_0_M_AXI_AWLOCK;
  wire [2:0]xdma_0_M_AXI_AWPROT;
  wire xdma_0_M_AXI_AWREADY;
  wire [2:0]xdma_0_M_AXI_AWSIZE;
  wire xdma_0_M_AXI_AWVALID;
  wire [3:0]xdma_0_M_AXI_BID;
  wire xdma_0_M_AXI_BREADY;
  wire [1:0]xdma_0_M_AXI_BRESP;
  wire xdma_0_M_AXI_BVALID;
  wire [127:0]xdma_0_M_AXI_RDATA;
  wire [3:0]xdma_0_M_AXI_RID;
  wire xdma_0_M_AXI_RLAST;
  wire xdma_0_M_AXI_RREADY;
  wire [1:0]xdma_0_M_AXI_RRESP;
  wire xdma_0_M_AXI_RVALID;
  wire [127:0]xdma_0_M_AXI_WDATA;
  wire xdma_0_M_AXI_WLAST;
  wire xdma_0_M_AXI_WREADY;
  wire [15:0]xdma_0_M_AXI_WSTRB;
  wire xdma_0_M_AXI_WVALID;
  wire xdma_0_axi_aclk;
  wire xdma_0_axi_aresetn;
  wire [7:0]xdma_0_pcie_mgt_rxn;
  wire [7:0]xdma_0_pcie_mgt_rxp;
  wire [7:0]xdma_0_pcie_mgt_txn;
  wire [7:0]xdma_0_pcie_mgt_txp;

  assign CLK_IN_D_0_1_CLK_N = pcie_ref_clk_n[0];
  assign CLK_IN_D_0_1_CLK_P = pcie_ref_clk_p[0];
  assign pcie_7x_mgt_rtl_txn[7:0] = xdma_0_pcie_mgt_txn;
  assign pcie_7x_mgt_rtl_txp[7:0] = xdma_0_pcie_mgt_txp;
  assign reset_rtl_1 = sys_rst;
  assign xdma_0_pcie_mgt_rxn = pcie_7x_mgt_rtl_rxn[7:0];
  assign xdma_0_pcie_mgt_rxp = pcie_7x_mgt_rtl_rxp[7:0];
  design_1_axi_bram_ctrl_0_2 axi_bram_ctrl_1
       (.bram_addr_a(axi_bram_ctrl_1_BRAM_PORTA_ADDR),
        .bram_addr_b(axi_bram_ctrl_1_BRAM_PORTB_ADDR),
        .bram_clk_a(axi_bram_ctrl_1_BRAM_PORTA_CLK),
        .bram_clk_b(axi_bram_ctrl_1_BRAM_PORTB_CLK),
        .bram_en_a(axi_bram_ctrl_1_BRAM_PORTA_EN),
        .bram_en_b(axi_bram_ctrl_1_BRAM_PORTB_EN),
        .bram_rddata_a(axi_bram_ctrl_1_BRAM_PORTA_DOUT),
        .bram_rddata_b(axi_bram_ctrl_1_BRAM_PORTB_DOUT),
        .bram_rst_a(axi_bram_ctrl_1_BRAM_PORTA_RST),
        .bram_rst_b(axi_bram_ctrl_1_BRAM_PORTB_RST),
        .bram_we_a(axi_bram_ctrl_1_BRAM_PORTA_WE),
        .bram_we_b(axi_bram_ctrl_1_BRAM_PORTB_WE),
        .bram_wrdata_a(axi_bram_ctrl_1_BRAM_PORTA_DIN),
        .bram_wrdata_b(axi_bram_ctrl_1_BRAM_PORTB_DIN),
        .s_axi_aclk(xdma_0_axi_aclk),
        .s_axi_araddr(smartconnect_0_M00_AXI_ARADDR),
        .s_axi_arburst(smartconnect_0_M00_AXI_ARBURST),
        .s_axi_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .s_axi_aresetn(xdma_0_axi_aresetn),
        .s_axi_arlen(smartconnect_0_M00_AXI_ARLEN),
        .s_axi_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .s_axi_arprot(smartconnect_0_M00_AXI_ARPROT),
        .s_axi_arready(smartconnect_0_M00_AXI_ARREADY),
        .s_axi_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .s_axi_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .s_axi_awburst(smartconnect_0_M00_AXI_AWBURST),
        .s_axi_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .s_axi_awlen(smartconnect_0_M00_AXI_AWLEN),
        .s_axi_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .s_axi_awprot(smartconnect_0_M00_AXI_AWPROT),
        .s_axi_awready(smartconnect_0_M00_AXI_AWREADY),
        .s_axi_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .s_axi_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .s_axi_bready(smartconnect_0_M00_AXI_BREADY),
        .s_axi_bresp(smartconnect_0_M00_AXI_BRESP),
        .s_axi_bvalid(smartconnect_0_M00_AXI_BVALID),
        .s_axi_rdata(smartconnect_0_M00_AXI_RDATA),
        .s_axi_rlast(smartconnect_0_M00_AXI_RLAST),
        .s_axi_rready(smartconnect_0_M00_AXI_RREADY),
        .s_axi_rresp(smartconnect_0_M00_AXI_RRESP),
        .s_axi_rvalid(smartconnect_0_M00_AXI_RVALID),
        .s_axi_wdata(smartconnect_0_M00_AXI_WDATA),
        .s_axi_wlast(smartconnect_0_M00_AXI_WLAST),
        .s_axi_wready(smartconnect_0_M00_AXI_WREADY),
        .s_axi_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .s_axi_wvalid(smartconnect_0_M00_AXI_WVALID));
  design_1_blk_mem_gen_0_1 blk_mem_gen_1
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_bram_ctrl_1_BRAM_PORTA_ADDR}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,axi_bram_ctrl_1_BRAM_PORTB_ADDR}),
        .clka(axi_bram_ctrl_1_BRAM_PORTA_CLK),
        .clkb(axi_bram_ctrl_1_BRAM_PORTB_CLK),
        .dina(axi_bram_ctrl_1_BRAM_PORTA_DIN),
        .dinb(axi_bram_ctrl_1_BRAM_PORTB_DIN),
        .douta(axi_bram_ctrl_1_BRAM_PORTA_DOUT),
        .doutb(axi_bram_ctrl_1_BRAM_PORTB_DOUT),
        .ena(axi_bram_ctrl_1_BRAM_PORTA_EN),
        .enb(axi_bram_ctrl_1_BRAM_PORTB_EN),
        .rsta(axi_bram_ctrl_1_BRAM_PORTA_RST),
        .rstb(axi_bram_ctrl_1_BRAM_PORTB_RST),
        .wea(axi_bram_ctrl_1_BRAM_PORTA_WE),
        .web(axi_bram_ctrl_1_BRAM_PORTB_WE));
  design_1_pci_mig_accelerator_0_0 pci_mig_accelerator_0
       (.m00_axi_aclk(xdma_0_axi_aclk),
        .m00_axi_araddr(pci_mig_accelerator_0_m00_axi_ARADDR),
        .m00_axi_arburst(pci_mig_accelerator_0_m00_axi_ARBURST),
        .m00_axi_arcache(pci_mig_accelerator_0_m00_axi_ARCACHE),
        .m00_axi_aresetn(xdma_0_axi_aresetn),
        .m00_axi_arid(pci_mig_accelerator_0_m00_axi_ARID),
        .m00_axi_arlen(pci_mig_accelerator_0_m00_axi_ARLEN),
        .m00_axi_arlock(pci_mig_accelerator_0_m00_axi_ARLOCK),
        .m00_axi_arprot(pci_mig_accelerator_0_m00_axi_ARPROT),
        .m00_axi_arqos(pci_mig_accelerator_0_m00_axi_ARQOS),
        .m00_axi_arready(pci_mig_accelerator_0_m00_axi_ARREADY),
        .m00_axi_arsize(pci_mig_accelerator_0_m00_axi_ARSIZE),
        .m00_axi_aruser(pci_mig_accelerator_0_m00_axi_ARUSER),
        .m00_axi_arvalid(pci_mig_accelerator_0_m00_axi_ARVALID),
        .m00_axi_awaddr(pci_mig_accelerator_0_m00_axi_AWADDR),
        .m00_axi_awburst(pci_mig_accelerator_0_m00_axi_AWBURST),
        .m00_axi_awcache(pci_mig_accelerator_0_m00_axi_AWCACHE),
        .m00_axi_awid(pci_mig_accelerator_0_m00_axi_AWID),
        .m00_axi_awlen(pci_mig_accelerator_0_m00_axi_AWLEN),
        .m00_axi_awlock(pci_mig_accelerator_0_m00_axi_AWLOCK),
        .m00_axi_awprot(pci_mig_accelerator_0_m00_axi_AWPROT),
        .m00_axi_awqos(pci_mig_accelerator_0_m00_axi_AWQOS),
        .m00_axi_awready(pci_mig_accelerator_0_m00_axi_AWREADY),
        .m00_axi_awsize(pci_mig_accelerator_0_m00_axi_AWSIZE),
        .m00_axi_awuser(pci_mig_accelerator_0_m00_axi_AWUSER),
        .m00_axi_awvalid(pci_mig_accelerator_0_m00_axi_AWVALID),
        .m00_axi_bid(pci_mig_accelerator_0_m00_axi_BID),
        .m00_axi_bready(pci_mig_accelerator_0_m00_axi_BREADY),
        .m00_axi_bresp(pci_mig_accelerator_0_m00_axi_BRESP),
        .m00_axi_buser(pci_mig_accelerator_0_m00_axi_BUSER),
        .m00_axi_bvalid(pci_mig_accelerator_0_m00_axi_BVALID),
        .m00_axi_rdata(pci_mig_accelerator_0_m00_axi_RDATA),
        .m00_axi_rid(pci_mig_accelerator_0_m00_axi_RID),
        .m00_axi_rlast(pci_mig_accelerator_0_m00_axi_RLAST),
        .m00_axi_rready(pci_mig_accelerator_0_m00_axi_RREADY),
        .m00_axi_rresp(pci_mig_accelerator_0_m00_axi_RRESP),
        .m00_axi_ruser(1'b0),
        .m00_axi_rvalid(pci_mig_accelerator_0_m00_axi_RVALID),
        .m00_axi_wdata(pci_mig_accelerator_0_m00_axi_WDATA),
        .m00_axi_wlast(pci_mig_accelerator_0_m00_axi_WLAST),
        .m00_axi_wready(pci_mig_accelerator_0_m00_axi_WREADY),
        .m00_axi_wstrb(pci_mig_accelerator_0_m00_axi_WSTRB),
        .m00_axi_wvalid(pci_mig_accelerator_0_m00_axi_WVALID),
        .s00_axi_aclk(xdma_0_axi_aclk),
        .s00_axi_araddr(smartconnect_0_M01_AXI_ARADDR),
        .s00_axi_arburst(smartconnect_0_M01_AXI_ARBURST),
        .s00_axi_arcache(smartconnect_0_M01_AXI_ARCACHE),
        .s00_axi_aresetn(xdma_0_axi_aresetn),
        .s00_axi_arid(1'b0),
        .s00_axi_arlen(smartconnect_0_M01_AXI_ARLEN),
        .s00_axi_arlock(smartconnect_0_M01_AXI_ARLOCK),
        .s00_axi_arprot(smartconnect_0_M01_AXI_ARPROT),
        .s00_axi_arqos(smartconnect_0_M01_AXI_ARQOS),
        .s00_axi_arready(smartconnect_0_M01_AXI_ARREADY),
        .s00_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s00_axi_arsize(smartconnect_0_M01_AXI_ARSIZE),
        .s00_axi_aruser(smartconnect_0_M01_AXI_ARUSER),
        .s00_axi_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .s00_axi_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .s00_axi_awburst(smartconnect_0_M01_AXI_AWBURST),
        .s00_axi_awcache(smartconnect_0_M01_AXI_AWCACHE),
        .s00_axi_awid(1'b0),
        .s00_axi_awlen(smartconnect_0_M01_AXI_AWLEN),
        .s00_axi_awlock(smartconnect_0_M01_AXI_AWLOCK),
        .s00_axi_awprot(smartconnect_0_M01_AXI_AWPROT),
        .s00_axi_awqos(smartconnect_0_M01_AXI_AWQOS),
        .s00_axi_awready(smartconnect_0_M01_AXI_AWREADY),
        .s00_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s00_axi_awsize(smartconnect_0_M01_AXI_AWSIZE),
        .s00_axi_awuser(smartconnect_0_M01_AXI_AWUSER),
        .s00_axi_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .s00_axi_bready(smartconnect_0_M01_AXI_BREADY),
        .s00_axi_bresp(smartconnect_0_M01_AXI_BRESP),
        .s00_axi_buser(smartconnect_0_M01_AXI_BUSER),
        .s00_axi_bvalid(smartconnect_0_M01_AXI_BVALID),
        .s00_axi_rdata(smartconnect_0_M01_AXI_RDATA),
        .s00_axi_rlast(smartconnect_0_M01_AXI_RLAST),
        .s00_axi_rready(smartconnect_0_M01_AXI_RREADY),
        .s00_axi_rresp(smartconnect_0_M01_AXI_RRESP),
        .s00_axi_rvalid(smartconnect_0_M01_AXI_RVALID),
        .s00_axi_wdata(smartconnect_0_M01_AXI_WDATA),
        .s00_axi_wlast(smartconnect_0_M01_AXI_WLAST),
        .s00_axi_wready(smartconnect_0_M01_AXI_WREADY),
        .s00_axi_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .s00_axi_wuser(1'b0),
        .s00_axi_wvalid(smartconnect_0_M01_AXI_WVALID));
  design_1_smartconnect_0_0 smartconnect_0
       (.M00_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arburst(smartconnect_0_M00_AXI_ARBURST),
        .M00_AXI_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .M00_AXI_arlen(smartconnect_0_M00_AXI_ARLEN),
        .M00_AXI_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .M00_AXI_arprot(smartconnect_0_M00_AXI_ARPROT),
        .M00_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awburst(smartconnect_0_M00_AXI_AWBURST),
        .M00_AXI_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .M00_AXI_awlen(smartconnect_0_M00_AXI_AWLEN),
        .M00_AXI_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .M00_AXI_awprot(smartconnect_0_M00_AXI_AWPROT),
        .M00_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .M00_AXI_bready(smartconnect_0_M00_AXI_BREADY),
        .M00_AXI_bresp(smartconnect_0_M00_AXI_BRESP),
        .M00_AXI_buser(1'b0),
        .M00_AXI_bvalid(smartconnect_0_M00_AXI_BVALID),
        .M00_AXI_rdata(smartconnect_0_M00_AXI_RDATA),
        .M00_AXI_rlast(smartconnect_0_M00_AXI_RLAST),
        .M00_AXI_rready(smartconnect_0_M00_AXI_RREADY),
        .M00_AXI_rresp(smartconnect_0_M00_AXI_RRESP),
        .M00_AXI_rvalid(smartconnect_0_M00_AXI_RVALID),
        .M00_AXI_wdata(smartconnect_0_M00_AXI_WDATA),
        .M00_AXI_wlast(smartconnect_0_M00_AXI_WLAST),
        .M00_AXI_wready(smartconnect_0_M00_AXI_WREADY),
        .M00_AXI_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(smartconnect_0_M00_AXI_WVALID),
        .M01_AXI_araddr(smartconnect_0_M01_AXI_ARADDR),
        .M01_AXI_arburst(smartconnect_0_M01_AXI_ARBURST),
        .M01_AXI_arcache(smartconnect_0_M01_AXI_ARCACHE),
        .M01_AXI_arlen(smartconnect_0_M01_AXI_ARLEN),
        .M01_AXI_arlock(smartconnect_0_M01_AXI_ARLOCK),
        .M01_AXI_arprot(smartconnect_0_M01_AXI_ARPROT),
        .M01_AXI_arqos(smartconnect_0_M01_AXI_ARQOS),
        .M01_AXI_arready(smartconnect_0_M01_AXI_ARREADY),
        .M01_AXI_arsize(smartconnect_0_M01_AXI_ARSIZE),
        .M01_AXI_aruser(smartconnect_0_M01_AXI_ARUSER),
        .M01_AXI_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .M01_AXI_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .M01_AXI_awburst(smartconnect_0_M01_AXI_AWBURST),
        .M01_AXI_awcache(smartconnect_0_M01_AXI_AWCACHE),
        .M01_AXI_awlen(smartconnect_0_M01_AXI_AWLEN),
        .M01_AXI_awlock(smartconnect_0_M01_AXI_AWLOCK),
        .M01_AXI_awprot(smartconnect_0_M01_AXI_AWPROT),
        .M01_AXI_awqos(smartconnect_0_M01_AXI_AWQOS),
        .M01_AXI_awready(smartconnect_0_M01_AXI_AWREADY),
        .M01_AXI_awsize(smartconnect_0_M01_AXI_AWSIZE),
        .M01_AXI_awuser(smartconnect_0_M01_AXI_AWUSER),
        .M01_AXI_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .M01_AXI_bready(smartconnect_0_M01_AXI_BREADY),
        .M01_AXI_bresp(smartconnect_0_M01_AXI_BRESP),
        .M01_AXI_buser(smartconnect_0_M01_AXI_BUSER),
        .M01_AXI_bvalid(smartconnect_0_M01_AXI_BVALID),
        .M01_AXI_rdata(smartconnect_0_M01_AXI_RDATA),
        .M01_AXI_rlast(smartconnect_0_M01_AXI_RLAST),
        .M01_AXI_rready(smartconnect_0_M01_AXI_RREADY),
        .M01_AXI_rresp(smartconnect_0_M01_AXI_RRESP),
        .M01_AXI_rvalid(smartconnect_0_M01_AXI_RVALID),
        .M01_AXI_wdata(smartconnect_0_M01_AXI_WDATA),
        .M01_AXI_wlast(smartconnect_0_M01_AXI_WLAST),
        .M01_AXI_wready(smartconnect_0_M01_AXI_WREADY),
        .M01_AXI_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .M01_AXI_wvalid(smartconnect_0_M01_AXI_WVALID),
        .S00_AXI_araddr(xdma_0_M_AXI_ARADDR),
        .S00_AXI_arburst(xdma_0_M_AXI_ARBURST),
        .S00_AXI_arcache(xdma_0_M_AXI_ARCACHE),
        .S00_AXI_arid(xdma_0_M_AXI_ARID),
        .S00_AXI_arlen(xdma_0_M_AXI_ARLEN),
        .S00_AXI_arlock(xdma_0_M_AXI_ARLOCK),
        .S00_AXI_arprot(xdma_0_M_AXI_ARPROT),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(xdma_0_M_AXI_ARREADY),
        .S00_AXI_arsize(xdma_0_M_AXI_ARSIZE),
        .S00_AXI_arvalid(xdma_0_M_AXI_ARVALID),
        .S00_AXI_awaddr(xdma_0_M_AXI_AWADDR),
        .S00_AXI_awburst(xdma_0_M_AXI_AWBURST),
        .S00_AXI_awcache(xdma_0_M_AXI_AWCACHE),
        .S00_AXI_awid(xdma_0_M_AXI_AWID),
        .S00_AXI_awlen(xdma_0_M_AXI_AWLEN),
        .S00_AXI_awlock(xdma_0_M_AXI_AWLOCK),
        .S00_AXI_awprot(xdma_0_M_AXI_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(xdma_0_M_AXI_AWREADY),
        .S00_AXI_awsize(xdma_0_M_AXI_AWSIZE),
        .S00_AXI_awvalid(xdma_0_M_AXI_AWVALID),
        .S00_AXI_bid(xdma_0_M_AXI_BID),
        .S00_AXI_bready(xdma_0_M_AXI_BREADY),
        .S00_AXI_bresp(xdma_0_M_AXI_BRESP),
        .S00_AXI_bvalid(xdma_0_M_AXI_BVALID),
        .S00_AXI_rdata(xdma_0_M_AXI_RDATA),
        .S00_AXI_rid(xdma_0_M_AXI_RID),
        .S00_AXI_rlast(xdma_0_M_AXI_RLAST),
        .S00_AXI_rready(xdma_0_M_AXI_RREADY),
        .S00_AXI_rresp(xdma_0_M_AXI_RRESP),
        .S00_AXI_rvalid(xdma_0_M_AXI_RVALID),
        .S00_AXI_wdata(xdma_0_M_AXI_WDATA),
        .S00_AXI_wlast(xdma_0_M_AXI_WLAST),
        .S00_AXI_wready(xdma_0_M_AXI_WREADY),
        .S00_AXI_wstrb(xdma_0_M_AXI_WSTRB),
        .S00_AXI_wvalid(xdma_0_M_AXI_WVALID),
        .S01_AXI_araddr(pci_mig_accelerator_0_m00_axi_ARADDR),
        .S01_AXI_arburst(pci_mig_accelerator_0_m00_axi_ARBURST),
        .S01_AXI_arcache(pci_mig_accelerator_0_m00_axi_ARCACHE),
        .S01_AXI_arid(pci_mig_accelerator_0_m00_axi_ARID),
        .S01_AXI_arlen(pci_mig_accelerator_0_m00_axi_ARLEN),
        .S01_AXI_arlock(pci_mig_accelerator_0_m00_axi_ARLOCK),
        .S01_AXI_arprot(pci_mig_accelerator_0_m00_axi_ARPROT),
        .S01_AXI_arqos(pci_mig_accelerator_0_m00_axi_ARQOS),
        .S01_AXI_arready(pci_mig_accelerator_0_m00_axi_ARREADY),
        .S01_AXI_arsize(pci_mig_accelerator_0_m00_axi_ARSIZE),
        .S01_AXI_aruser(pci_mig_accelerator_0_m00_axi_ARUSER),
        .S01_AXI_arvalid(pci_mig_accelerator_0_m00_axi_ARVALID),
        .S01_AXI_awaddr(pci_mig_accelerator_0_m00_axi_AWADDR),
        .S01_AXI_awburst(pci_mig_accelerator_0_m00_axi_AWBURST),
        .S01_AXI_awcache(pci_mig_accelerator_0_m00_axi_AWCACHE),
        .S01_AXI_awid(pci_mig_accelerator_0_m00_axi_AWID),
        .S01_AXI_awlen(pci_mig_accelerator_0_m00_axi_AWLEN),
        .S01_AXI_awlock(pci_mig_accelerator_0_m00_axi_AWLOCK),
        .S01_AXI_awprot(pci_mig_accelerator_0_m00_axi_AWPROT),
        .S01_AXI_awqos(pci_mig_accelerator_0_m00_axi_AWQOS),
        .S01_AXI_awready(pci_mig_accelerator_0_m00_axi_AWREADY),
        .S01_AXI_awsize(pci_mig_accelerator_0_m00_axi_AWSIZE),
        .S01_AXI_awuser(pci_mig_accelerator_0_m00_axi_AWUSER),
        .S01_AXI_awvalid(pci_mig_accelerator_0_m00_axi_AWVALID),
        .S01_AXI_bid(pci_mig_accelerator_0_m00_axi_BID),
        .S01_AXI_bready(pci_mig_accelerator_0_m00_axi_BREADY),
        .S01_AXI_bresp(pci_mig_accelerator_0_m00_axi_BRESP),
        .S01_AXI_buser(pci_mig_accelerator_0_m00_axi_BUSER),
        .S01_AXI_bvalid(pci_mig_accelerator_0_m00_axi_BVALID),
        .S01_AXI_rdata(pci_mig_accelerator_0_m00_axi_RDATA),
        .S01_AXI_rid(pci_mig_accelerator_0_m00_axi_RID),
        .S01_AXI_rlast(pci_mig_accelerator_0_m00_axi_RLAST),
        .S01_AXI_rready(pci_mig_accelerator_0_m00_axi_RREADY),
        .S01_AXI_rresp(pci_mig_accelerator_0_m00_axi_RRESP),
        .S01_AXI_rvalid(pci_mig_accelerator_0_m00_axi_RVALID),
        .S01_AXI_wdata(pci_mig_accelerator_0_m00_axi_WDATA),
        .S01_AXI_wlast(pci_mig_accelerator_0_m00_axi_WLAST),
        .S01_AXI_wready(pci_mig_accelerator_0_m00_axi_WREADY),
        .S01_AXI_wstrb(pci_mig_accelerator_0_m00_axi_WSTRB),
        .S01_AXI_wvalid(pci_mig_accelerator_0_m00_axi_WVALID),
        .aclk(xdma_0_axi_aclk),
        .aresetn(xdma_0_axi_aresetn));
  design_1_util_ds_buf_0_0 util_ds_buf_0
       (.IBUF_DS_N(CLK_IN_D_0_1_CLK_N),
        .IBUF_DS_P(CLK_IN_D_0_1_CLK_P),
        .IBUF_OUT(util_ds_buf_0_IBUF_OUT));
  design_1_xdma_0_0 xdma_0
       (.axi_aclk(xdma_0_axi_aclk),
        .axi_aresetn(xdma_0_axi_aresetn),
        .cfg_mgmt_addr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .cfg_mgmt_byte_enable({1'b0,1'b0,1'b0,1'b0}),
        .cfg_mgmt_read(1'b0),
        .cfg_mgmt_type1_cfg_reg_access(1'b0),
        .cfg_mgmt_write(1'b0),
        .cfg_mgmt_write_data({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_araddr(xdma_0_M_AXI_ARADDR),
        .m_axi_arburst(xdma_0_M_AXI_ARBURST),
        .m_axi_arcache(xdma_0_M_AXI_ARCACHE),
        .m_axi_arid(xdma_0_M_AXI_ARID),
        .m_axi_arlen(xdma_0_M_AXI_ARLEN),
        .m_axi_arlock(xdma_0_M_AXI_ARLOCK),
        .m_axi_arprot(xdma_0_M_AXI_ARPROT),
        .m_axi_arready(xdma_0_M_AXI_ARREADY),
        .m_axi_arsize(xdma_0_M_AXI_ARSIZE),
        .m_axi_arvalid(xdma_0_M_AXI_ARVALID),
        .m_axi_awaddr(xdma_0_M_AXI_AWADDR),
        .m_axi_awburst(xdma_0_M_AXI_AWBURST),
        .m_axi_awcache(xdma_0_M_AXI_AWCACHE),
        .m_axi_awid(xdma_0_M_AXI_AWID),
        .m_axi_awlen(xdma_0_M_AXI_AWLEN),
        .m_axi_awlock(xdma_0_M_AXI_AWLOCK),
        .m_axi_awprot(xdma_0_M_AXI_AWPROT),
        .m_axi_awready(xdma_0_M_AXI_AWREADY),
        .m_axi_awsize(xdma_0_M_AXI_AWSIZE),
        .m_axi_awvalid(xdma_0_M_AXI_AWVALID),
        .m_axi_bid(xdma_0_M_AXI_BID),
        .m_axi_bready(xdma_0_M_AXI_BREADY),
        .m_axi_bresp(xdma_0_M_AXI_BRESP),
        .m_axi_bvalid(xdma_0_M_AXI_BVALID),
        .m_axi_rdata(xdma_0_M_AXI_RDATA),
        .m_axi_rid(xdma_0_M_AXI_RID),
        .m_axi_rlast(xdma_0_M_AXI_RLAST),
        .m_axi_rready(xdma_0_M_AXI_RREADY),
        .m_axi_rresp(xdma_0_M_AXI_RRESP),
        .m_axi_rvalid(xdma_0_M_AXI_RVALID),
        .m_axi_wdata(xdma_0_M_AXI_WDATA),
        .m_axi_wlast(xdma_0_M_AXI_WLAST),
        .m_axi_wready(xdma_0_M_AXI_WREADY),
        .m_axi_wstrb(xdma_0_M_AXI_WSTRB),
        .m_axi_wvalid(xdma_0_M_AXI_WVALID),
        .pci_exp_rxn(xdma_0_pcie_mgt_rxn),
        .pci_exp_rxp(xdma_0_pcie_mgt_rxp),
        .pci_exp_txn(xdma_0_pcie_mgt_txn),
        .pci_exp_txp(xdma_0_pcie_mgt_txp),
        .sys_clk(util_ds_buf_0_IBUF_OUT),
        .sys_rst_n(reset_rtl_1),
        .usr_irq_req(1'b0));
endmodule
