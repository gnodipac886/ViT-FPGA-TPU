###############################################################################
# User Configuration
# Link Width   - x8
# Link Speed   - gen2
# Family       - virtex7
# Part         - xc7vx485t
# Package      - ffg1761
# Speed grade  - -2
# PCIe Block   - X0Y0

###############################################################################
#
#########################################################################################################################
# User Constraints
#########################################################################################################################

###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
#create_clock -period 5.000 -name sys_diff_clock [get_ports sys_diff_clock_clk_p]
create_clock -period 10.0 -name pcie_ref [get_ports pcie_ref_clk_p]
#create_clock -period 10.000 -name usr_clk [get_ports usr_clk_clk_p]

###############################################################################
# User Physical Constraints
###############################################################################
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pulldown [current_design]
set_property CONFIG_MODE BPI16 [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

###############################################################################
# Pinout and Related I/O Constraints
###############################################################################

#
# LED Status Indicators for Example Design.
# LED 0-2 should be ON if link is up and functioning correctly
# LED 3 should be blinking if user applicaiton is receiving valid clock
#

# SYS RESET = led_0
#set_property LOC AM39 [get_ports led_0]
#set_property IOSTANDARD LVCMOS18 [get_ports led_0]

# USER RESET = led_1
#set_property LOC AN39 [get_ports led_1]
#set_property IOSTANDARD LVCMOS18 [get_ports led_1]

# USER LINK UP = led_2
# set_property LOC AR37 [get_ports led_user_lnk_up]
# set_property IOSTANDARD LVCMOS18 [get_ports led_user_lnk_up]

# USER CLK HEART BEAT = led_3
#set_property LOC AT37 [get_ports led_3]
#set_property IOSTANDARD LVCMOS18 [get_ports led_3]

# set_false_path -to [get_ports -filter {NAME=~led_*}]

###############################################################################
# Physical Constraints
###############################################################################

#
# SYS reset (input) signal.  The sys_reset_n signal should be
# obtained from the PCI Express interface if possible.  For
# slot based form factors, a system reset signal is usually
# present on the connector.  For cable based form factors, a
# system reset signal may not be available.  In this case, the
# system reset signal must be generated locally by some form of
# supervisory circuit.  You may change the IOSTANDARD and LOC
# to suit your requirements and VCCO voltage banking rules.
# Some 7 series devices do not have 3.3 V I/Os available.
# Therefore the appropriate level shift is required to operate
# with these devices that contain only 1.8 V banks.
#
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst]
set_property PULLUP true [get_ports sys_rst]
set_property PACKAGE_PIN AV35 [get_ports sys_rst]

set_false_path -from [get_ports sys_rst]

#
# SYS Clock
#

# SYS_CLK_P
#set_property IOSTANDARD LVDS [get_ports sys_diff_clock_clk_p]

## SYS_CLK_N
#set_property PACKAGE_PIN E19 [get_ports sys_diff_clock_clk_p]
#set_property PACKAGE_PIN E18 [get_ports sys_diff_clock_clk_n]
#set_property IOSTANDARD LVDS [get_ports sys_diff_clock_clk_n]

#
# PCIe Reset Signal. Same as SYS Reset Signal.
# Refer UG885, page 36
#

# PCIE_PERST_B PERST Integrated Endpoint block reset signal
#set_property LOC AV35 [get_ports pcie_perst_ls]
#set_property IOSTANDARD LVCMOS18 [get_ports pcie_perst_ls]

#
# PCIe Reference Clock for MGT_BANK_114.
# The VC707 board includes a Silicon Labs Si5324 jitter attenuator U24 on the back side of the
# board. FPGA user logic can implement a clock recovery circuit and then output this clock
# to a differential I/O pair on I/O bank 13 (REC_CLOCK_C_P, FPGA U1 pin AW32 and
# REC_CLOCK_C_N, FPGA U1 pin AW33) for jitter attenuation. The jitter attenuated clock
# (Si5324_OUT_C_P, Si5324_OUT_C_N) is then routed as a reference clock to GTX Quad 114
# inputs MGTREFCLK0P (FPGA U1 pin AD8) and MGTREFCLK0N (FPGA U1 pin AD7).
# Refer UG885, page 31, 35,36
#

# MGT_BANK_114 GTXE2_CHANNEL_X1Y5 PCIe6
#set_property LOC IBUFDS_GTE2_X1Y5 [get_cells refclk_ibuf]

# Si5324_OUT_C_P REFCLK\+ Integrated EndPoint block differential clock pair from PCIe

# Si5324_OUT_C_N REFCLK- Integrated EndPoint block differential clock pair from PCIe
set_property PACKAGE_PIN AB8 [get_ports pcie_ref_clk_p]
set_property PACKAGE_PIN AB7 [get_ports pcie_ref_clk_n]
set_property PACKAGE_PIN AG6 [get_ports {pcie_7x_mgt_rtl_rxp[7]}]
set_property PACKAGE_PIN AF4 [get_ports {pcie_7x_mgt_rtl_rxp[6]}]
set_property PACKAGE_PIN AE6 [get_ports {pcie_7x_mgt_rtl_rxp[5]}]
set_property PACKAGE_PIN AD4 [get_ports {pcie_7x_mgt_rtl_rxp[4]}]
set_property PACKAGE_PIN AC6 [get_ports {pcie_7x_mgt_rtl_rxp[3]}]
set_property PACKAGE_PIN AB4 [get_ports {pcie_7x_mgt_rtl_rxp[2]}]
set_property PACKAGE_PIN AA6 [get_ports {pcie_7x_mgt_rtl_rxp[1]}]
set_property PACKAGE_PIN Y4 [get_ports {pcie_7x_mgt_rtl_rxp[0]}]
set_property PACKAGE_PIN AK4 [get_ports {pcie_7x_mgt_rtl_txp[7]}]
set_property PACKAGE_PIN AJ2 [get_ports {pcie_7x_mgt_rtl_txp[6]}]
set_property PACKAGE_PIN AH4 [get_ports {pcie_7x_mgt_rtl_txp[5]}]
set_property PACKAGE_PIN AG2 [get_ports {pcie_7x_mgt_rtl_txp[4]}]
set_property PACKAGE_PIN AE2 [get_ports {pcie_7x_mgt_rtl_txp[3]}]
set_property PACKAGE_PIN AC2 [get_ports {pcie_7x_mgt_rtl_txp[2]}]
set_property PACKAGE_PIN AA2 [get_ports {pcie_7x_mgt_rtl_txp[1]}]
set_property PACKAGE_PIN W2 [get_ports {pcie_7x_mgt_rtl_txp[0]}]
