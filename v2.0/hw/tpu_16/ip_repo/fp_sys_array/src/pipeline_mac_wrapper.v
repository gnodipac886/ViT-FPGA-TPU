//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Wed Mar 15 22:24:35 2023
//Host        : the-cow running 64-bit Ubuntu 22.04.2 LTS
//Command     : generate_target pipeline_mac_wrapper.bd
//Design      : pipeline_mac_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pipeline_mac_wrapper
   (M_AXIS_RESULT_0_tdata,
    M_AXIS_RESULT_0_tlast,
    M_AXIS_RESULT_0_tready,
    M_AXIS_RESULT_0_tvalid,
    S_AXIS_A_0_tdata,
    S_AXIS_A_0_tready,
    S_AXIS_A_0_tvalid,
    S_AXIS_B_0_tdata,
    S_AXIS_B_0_tready,
    S_AXIS_B_0_tvalid,
    clk,
    rst_n);
  output [31:0]M_AXIS_RESULT_0_tdata;
  output M_AXIS_RESULT_0_tlast;
  input M_AXIS_RESULT_0_tready;
  output M_AXIS_RESULT_0_tvalid;
  input [31:0]S_AXIS_A_0_tdata;
  output S_AXIS_A_0_tready;
  input S_AXIS_A_0_tvalid;
  input [31:0]S_AXIS_B_0_tdata;
  output S_AXIS_B_0_tready;
  input S_AXIS_B_0_tvalid;
  input clk;
  input rst_n;

  wire [31:0]M_AXIS_RESULT_0_tdata;
  wire M_AXIS_RESULT_0_tlast;
  wire M_AXIS_RESULT_0_tready;
  wire M_AXIS_RESULT_0_tvalid;
  wire [31:0]S_AXIS_A_0_tdata;
  wire S_AXIS_A_0_tready;
  wire S_AXIS_A_0_tvalid;
  wire [31:0]S_AXIS_B_0_tdata;
  wire S_AXIS_B_0_tready;
  wire S_AXIS_B_0_tvalid;
  wire clk;
  wire rst_n;

  pipeline_mac pipeline_mac_i
       (.M_AXIS_RESULT_0_tdata(M_AXIS_RESULT_0_tdata),
        .M_AXIS_RESULT_0_tlast(M_AXIS_RESULT_0_tlast),
        .M_AXIS_RESULT_0_tready(M_AXIS_RESULT_0_tready),
        .M_AXIS_RESULT_0_tvalid(M_AXIS_RESULT_0_tvalid),
        .S_AXIS_A_0_tdata(S_AXIS_A_0_tdata),
        .S_AXIS_A_0_tready(S_AXIS_A_0_tready),
        .S_AXIS_A_0_tvalid(S_AXIS_A_0_tvalid),
        .S_AXIS_B_0_tdata(S_AXIS_B_0_tdata),
        .S_AXIS_B_0_tready(S_AXIS_B_0_tready),
        .S_AXIS_B_0_tvalid(S_AXIS_B_0_tvalid),
        .clk(clk),
        .rst_n(rst_n));
endmodule
