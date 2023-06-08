#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2021.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed Apr 05 04:22:53 EDT 2023
# SW Build 3247384 on Thu Jun 10 19:36:07 MDT 2021
#
# IP Build 3246043 on Fri Jun 11 00:30:35 MDT 2021
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 8aa83cdba8c542939b5e79fb125414f2 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L uvm -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot accelerator_tb_behav xil_defaultlib.accelerator_tb xil_defaultlib.glbl -log elaborate.log"
xelab -wto 8aa83cdba8c542939b5e79fb125414f2 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L uvm -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot accelerator_tb_behav xil_defaultlib.accelerator_tb xil_defaultlib.glbl -log elaborate.log
