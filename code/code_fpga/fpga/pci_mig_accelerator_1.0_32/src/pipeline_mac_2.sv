//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Wed Apr 19 23:09:40 2023
//Host        : the-cow running 64-bit Ubuntu 22.04.2 LTS
//Command     : generate_target pipeline_mac_2.bd
//Design      : pipeline_mac_2
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pipeline_mac_2 #(
    parameter MAC_ID = 0,
    parameter USE_1_DSP_ID = 752
)
   (S_AXIS_A_0_tdata,
    S_AXIS_A_0_tvalid,
    S_AXIS_B_0_tdata,
    S_AXIS_B_0_tvalid,
    mac_result,
    M_AXIS_RESULT_0_tvalid,
    aclk_0,
    aresetn_0);
  input [15:0]S_AXIS_A_0_tdata;
  input S_AXIS_A_0_tvalid;
  input [15:0]S_AXIS_B_0_tdata;
  input S_AXIS_B_0_tvalid;
  input aclk_0;
  input aresetn_0;
  output [15:0] mac_result;
  output M_AXIS_RESULT_0_tvalid;
  
  assign M_AXIS_RESULT_0_tvalid = floating_point_1_m_axis_result_tvalid;
  assign mac_result = floating_point_1_m_axis_result_tdata;

  wire [15:0]S_AXIS_A_0_1_TDATA;
  wire S_AXIS_A_0_1_TVALID;
  wire [15:0]S_AXIS_B_0_1_TDATA;
  wire S_AXIS_B_0_1_TVALID;
  wire aclk_0_1;
  wire aresetn_0_1;
  wire [15:0]floating_point_0_M_AXIS_RESULT_TDATA;
  wire floating_point_0_M_AXIS_RESULT_TVALID;
  wire [15:0]floating_point_1_m_axis_result_tdata;
  wire floating_point_1_m_axis_result_tvalid;

  assign S_AXIS_A_0_1_TDATA = S_AXIS_A_0_tdata[15:0];
  assign S_AXIS_A_0_1_TVALID = S_AXIS_A_0_tvalid;
  assign S_AXIS_B_0_1_TDATA = S_AXIS_B_0_tdata[15:0];
  assign S_AXIS_B_0_1_TVALID = S_AXIS_B_0_tvalid;
  assign aclk_0_1 = aclk_0;
  assign aresetn_0_1 = aresetn_0;
  pmac_2_mul multiplier (
          .aclk(aclk_0_1),
          .aresetn(aresetn_0_1),
          .m_axis_result_tdata(floating_point_0_M_AXIS_RESULT_TDATA),
          .m_axis_result_tvalid(floating_point_0_M_AXIS_RESULT_TVALID),
          .s_axis_a_tdata(S_AXIS_A_0_1_TDATA),
          .s_axis_a_tvalid(S_AXIS_A_0_1_TVALID),
          .s_axis_b_tdata(S_AXIS_B_0_1_TDATA),
          .s_axis_b_tvalid(S_AXIS_B_0_1_TVALID)
        );
  generate
    if(MAC_ID >= USE_1_DSP_ID ) begin 
       pmac_2_acc accumulator (
          .aclk(aclk_0_1),
          .aresetn(aresetn_0_1),
          .m_axis_result_tdata(floating_point_1_m_axis_result_tdata),
          .m_axis_result_tvalid(floating_point_1_m_axis_result_tvalid),
          .s_axis_a_tdata(floating_point_0_M_AXIS_RESULT_TDATA),
          .s_axis_a_tvalid(floating_point_0_M_AXIS_RESULT_TVALID),
          .s_axis_a_tlast('0)
        );
    end else begin 
       pmac_2_acc_fulldsp accumulator (
          .aclk(aclk_0_1),
          .aresetn(aresetn_0_1),
          .m_axis_result_tdata(floating_point_1_m_axis_result_tdata),
          .m_axis_result_tvalid(floating_point_1_m_axis_result_tvalid),
          .s_axis_a_tdata(floating_point_0_M_AXIS_RESULT_TDATA),
          .s_axis_a_tvalid(floating_point_0_M_AXIS_RESULT_TVALID),
          .s_axis_a_tlast('0)
        );
    end 
  endgenerate
endmodule
