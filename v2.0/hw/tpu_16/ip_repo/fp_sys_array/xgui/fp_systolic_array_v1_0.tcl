# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "INPUT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_COLS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NUM_ROWS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "OUTPUT_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WEIGHT_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.INPUT_WIDTH { PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to update INPUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INPUT_WIDTH { PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to validate INPUT_WIDTH
	return true
}

proc update_PARAM_VALUE.NUM_COLS { PARAM_VALUE.NUM_COLS } {
	# Procedure called to update NUM_COLS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_COLS { PARAM_VALUE.NUM_COLS } {
	# Procedure called to validate NUM_COLS
	return true
}

proc update_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to update NUM_ROWS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_ROWS { PARAM_VALUE.NUM_ROWS } {
	# Procedure called to validate NUM_ROWS
	return true
}

proc update_PARAM_VALUE.OUTPUT_WIDTH { PARAM_VALUE.OUTPUT_WIDTH } {
	# Procedure called to update OUTPUT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_WIDTH { PARAM_VALUE.OUTPUT_WIDTH } {
	# Procedure called to validate OUTPUT_WIDTH
	return true
}

proc update_PARAM_VALUE.WEIGHT_WIDTH { PARAM_VALUE.WEIGHT_WIDTH } {
	# Procedure called to update WEIGHT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WEIGHT_WIDTH { PARAM_VALUE.WEIGHT_WIDTH } {
	# Procedure called to validate WEIGHT_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.INPUT_WIDTH { MODELPARAM_VALUE.INPUT_WIDTH PARAM_VALUE.INPUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INPUT_WIDTH}] ${MODELPARAM_VALUE.INPUT_WIDTH}
}

proc update_MODELPARAM_VALUE.WEIGHT_WIDTH { MODELPARAM_VALUE.WEIGHT_WIDTH PARAM_VALUE.WEIGHT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WEIGHT_WIDTH}] ${MODELPARAM_VALUE.WEIGHT_WIDTH}
}

proc update_MODELPARAM_VALUE.OUTPUT_WIDTH { MODELPARAM_VALUE.OUTPUT_WIDTH PARAM_VALUE.OUTPUT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_WIDTH}] ${MODELPARAM_VALUE.OUTPUT_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_ROWS { MODELPARAM_VALUE.NUM_ROWS PARAM_VALUE.NUM_ROWS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_ROWS}] ${MODELPARAM_VALUE.NUM_ROWS}
}

proc update_MODELPARAM_VALUE.NUM_COLS { MODELPARAM_VALUE.NUM_COLS PARAM_VALUE.NUM_COLS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_COLS}] ${MODELPARAM_VALUE.NUM_COLS}
}

