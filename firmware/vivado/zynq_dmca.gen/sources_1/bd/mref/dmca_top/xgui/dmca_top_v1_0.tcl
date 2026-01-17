# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADC_BIT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXILITE_ADDR_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXILITE_DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXISTREAM_DATA_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "REG_GLOBAL_LIMIT" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADC_BIT { PARAM_VALUE.ADC_BIT } {
	# Procedure called to update ADC_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADC_BIT { PARAM_VALUE.ADC_BIT } {
	# Procedure called to validate ADC_BIT
	return true
}

proc update_PARAM_VALUE.AXILITE_ADDR_W { PARAM_VALUE.AXILITE_ADDR_W } {
	# Procedure called to update AXILITE_ADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXILITE_ADDR_W { PARAM_VALUE.AXILITE_ADDR_W } {
	# Procedure called to validate AXILITE_ADDR_W
	return true
}

proc update_PARAM_VALUE.AXILITE_DATA_W { PARAM_VALUE.AXILITE_DATA_W } {
	# Procedure called to update AXILITE_DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXILITE_DATA_W { PARAM_VALUE.AXILITE_DATA_W } {
	# Procedure called to validate AXILITE_DATA_W
	return true
}

proc update_PARAM_VALUE.AXISTREAM_DATA_W { PARAM_VALUE.AXISTREAM_DATA_W } {
	# Procedure called to update AXISTREAM_DATA_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXISTREAM_DATA_W { PARAM_VALUE.AXISTREAM_DATA_W } {
	# Procedure called to validate AXISTREAM_DATA_W
	return true
}

proc update_PARAM_VALUE.REG_GLOBAL_LIMIT { PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to update REG_GLOBAL_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_GLOBAL_LIMIT { PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to validate REG_GLOBAL_LIMIT
	return true
}


proc update_MODELPARAM_VALUE.AXILITE_ADDR_W { MODELPARAM_VALUE.AXILITE_ADDR_W PARAM_VALUE.AXILITE_ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXILITE_ADDR_W}] ${MODELPARAM_VALUE.AXILITE_ADDR_W}
}

proc update_MODELPARAM_VALUE.AXILITE_DATA_W { MODELPARAM_VALUE.AXILITE_DATA_W PARAM_VALUE.AXILITE_DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXILITE_DATA_W}] ${MODELPARAM_VALUE.AXILITE_DATA_W}
}

proc update_MODELPARAM_VALUE.AXISTREAM_DATA_W { MODELPARAM_VALUE.AXISTREAM_DATA_W PARAM_VALUE.AXISTREAM_DATA_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXISTREAM_DATA_W}] ${MODELPARAM_VALUE.AXISTREAM_DATA_W}
}

proc update_MODELPARAM_VALUE.REG_GLOBAL_LIMIT { MODELPARAM_VALUE.REG_GLOBAL_LIMIT PARAM_VALUE.REG_GLOBAL_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_GLOBAL_LIMIT}] ${MODELPARAM_VALUE.REG_GLOBAL_LIMIT}
}

proc update_MODELPARAM_VALUE.ADC_BIT { MODELPARAM_VALUE.ADC_BIT PARAM_VALUE.ADC_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADC_BIT}] ${MODELPARAM_VALUE.ADC_BIT}
}

