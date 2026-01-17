# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "PEAK_AVR_POINT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PEAK_THRESHOLD" -parent ${Page_0}
  ipgui::add_param $IPINST -name "REG_GLOBAL_LIMIT" -parent ${Page_0}


}

proc update_PARAM_VALUE.PEAK_AVR_POINT { PARAM_VALUE.PEAK_AVR_POINT } {
	# Procedure called to update PEAK_AVR_POINT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PEAK_AVR_POINT { PARAM_VALUE.PEAK_AVR_POINT } {
	# Procedure called to validate PEAK_AVR_POINT
	return true
}

proc update_PARAM_VALUE.PEAK_THRESHOLD { PARAM_VALUE.PEAK_THRESHOLD } {
	# Procedure called to update PEAK_THRESHOLD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PEAK_THRESHOLD { PARAM_VALUE.PEAK_THRESHOLD } {
	# Procedure called to validate PEAK_THRESHOLD
	return true
}

proc update_PARAM_VALUE.REG_GLOBAL_LIMIT { PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to update REG_GLOBAL_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_GLOBAL_LIMIT { PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to validate REG_GLOBAL_LIMIT
	return true
}


proc update_MODELPARAM_VALUE.REG_GLOBAL_LIMIT { MODELPARAM_VALUE.REG_GLOBAL_LIMIT PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_GLOBAL_LIMIT}] ${MODELPARAM_VALUE.REG_GLOBAL_LIMIT}
}

proc update_MODELPARAM_VALUE.PEAK_AVR_POINT { MODELPARAM_VALUE.PEAK_AVR_POINT PARAM_VALUE.PEAK_AVR_POINT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PEAK_AVR_POINT}] ${MODELPARAM_VALUE.PEAK_AVR_POINT}
}

proc update_MODELPARAM_VALUE.PEAK_THRESHOLD { MODELPARAM_VALUE.PEAK_THRESHOLD PARAM_VALUE.PEAK_THRESHOLD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PEAK_THRESHOLD}] ${MODELPARAM_VALUE.PEAK_THRESHOLD}
}

