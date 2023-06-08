//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Tue Apr 18 20:01:39 2023
//Host        : the-cow running 64-bit Ubuntu 22.04.2 LTS
//Command     : generate_target pci_mig.bd
//Design      : pci_mig
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "pci_mig,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=pci_mig,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=8,numReposBlks=8,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=7,da_board_cnt=3,da_clkrst_cnt=15,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "pci_mig.hwdef" *) 
module pci_mig
   (ddr3_sdram_addr,
    ddr3_sdram_ba,
    ddr3_sdram_cas_n,
    ddr3_sdram_ck_n,
    ddr3_sdram_ck_p,
    ddr3_sdram_cke,
    ddr3_sdram_cs_n,
    ddr3_sdram_dm,
    ddr3_sdram_dq,
    ddr3_sdram_dqs_n,
    ddr3_sdram_dqs_p,
    ddr3_sdram_odt,
    ddr3_sdram_ras_n,
    ddr3_sdram_reset_n,
    ddr3_sdram_we_n,
    pcie_7x_mgt_rtl_rxn,
    pcie_7x_mgt_rtl_rxp,
    pcie_7x_mgt_rtl_txn,
    pcie_7x_mgt_rtl_txp,
    pcie_ref_clk_n,
    pcie_ref_clk_p,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p,
    sys_rst);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram ADDR" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ddr3_sdram, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) output [15:0]ddr3_sdram_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram BA" *) output [2:0]ddr3_sdram_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram CAS_N" *) output ddr3_sdram_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram CK_N" *) output [1:0]ddr3_sdram_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram CK_P" *) output [1:0]ddr3_sdram_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram CKE" *) output [1:0]ddr3_sdram_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram CS_N" *) output [1:0]ddr3_sdram_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram DM" *) output [7:0]ddr3_sdram_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram DQ" *) inout [63:0]ddr3_sdram_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram DQS_N" *) inout [7:0]ddr3_sdram_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram DQS_P" *) inout [7:0]ddr3_sdram_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram ODT" *) output [1:0]ddr3_sdram_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram RAS_N" *) output ddr3_sdram_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram RESET_N" *) output ddr3_sdram_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 ddr3_sdram WE_N" *) output ddr3_sdram_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl rxn" *) input [7:0]pcie_7x_mgt_rtl_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl rxp" *) input [7:0]pcie_7x_mgt_rtl_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl txn" *) output [7:0]pcie_7x_mgt_rtl_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_7x_mgt_rtl txp" *) output [7:0]pcie_7x_mgt_rtl_txp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_ref CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pcie_ref, CAN_DEBUG false, FREQ_HZ 100000000" *) input [0:0]pcie_ref_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_ref CLK_P" *) input [0:0]pcie_ref_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 sys_diff_clock CLK_N" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME sys_diff_clock, CAN_DEBUG false, FREQ_HZ 100000000" *) input sys_diff_clock_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 sys_diff_clock CLK_P" *) input sys_diff_clock_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYS_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYS_RST, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input sys_rst;

  wire [0:0]CLK_IN_D_0_1_CLK_N;
  wire [0:0]CLK_IN_D_0_1_CLK_P;
  wire [15:0]mig_7series_0_DDR3_ADDR;
  wire [2:0]mig_7series_0_DDR3_BA;
  wire mig_7series_0_DDR3_CAS_N;
  wire [1:0]mig_7series_0_DDR3_CKE;
  wire [1:0]mig_7series_0_DDR3_CK_N;
  wire [1:0]mig_7series_0_DDR3_CK_P;
  wire [1:0]mig_7series_0_DDR3_CS_N;
  wire [7:0]mig_7series_0_DDR3_DM;
  wire [63:0]mig_7series_0_DDR3_DQ;
  wire [7:0]mig_7series_0_DDR3_DQS_N;
  wire [7:0]mig_7series_0_DDR3_DQS_P;
  wire [1:0]mig_7series_0_DDR3_ODT;
  wire mig_7series_0_DDR3_RAS_N;
  wire mig_7series_0_DDR3_RESET_N;
  wire mig_7series_0_DDR3_WE_N;
  wire mig_7series_0_mmcm_locked;
  wire mig_7series_0_ui_clk;
  wire mig_7series_0_ui_clk_sync_rst;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARADDR" *) (* DONT_TOUCH *) wire [32:0]pci_mig_accelerator_0_M00_AXI_ARADDR;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARBURST" *) (* DONT_TOUCH *) wire [1:0]pci_mig_accelerator_0_M00_AXI_ARBURST;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARCACHE" *) (* DONT_TOUCH *) wire [3:0]pci_mig_accelerator_0_M00_AXI_ARCACHE;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARID" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_ARID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLEN" *) (* DONT_TOUCH *) wire [7:0]pci_mig_accelerator_0_M00_AXI_ARLEN;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLOCK" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_ARLOCK;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARPROT" *) (* DONT_TOUCH *) wire [2:0]pci_mig_accelerator_0_M00_AXI_ARPROT;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARQOS" *) (* DONT_TOUCH *) wire [3:0]pci_mig_accelerator_0_M00_AXI_ARQOS;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARREADY" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_ARREADY;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARSIZE" *) (* DONT_TOUCH *) wire [2:0]pci_mig_accelerator_0_M00_AXI_ARSIZE;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARUSER" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_ARUSER;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARVALID" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_ARVALID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWADDR" *) (* DONT_TOUCH *) wire [32:0]pci_mig_accelerator_0_M00_AXI_AWADDR;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWBURST" *) (* DONT_TOUCH *) wire [1:0]pci_mig_accelerator_0_M00_AXI_AWBURST;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWCACHE" *) (* DONT_TOUCH *) wire [3:0]pci_mig_accelerator_0_M00_AXI_AWCACHE;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWID" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_AWID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLEN" *) (* DONT_TOUCH *) wire [7:0]pci_mig_accelerator_0_M00_AXI_AWLEN;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLOCK" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_AWLOCK;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWPROT" *) (* DONT_TOUCH *) wire [2:0]pci_mig_accelerator_0_M00_AXI_AWPROT;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWQOS" *) (* DONT_TOUCH *) wire [3:0]pci_mig_accelerator_0_M00_AXI_AWQOS;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWREADY" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_AWREADY;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWSIZE" *) (* DONT_TOUCH *) wire [2:0]pci_mig_accelerator_0_M00_AXI_AWSIZE;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWUSER" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_AWUSER;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWVALID" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_AWVALID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BID" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_BID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BREADY" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_BREADY;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BRESP" *) (* DONT_TOUCH *) wire [1:0]pci_mig_accelerator_0_M00_AXI_BRESP;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BUSER" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_BUSER;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BVALID" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_BVALID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RDATA" *) (* DONT_TOUCH *) wire [511:0]pci_mig_accelerator_0_M00_AXI_RDATA;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RID" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_RID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RLAST" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_RLAST;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RREADY" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_RREADY;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RRESP" *) (* DONT_TOUCH *) wire [1:0]pci_mig_accelerator_0_M00_AXI_RRESP;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RVALID" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_RVALID;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WDATA" *) (* DONT_TOUCH *) wire [511:0]pci_mig_accelerator_0_M00_AXI_WDATA;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WLAST" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_WLAST;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WREADY" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_WREADY;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WSTRB" *) (* DONT_TOUCH *) wire [63:0]pci_mig_accelerator_0_M00_AXI_WSTRB;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WUSER" *) (* DONT_TOUCH *) wire [0:0]pci_mig_accelerator_0_M00_AXI_WUSER;
  (* CONN_BUS_INFO = "pci_mig_accelerator_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WVALID" *) (* DONT_TOUCH *) wire pci_mig_accelerator_0_M00_AXI_WVALID;
  wire reset_rtl_1;
  wire [0:0]rst_mig_7series_0_100M_peripheral_aresetn;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARADDR" *) (* DONT_TOUCH *) wire [32:0]smartconnect_0_M00_AXI_ARADDR;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARBURST" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M00_AXI_ARBURST;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARCACHE" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M00_AXI_ARCACHE;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLEN" *) (* DONT_TOUCH *) wire [7:0]smartconnect_0_M00_AXI_ARLEN;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLOCK" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M00_AXI_ARLOCK;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARPROT" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M00_AXI_ARPROT;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARQOS" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M00_AXI_ARQOS;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_ARREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARSIZE" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M00_AXI_ARSIZE;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARUSER" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M00_AXI_ARUSER;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 ARVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_ARVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWADDR" *) (* DONT_TOUCH *) wire [32:0]smartconnect_0_M00_AXI_AWADDR;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWBURST" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M00_AXI_AWBURST;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWCACHE" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M00_AXI_AWCACHE;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLEN" *) (* DONT_TOUCH *) wire [7:0]smartconnect_0_M00_AXI_AWLEN;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLOCK" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M00_AXI_AWLOCK;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWPROT" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M00_AXI_AWPROT;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWQOS" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M00_AXI_AWQOS;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_AWREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWSIZE" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M00_AXI_AWSIZE;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWUSER" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M00_AXI_AWUSER;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 AWVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_AWVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_BREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BRESP" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M00_AXI_BRESP;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 BVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_BVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RDATA" *) (* DONT_TOUCH *) wire [511:0]smartconnect_0_M00_AXI_RDATA;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RLAST" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_RLAST;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_RREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RRESP" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M00_AXI_RRESP;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 RVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_RVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WDATA" *) (* DONT_TOUCH *) wire [511:0]smartconnect_0_M00_AXI_WDATA;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WLAST" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_WLAST;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_WREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WSTRB" *) (* DONT_TOUCH *) wire [63:0]smartconnect_0_M00_AXI_WSTRB;
  (* CONN_BUS_INFO = "smartconnect_0_M00_AXI xilinx.com:interface:aximm:1.0 AXI4 WVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M00_AXI_WVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARADDR" *) (* DONT_TOUCH *) wire [31:0]smartconnect_0_M01_AXI_ARADDR;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARBURST" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M01_AXI_ARBURST;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARCACHE" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M01_AXI_ARCACHE;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLEN" *) (* DONT_TOUCH *) wire [7:0]smartconnect_0_M01_AXI_ARLEN;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLOCK" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M01_AXI_ARLOCK;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARPROT" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M01_AXI_ARPROT;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARQOS" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M01_AXI_ARQOS;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_ARREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARSIZE" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M01_AXI_ARSIZE;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARUSER" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M01_AXI_ARUSER;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 ARVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_ARVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWADDR" *) (* DONT_TOUCH *) wire [31:0]smartconnect_0_M01_AXI_AWADDR;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWBURST" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M01_AXI_AWBURST;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWCACHE" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M01_AXI_AWCACHE;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLEN" *) (* DONT_TOUCH *) wire [7:0]smartconnect_0_M01_AXI_AWLEN;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLOCK" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M01_AXI_AWLOCK;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWPROT" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M01_AXI_AWPROT;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWQOS" *) (* DONT_TOUCH *) wire [3:0]smartconnect_0_M01_AXI_AWQOS;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_AWREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWSIZE" *) (* DONT_TOUCH *) wire [2:0]smartconnect_0_M01_AXI_AWSIZE;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWUSER" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M01_AXI_AWUSER;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 AWVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_AWVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 BREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_BREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 BRESP" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M01_AXI_BRESP;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 BUSER" *) (* DONT_TOUCH *) wire [0:0]smartconnect_0_M01_AXI_BUSER;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 BVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_BVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 RDATA" *) (* DONT_TOUCH *) wire [511:0]smartconnect_0_M01_AXI_RDATA;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 RLAST" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_RLAST;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 RREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_RREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 RRESP" *) (* DONT_TOUCH *) wire [1:0]smartconnect_0_M01_AXI_RRESP;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 RVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_RVALID;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 WDATA" *) (* DONT_TOUCH *) wire [511:0]smartconnect_0_M01_AXI_WDATA;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 WLAST" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_WLAST;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 WREADY" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_WREADY;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 WSTRB" *) (* DONT_TOUCH *) wire [63:0]smartconnect_0_M01_AXI_WSTRB;
  (* CONN_BUS_INFO = "smartconnect_0_M01_AXI xilinx.com:interface:aximm:1.0 AXI4 WVALID" *) (* DONT_TOUCH *) wire smartconnect_0_M01_AXI_WVALID;
  wire sys_diff_clock_1_CLK_N;
  wire sys_diff_clock_1_CLK_P;
  wire [0:0]util_ds_buf_0_IBUF_OUT;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARADDR" *) (* DONT_TOUCH *) wire [63:0]xdma_0_M_AXI_ARADDR;
  wire [1:0]xdma_0_M_AXI_ARBURST;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARCACHE" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_ARCACHE;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARID" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_ARID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLEN" *) (* DONT_TOUCH *) wire [7:0]xdma_0_M_AXI_ARLEN;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARLOCK" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_ARLOCK;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARPROT" *) (* DONT_TOUCH *) wire [2:0]xdma_0_M_AXI_ARPROT;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARREADY" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_ARREADY;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARSIZE" *) (* DONT_TOUCH *) wire [2:0]xdma_0_M_AXI_ARSIZE;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 ARVALID" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_ARVALID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWADDR" *) (* DONT_TOUCH *) wire [63:0]xdma_0_M_AXI_AWADDR;
  wire [1:0]xdma_0_M_AXI_AWBURST;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWCACHE" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_AWCACHE;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWID" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_AWID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLEN" *) (* DONT_TOUCH *) wire [7:0]xdma_0_M_AXI_AWLEN;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWLOCK" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_AWLOCK;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWPROT" *) (* DONT_TOUCH *) wire [2:0]xdma_0_M_AXI_AWPROT;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWREADY" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_AWREADY;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWSIZE" *) (* DONT_TOUCH *) wire [2:0]xdma_0_M_AXI_AWSIZE;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 AWVALID" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_AWVALID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 BID" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_BID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 BREADY" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_BREADY;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 BRESP" *) (* DONT_TOUCH *) wire [1:0]xdma_0_M_AXI_BRESP;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 BVALID" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_BVALID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RDATA" *) (* DONT_TOUCH *) wire [127:0]xdma_0_M_AXI_RDATA;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RID" *) (* DONT_TOUCH *) wire [3:0]xdma_0_M_AXI_RID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RLAST" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_RLAST;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RREADY" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_RREADY;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RRESP" *) (* DONT_TOUCH *) wire [1:0]xdma_0_M_AXI_RRESP;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 RVALID" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_RVALID;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 WDATA" *) (* DONT_TOUCH *) wire [127:0]xdma_0_M_AXI_WDATA;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 WLAST" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_WLAST;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 WREADY" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_WREADY;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 WSTRB" *) (* DONT_TOUCH *) wire [15:0]xdma_0_M_AXI_WSTRB;
  (* CONN_BUS_INFO = "xdma_0_M_AXI xilinx.com:interface:aximm:1.0 AXI4 WVALID" *) (* DONT_TOUCH *) wire xdma_0_M_AXI_WVALID;
  wire xdma_0_axi_aclk;
  wire xdma_0_axi_aresetn;
  wire [7:0]xdma_0_pcie_mgt_rxn;
  wire [7:0]xdma_0_pcie_mgt_rxp;
  wire [7:0]xdma_0_pcie_mgt_txn;
  wire [7:0]xdma_0_pcie_mgt_txp;

  assign CLK_IN_D_0_1_CLK_N = pcie_ref_clk_n[0];
  assign CLK_IN_D_0_1_CLK_P = pcie_ref_clk_p[0];
  assign ddr3_sdram_addr[15:0] = mig_7series_0_DDR3_ADDR;
  assign ddr3_sdram_ba[2:0] = mig_7series_0_DDR3_BA;
  assign ddr3_sdram_cas_n = mig_7series_0_DDR3_CAS_N;
  assign ddr3_sdram_ck_n[1:0] = mig_7series_0_DDR3_CK_N;
  assign ddr3_sdram_ck_p[1:0] = mig_7series_0_DDR3_CK_P;
  assign ddr3_sdram_cke[1:0] = mig_7series_0_DDR3_CKE;
  assign ddr3_sdram_cs_n[1:0] = mig_7series_0_DDR3_CS_N;
  assign ddr3_sdram_dm[7:0] = mig_7series_0_DDR3_DM;
  assign ddr3_sdram_odt[1:0] = mig_7series_0_DDR3_ODT;
  assign ddr3_sdram_ras_n = mig_7series_0_DDR3_RAS_N;
  assign ddr3_sdram_reset_n = mig_7series_0_DDR3_RESET_N;
  assign ddr3_sdram_we_n = mig_7series_0_DDR3_WE_N;
  assign pcie_7x_mgt_rtl_txn[7:0] = xdma_0_pcie_mgt_txn;
  assign pcie_7x_mgt_rtl_txp[7:0] = xdma_0_pcie_mgt_txp;
  assign reset_rtl_1 = sys_rst;
  assign sys_diff_clock_1_CLK_N = sys_diff_clock_clk_n;
  assign sys_diff_clock_1_CLK_P = sys_diff_clock_clk_p;
  assign xdma_0_pcie_mgt_rxn = pcie_7x_mgt_rtl_rxn[7:0];
  assign xdma_0_pcie_mgt_rxp = pcie_7x_mgt_rtl_rxp[7:0];
  pci_mig_mig_7series_0_0 mig_7series_0
       (.aresetn(rst_mig_7series_0_100M_peripheral_aresetn),
        .ddr3_addr(mig_7series_0_DDR3_ADDR),
        .ddr3_ba(mig_7series_0_DDR3_BA),
        .ddr3_cas_n(mig_7series_0_DDR3_CAS_N),
        .ddr3_ck_n(mig_7series_0_DDR3_CK_N),
        .ddr3_ck_p(mig_7series_0_DDR3_CK_P),
        .ddr3_cke(mig_7series_0_DDR3_CKE),
        .ddr3_cs_n(mig_7series_0_DDR3_CS_N),
        .ddr3_dm(mig_7series_0_DDR3_DM),
        .ddr3_dq(ddr3_sdram_dq[63:0]),
        .ddr3_dqs_n(ddr3_sdram_dqs_n[7:0]),
        .ddr3_dqs_p(ddr3_sdram_dqs_p[7:0]),
        .ddr3_odt(mig_7series_0_DDR3_ODT),
        .ddr3_ras_n(mig_7series_0_DDR3_RAS_N),
        .ddr3_reset_n(mig_7series_0_DDR3_RESET_N),
        .ddr3_we_n(mig_7series_0_DDR3_WE_N),
        .mmcm_locked(mig_7series_0_mmcm_locked),
        .s_axi_araddr(smartconnect_0_M00_AXI_ARADDR),
        .s_axi_arburst(smartconnect_0_M00_AXI_ARBURST),
        .s_axi_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .s_axi_arid(1'b0),
        .s_axi_arlen(smartconnect_0_M00_AXI_ARLEN),
        .s_axi_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .s_axi_arprot(smartconnect_0_M00_AXI_ARPROT),
        .s_axi_arqos(smartconnect_0_M00_AXI_ARQOS),
        .s_axi_arready(smartconnect_0_M00_AXI_ARREADY),
        .s_axi_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .s_axi_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .s_axi_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .s_axi_awburst(smartconnect_0_M00_AXI_AWBURST),
        .s_axi_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .s_axi_awid(1'b0),
        .s_axi_awlen(smartconnect_0_M00_AXI_AWLEN),
        .s_axi_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .s_axi_awprot(smartconnect_0_M00_AXI_AWPROT),
        .s_axi_awqos(smartconnect_0_M00_AXI_AWQOS),
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
        .s_axi_wvalid(smartconnect_0_M00_AXI_WVALID),
        .sys_clk_n(sys_diff_clock_1_CLK_N),
        .sys_clk_p(sys_diff_clock_1_CLK_P),
        .sys_rst(reset_rtl_1),
        .ui_clk(mig_7series_0_ui_clk),
        .ui_clk_sync_rst(mig_7series_0_ui_clk_sync_rst));
  pci_mig_pci_mig_accelerator_0_0 pci_mig_accelerator_0
       (.m00_axi_aclk(xdma_0_axi_aclk),
        .m00_axi_araddr(pci_mig_accelerator_0_M00_AXI_ARADDR),
        .m00_axi_arburst(pci_mig_accelerator_0_M00_AXI_ARBURST),
        .m00_axi_arcache(pci_mig_accelerator_0_M00_AXI_ARCACHE),
        .m00_axi_aresetn(xdma_0_axi_aresetn),
        .m00_axi_arid(pci_mig_accelerator_0_M00_AXI_ARID),
        .m00_axi_arlen(pci_mig_accelerator_0_M00_AXI_ARLEN),
        .m00_axi_arlock(pci_mig_accelerator_0_M00_AXI_ARLOCK),
        .m00_axi_arprot(pci_mig_accelerator_0_M00_AXI_ARPROT),
        .m00_axi_arqos(pci_mig_accelerator_0_M00_AXI_ARQOS),
        .m00_axi_arready(pci_mig_accelerator_0_M00_AXI_ARREADY),
        .m00_axi_arsize(pci_mig_accelerator_0_M00_AXI_ARSIZE),
        .m00_axi_aruser(pci_mig_accelerator_0_M00_AXI_ARUSER),
        .m00_axi_arvalid(pci_mig_accelerator_0_M00_AXI_ARVALID),
        .m00_axi_awaddr(pci_mig_accelerator_0_M00_AXI_AWADDR),
        .m00_axi_awburst(pci_mig_accelerator_0_M00_AXI_AWBURST),
        .m00_axi_awcache(pci_mig_accelerator_0_M00_AXI_AWCACHE),
        .m00_axi_awid(pci_mig_accelerator_0_M00_AXI_AWID),
        .m00_axi_awlen(pci_mig_accelerator_0_M00_AXI_AWLEN),
        .m00_axi_awlock(pci_mig_accelerator_0_M00_AXI_AWLOCK),
        .m00_axi_awprot(pci_mig_accelerator_0_M00_AXI_AWPROT),
        .m00_axi_awqos(pci_mig_accelerator_0_M00_AXI_AWQOS),
        .m00_axi_awready(pci_mig_accelerator_0_M00_AXI_AWREADY),
        .m00_axi_awsize(pci_mig_accelerator_0_M00_AXI_AWSIZE),
        .m00_axi_awuser(pci_mig_accelerator_0_M00_AXI_AWUSER),
        .m00_axi_awvalid(pci_mig_accelerator_0_M00_AXI_AWVALID),
        .m00_axi_bid(pci_mig_accelerator_0_M00_AXI_BID),
        .m00_axi_bready(pci_mig_accelerator_0_M00_AXI_BREADY),
        .m00_axi_bresp(pci_mig_accelerator_0_M00_AXI_BRESP),
        .m00_axi_buser(pci_mig_accelerator_0_M00_AXI_BUSER),
        .m00_axi_bvalid(pci_mig_accelerator_0_M00_AXI_BVALID),
        .m00_axi_init_axi_txn(1'b0),
        .m00_axi_rdata(pci_mig_accelerator_0_M00_AXI_RDATA),
        .m00_axi_rid(pci_mig_accelerator_0_M00_AXI_RID),
        .m00_axi_rlast(pci_mig_accelerator_0_M00_AXI_RLAST),
        .m00_axi_rready(pci_mig_accelerator_0_M00_AXI_RREADY),
        .m00_axi_rresp(pci_mig_accelerator_0_M00_AXI_RRESP),
        .m00_axi_ruser(1'b0),
        .m00_axi_rvalid(pci_mig_accelerator_0_M00_AXI_RVALID),
        .m00_axi_wdata(pci_mig_accelerator_0_M00_AXI_WDATA),
        .m00_axi_wlast(pci_mig_accelerator_0_M00_AXI_WLAST),
        .m00_axi_wready(pci_mig_accelerator_0_M00_AXI_WREADY),
        .m00_axi_wstrb(pci_mig_accelerator_0_M00_AXI_WSTRB),
        .m00_axi_wuser(pci_mig_accelerator_0_M00_AXI_WUSER),
        .m00_axi_wvalid(pci_mig_accelerator_0_M00_AXI_WVALID),
        .s00_axi_aclk(xdma_0_axi_aclk),
        .s00_axi_araddr(smartconnect_0_M01_AXI_ARADDR),
        .s00_axi_arburst(smartconnect_0_M01_AXI_ARBURST),
        .s00_axi_arcache(smartconnect_0_M01_AXI_ARCACHE),
        .s00_axi_aresetn(xdma_0_axi_aresetn),
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
        .s00_axi_wvalid(smartconnect_0_M01_AXI_WVALID));
  pci_mig_rst_mig_7series_0_100M_0 rst_mig_7series_0_100M
       (.aux_reset_in(1'b1),
        .dcm_locked(mig_7series_0_mmcm_locked),
        .ext_reset_in(mig_7series_0_ui_clk_sync_rst),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_mig_7series_0_100M_peripheral_aresetn),
        .slowest_sync_clk(mig_7series_0_ui_clk));
  pci_mig_smartconnect_0_0 smartconnect_0
       (.M00_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .M00_AXI_arburst(smartconnect_0_M00_AXI_ARBURST),
        .M00_AXI_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .M00_AXI_arlen(smartconnect_0_M00_AXI_ARLEN),
        .M00_AXI_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .M00_AXI_arprot(smartconnect_0_M00_AXI_ARPROT),
        .M00_AXI_arqos(smartconnect_0_M00_AXI_ARQOS),
        .M00_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .M00_AXI_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .M00_AXI_aruser(smartconnect_0_M00_AXI_ARUSER),
        .M00_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .M00_AXI_awburst(smartconnect_0_M00_AXI_AWBURST),
        .M00_AXI_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .M00_AXI_awlen(smartconnect_0_M00_AXI_AWLEN),
        .M00_AXI_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .M00_AXI_awprot(smartconnect_0_M00_AXI_AWPROT),
        .M00_AXI_awqos(smartconnect_0_M00_AXI_AWQOS),
        .M00_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .M00_AXI_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .M00_AXI_awuser(smartconnect_0_M00_AXI_AWUSER),
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
        .S01_AXI_araddr(pci_mig_accelerator_0_M00_AXI_ARADDR),
        .S01_AXI_arburst(pci_mig_accelerator_0_M00_AXI_ARBURST),
        .S01_AXI_arcache(pci_mig_accelerator_0_M00_AXI_ARCACHE),
        .S01_AXI_arid(pci_mig_accelerator_0_M00_AXI_ARID),
        .S01_AXI_arlen(pci_mig_accelerator_0_M00_AXI_ARLEN),
        .S01_AXI_arlock(pci_mig_accelerator_0_M00_AXI_ARLOCK),
        .S01_AXI_arprot(pci_mig_accelerator_0_M00_AXI_ARPROT),
        .S01_AXI_arqos(pci_mig_accelerator_0_M00_AXI_ARQOS),
        .S01_AXI_arready(pci_mig_accelerator_0_M00_AXI_ARREADY),
        .S01_AXI_arsize(pci_mig_accelerator_0_M00_AXI_ARSIZE),
        .S01_AXI_aruser(pci_mig_accelerator_0_M00_AXI_ARUSER),
        .S01_AXI_arvalid(pci_mig_accelerator_0_M00_AXI_ARVALID),
        .S01_AXI_awaddr(pci_mig_accelerator_0_M00_AXI_AWADDR),
        .S01_AXI_awburst(pci_mig_accelerator_0_M00_AXI_AWBURST),
        .S01_AXI_awcache(pci_mig_accelerator_0_M00_AXI_AWCACHE),
        .S01_AXI_awid(pci_mig_accelerator_0_M00_AXI_AWID),
        .S01_AXI_awlen(pci_mig_accelerator_0_M00_AXI_AWLEN),
        .S01_AXI_awlock(pci_mig_accelerator_0_M00_AXI_AWLOCK),
        .S01_AXI_awprot(pci_mig_accelerator_0_M00_AXI_AWPROT),
        .S01_AXI_awqos(pci_mig_accelerator_0_M00_AXI_AWQOS),
        .S01_AXI_awready(pci_mig_accelerator_0_M00_AXI_AWREADY),
        .S01_AXI_awsize(pci_mig_accelerator_0_M00_AXI_AWSIZE),
        .S01_AXI_awuser(pci_mig_accelerator_0_M00_AXI_AWUSER),
        .S01_AXI_awvalid(pci_mig_accelerator_0_M00_AXI_AWVALID),
        .S01_AXI_bid(pci_mig_accelerator_0_M00_AXI_BID),
        .S01_AXI_bready(pci_mig_accelerator_0_M00_AXI_BREADY),
        .S01_AXI_bresp(pci_mig_accelerator_0_M00_AXI_BRESP),
        .S01_AXI_buser(pci_mig_accelerator_0_M00_AXI_BUSER),
        .S01_AXI_bvalid(pci_mig_accelerator_0_M00_AXI_BVALID),
        .S01_AXI_rdata(pci_mig_accelerator_0_M00_AXI_RDATA),
        .S01_AXI_rid(pci_mig_accelerator_0_M00_AXI_RID),
        .S01_AXI_rlast(pci_mig_accelerator_0_M00_AXI_RLAST),
        .S01_AXI_rready(pci_mig_accelerator_0_M00_AXI_RREADY),
        .S01_AXI_rresp(pci_mig_accelerator_0_M00_AXI_RRESP),
        .S01_AXI_rvalid(pci_mig_accelerator_0_M00_AXI_RVALID),
        .S01_AXI_wdata(pci_mig_accelerator_0_M00_AXI_WDATA),
        .S01_AXI_wlast(pci_mig_accelerator_0_M00_AXI_WLAST),
        .S01_AXI_wready(pci_mig_accelerator_0_M00_AXI_WREADY),
        .S01_AXI_wstrb(pci_mig_accelerator_0_M00_AXI_WSTRB),
        .S01_AXI_wvalid(pci_mig_accelerator_0_M00_AXI_WVALID),
        .aclk(xdma_0_axi_aclk),
        .aclk1(mig_7series_0_ui_clk),
        .aresetn(xdma_0_axi_aresetn));
  pci_mig_system_ila_0_0 system_ila_0
       (.SLOT_0_AXI_araddr(xdma_0_M_AXI_ARADDR),
        .SLOT_0_AXI_arcache(xdma_0_M_AXI_ARCACHE),
        .SLOT_0_AXI_arid(xdma_0_M_AXI_ARID),
        .SLOT_0_AXI_arlen(xdma_0_M_AXI_ARLEN),
        .SLOT_0_AXI_arlock(xdma_0_M_AXI_ARLOCK),
        .SLOT_0_AXI_arprot(xdma_0_M_AXI_ARPROT),
        .SLOT_0_AXI_arready(xdma_0_M_AXI_ARREADY),
        .SLOT_0_AXI_arsize(xdma_0_M_AXI_ARSIZE),
        .SLOT_0_AXI_arvalid(xdma_0_M_AXI_ARVALID),
        .SLOT_0_AXI_awaddr(xdma_0_M_AXI_AWADDR),
        .SLOT_0_AXI_awcache(xdma_0_M_AXI_AWCACHE),
        .SLOT_0_AXI_awid(xdma_0_M_AXI_AWID),
        .SLOT_0_AXI_awlen(xdma_0_M_AXI_AWLEN),
        .SLOT_0_AXI_awlock(xdma_0_M_AXI_AWLOCK),
        .SLOT_0_AXI_awprot(xdma_0_M_AXI_AWPROT),
        .SLOT_0_AXI_awready(xdma_0_M_AXI_AWREADY),
        .SLOT_0_AXI_awsize(xdma_0_M_AXI_AWSIZE),
        .SLOT_0_AXI_awvalid(xdma_0_M_AXI_AWVALID),
        .SLOT_0_AXI_bid(xdma_0_M_AXI_BID),
        .SLOT_0_AXI_bready(xdma_0_M_AXI_BREADY),
        .SLOT_0_AXI_bresp(xdma_0_M_AXI_BRESP),
        .SLOT_0_AXI_bvalid(xdma_0_M_AXI_BVALID),
        .SLOT_0_AXI_rdata(xdma_0_M_AXI_RDATA),
        .SLOT_0_AXI_rid(xdma_0_M_AXI_RID),
        .SLOT_0_AXI_rlast(xdma_0_M_AXI_RLAST),
        .SLOT_0_AXI_rready(xdma_0_M_AXI_RREADY),
        .SLOT_0_AXI_rresp(xdma_0_M_AXI_RRESP),
        .SLOT_0_AXI_rvalid(xdma_0_M_AXI_RVALID),
        .SLOT_0_AXI_wdata(xdma_0_M_AXI_WDATA),
        .SLOT_0_AXI_wlast(xdma_0_M_AXI_WLAST),
        .SLOT_0_AXI_wready(xdma_0_M_AXI_WREADY),
        .SLOT_0_AXI_wstrb(xdma_0_M_AXI_WSTRB),
        .SLOT_0_AXI_wvalid(xdma_0_M_AXI_WVALID),
        .SLOT_1_AXI_araddr(smartconnect_0_M01_AXI_ARADDR),
        .SLOT_1_AXI_arburst(smartconnect_0_M01_AXI_ARBURST),
        .SLOT_1_AXI_arcache(smartconnect_0_M01_AXI_ARCACHE),
        .SLOT_1_AXI_arlen(smartconnect_0_M01_AXI_ARLEN),
        .SLOT_1_AXI_arlock(smartconnect_0_M01_AXI_ARLOCK),
        .SLOT_1_AXI_arprot(smartconnect_0_M01_AXI_ARPROT),
        .SLOT_1_AXI_arqos(smartconnect_0_M01_AXI_ARQOS),
        .SLOT_1_AXI_arready(smartconnect_0_M01_AXI_ARREADY),
        .SLOT_1_AXI_arsize(smartconnect_0_M01_AXI_ARSIZE),
        .SLOT_1_AXI_aruser(smartconnect_0_M01_AXI_ARUSER),
        .SLOT_1_AXI_arvalid(smartconnect_0_M01_AXI_ARVALID),
        .SLOT_1_AXI_awaddr(smartconnect_0_M01_AXI_AWADDR),
        .SLOT_1_AXI_awburst(smartconnect_0_M01_AXI_AWBURST),
        .SLOT_1_AXI_awcache(smartconnect_0_M01_AXI_AWCACHE),
        .SLOT_1_AXI_awlen(smartconnect_0_M01_AXI_AWLEN),
        .SLOT_1_AXI_awlock(smartconnect_0_M01_AXI_AWLOCK),
        .SLOT_1_AXI_awprot(smartconnect_0_M01_AXI_AWPROT),
        .SLOT_1_AXI_awqos(smartconnect_0_M01_AXI_AWQOS),
        .SLOT_1_AXI_awready(smartconnect_0_M01_AXI_AWREADY),
        .SLOT_1_AXI_awsize(smartconnect_0_M01_AXI_AWSIZE),
        .SLOT_1_AXI_awuser(smartconnect_0_M01_AXI_AWUSER),
        .SLOT_1_AXI_awvalid(smartconnect_0_M01_AXI_AWVALID),
        .SLOT_1_AXI_bready(smartconnect_0_M01_AXI_BREADY),
        .SLOT_1_AXI_bresp(smartconnect_0_M01_AXI_BRESP),
        .SLOT_1_AXI_buser(smartconnect_0_M01_AXI_BUSER),
        .SLOT_1_AXI_bvalid(smartconnect_0_M01_AXI_BVALID),
        .SLOT_1_AXI_rdata(smartconnect_0_M01_AXI_RDATA),
        .SLOT_1_AXI_rlast(smartconnect_0_M01_AXI_RLAST),
        .SLOT_1_AXI_rready(smartconnect_0_M01_AXI_RREADY),
        .SLOT_1_AXI_rresp(smartconnect_0_M01_AXI_RRESP),
        .SLOT_1_AXI_rvalid(smartconnect_0_M01_AXI_RVALID),
        .SLOT_1_AXI_wdata(smartconnect_0_M01_AXI_WDATA),
        .SLOT_1_AXI_wlast(smartconnect_0_M01_AXI_WLAST),
        .SLOT_1_AXI_wready(smartconnect_0_M01_AXI_WREADY),
        .SLOT_1_AXI_wstrb(smartconnect_0_M01_AXI_WSTRB),
        .SLOT_1_AXI_wvalid(smartconnect_0_M01_AXI_WVALID),
        .SLOT_2_AXI_araddr(pci_mig_accelerator_0_M00_AXI_ARADDR),
        .SLOT_2_AXI_arburst(pci_mig_accelerator_0_M00_AXI_ARBURST),
        .SLOT_2_AXI_arcache(pci_mig_accelerator_0_M00_AXI_ARCACHE),
        .SLOT_2_AXI_arid(pci_mig_accelerator_0_M00_AXI_ARID),
        .SLOT_2_AXI_arlen(pci_mig_accelerator_0_M00_AXI_ARLEN),
        .SLOT_2_AXI_arlock(pci_mig_accelerator_0_M00_AXI_ARLOCK),
        .SLOT_2_AXI_arprot(pci_mig_accelerator_0_M00_AXI_ARPROT),
        .SLOT_2_AXI_arqos(pci_mig_accelerator_0_M00_AXI_ARQOS),
        .SLOT_2_AXI_arready(pci_mig_accelerator_0_M00_AXI_ARREADY),
        .SLOT_2_AXI_arsize(pci_mig_accelerator_0_M00_AXI_ARSIZE),
        .SLOT_2_AXI_aruser(pci_mig_accelerator_0_M00_AXI_ARUSER),
        .SLOT_2_AXI_arvalid(pci_mig_accelerator_0_M00_AXI_ARVALID),
        .SLOT_2_AXI_awaddr(pci_mig_accelerator_0_M00_AXI_AWADDR),
        .SLOT_2_AXI_awburst(pci_mig_accelerator_0_M00_AXI_AWBURST),
        .SLOT_2_AXI_awcache(pci_mig_accelerator_0_M00_AXI_AWCACHE),
        .SLOT_2_AXI_awid(pci_mig_accelerator_0_M00_AXI_AWID),
        .SLOT_2_AXI_awlen(pci_mig_accelerator_0_M00_AXI_AWLEN),
        .SLOT_2_AXI_awlock(pci_mig_accelerator_0_M00_AXI_AWLOCK),
        .SLOT_2_AXI_awprot(pci_mig_accelerator_0_M00_AXI_AWPROT),
        .SLOT_2_AXI_awqos(pci_mig_accelerator_0_M00_AXI_AWQOS),
        .SLOT_2_AXI_awready(pci_mig_accelerator_0_M00_AXI_AWREADY),
        .SLOT_2_AXI_awsize(pci_mig_accelerator_0_M00_AXI_AWSIZE),
        .SLOT_2_AXI_awuser(pci_mig_accelerator_0_M00_AXI_AWUSER),
        .SLOT_2_AXI_awvalid(pci_mig_accelerator_0_M00_AXI_AWVALID),
        .SLOT_2_AXI_bid(pci_mig_accelerator_0_M00_AXI_BID),
        .SLOT_2_AXI_bready(pci_mig_accelerator_0_M00_AXI_BREADY),
        .SLOT_2_AXI_bresp(pci_mig_accelerator_0_M00_AXI_BRESP),
        .SLOT_2_AXI_buser(pci_mig_accelerator_0_M00_AXI_BUSER),
        .SLOT_2_AXI_bvalid(pci_mig_accelerator_0_M00_AXI_BVALID),
        .SLOT_2_AXI_rdata(pci_mig_accelerator_0_M00_AXI_RDATA),
        .SLOT_2_AXI_rid(pci_mig_accelerator_0_M00_AXI_RID),
        .SLOT_2_AXI_rlast(pci_mig_accelerator_0_M00_AXI_RLAST),
        .SLOT_2_AXI_rready(pci_mig_accelerator_0_M00_AXI_RREADY),
        .SLOT_2_AXI_rresp(pci_mig_accelerator_0_M00_AXI_RRESP),
        .SLOT_2_AXI_ruser(1'b0),
        .SLOT_2_AXI_rvalid(pci_mig_accelerator_0_M00_AXI_RVALID),
        .SLOT_2_AXI_wdata(pci_mig_accelerator_0_M00_AXI_WDATA),
        .SLOT_2_AXI_wlast(pci_mig_accelerator_0_M00_AXI_WLAST),
        .SLOT_2_AXI_wready(pci_mig_accelerator_0_M00_AXI_WREADY),
        .SLOT_2_AXI_wstrb(pci_mig_accelerator_0_M00_AXI_WSTRB),
        .SLOT_2_AXI_wuser(pci_mig_accelerator_0_M00_AXI_WUSER),
        .SLOT_2_AXI_wvalid(pci_mig_accelerator_0_M00_AXI_WVALID),
        .clk(xdma_0_axi_aclk),
        .resetn(xdma_0_axi_aresetn));
  pci_mig_system_ila_1_0 system_ila_1
       (.SLOT_0_AXI_araddr(smartconnect_0_M00_AXI_ARADDR),
        .SLOT_0_AXI_arburst(smartconnect_0_M00_AXI_ARBURST),
        .SLOT_0_AXI_arcache(smartconnect_0_M00_AXI_ARCACHE),
        .SLOT_0_AXI_arlen(smartconnect_0_M00_AXI_ARLEN),
        .SLOT_0_AXI_arlock(smartconnect_0_M00_AXI_ARLOCK),
        .SLOT_0_AXI_arprot(smartconnect_0_M00_AXI_ARPROT),
        .SLOT_0_AXI_arqos(smartconnect_0_M00_AXI_ARQOS),
        .SLOT_0_AXI_arready(smartconnect_0_M00_AXI_ARREADY),
        .SLOT_0_AXI_arsize(smartconnect_0_M00_AXI_ARSIZE),
        .SLOT_0_AXI_aruser(smartconnect_0_M00_AXI_ARUSER),
        .SLOT_0_AXI_arvalid(smartconnect_0_M00_AXI_ARVALID),
        .SLOT_0_AXI_awaddr(smartconnect_0_M00_AXI_AWADDR),
        .SLOT_0_AXI_awburst(smartconnect_0_M00_AXI_AWBURST),
        .SLOT_0_AXI_awcache(smartconnect_0_M00_AXI_AWCACHE),
        .SLOT_0_AXI_awlen(smartconnect_0_M00_AXI_AWLEN),
        .SLOT_0_AXI_awlock(smartconnect_0_M00_AXI_AWLOCK),
        .SLOT_0_AXI_awprot(smartconnect_0_M00_AXI_AWPROT),
        .SLOT_0_AXI_awqos(smartconnect_0_M00_AXI_AWQOS),
        .SLOT_0_AXI_awready(smartconnect_0_M00_AXI_AWREADY),
        .SLOT_0_AXI_awsize(smartconnect_0_M00_AXI_AWSIZE),
        .SLOT_0_AXI_awuser(smartconnect_0_M00_AXI_AWUSER),
        .SLOT_0_AXI_awvalid(smartconnect_0_M00_AXI_AWVALID),
        .SLOT_0_AXI_bready(smartconnect_0_M00_AXI_BREADY),
        .SLOT_0_AXI_bresp(smartconnect_0_M00_AXI_BRESP),
        .SLOT_0_AXI_buser(1'b0),
        .SLOT_0_AXI_bvalid(smartconnect_0_M00_AXI_BVALID),
        .SLOT_0_AXI_rdata(smartconnect_0_M00_AXI_RDATA),
        .SLOT_0_AXI_rlast(smartconnect_0_M00_AXI_RLAST),
        .SLOT_0_AXI_rready(smartconnect_0_M00_AXI_RREADY),
        .SLOT_0_AXI_rresp(smartconnect_0_M00_AXI_RRESP),
        .SLOT_0_AXI_rvalid(smartconnect_0_M00_AXI_RVALID),
        .SLOT_0_AXI_wdata(smartconnect_0_M00_AXI_WDATA),
        .SLOT_0_AXI_wlast(smartconnect_0_M00_AXI_WLAST),
        .SLOT_0_AXI_wready(smartconnect_0_M00_AXI_WREADY),
        .SLOT_0_AXI_wstrb(smartconnect_0_M00_AXI_WSTRB),
        .SLOT_0_AXI_wvalid(smartconnect_0_M00_AXI_WVALID),
        .clk(mig_7series_0_ui_clk),
        .resetn(rst_mig_7series_0_100M_peripheral_aresetn));
  pci_mig_util_ds_buf_0_0 util_ds_buf_0
       (.IBUF_DS_N(CLK_IN_D_0_1_CLK_N),
        .IBUF_DS_P(CLK_IN_D_0_1_CLK_P),
        .IBUF_OUT(util_ds_buf_0_IBUF_OUT));
  pci_mig_xdma_0_0 xdma_0
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
