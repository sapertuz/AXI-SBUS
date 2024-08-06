# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "EmergencyButton" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EmergencyChannel" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EmergencyTrigger" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EmergencyTriggerValue" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Fin" -parent ${Page_0}
  ipgui::add_param $IPINST -name "Fsbus" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusCheckValue" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusIntervallMs" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusMaxValue" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusMinValue" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusMode" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SbusParityCheck" -parent ${Page_0}


}

proc update_PARAM_VALUE.EmergencyButton { PARAM_VALUE.EmergencyButton } {
	# Procedure called to update EmergencyButton when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EmergencyButton { PARAM_VALUE.EmergencyButton } {
	# Procedure called to validate EmergencyButton
	return true
}

proc update_PARAM_VALUE.EmergencyChannel { PARAM_VALUE.EmergencyChannel } {
	# Procedure called to update EmergencyChannel when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EmergencyChannel { PARAM_VALUE.EmergencyChannel } {
	# Procedure called to validate EmergencyChannel
	return true
}

proc update_PARAM_VALUE.EmergencyTrigger { PARAM_VALUE.EmergencyTrigger } {
	# Procedure called to update EmergencyTrigger when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EmergencyTrigger { PARAM_VALUE.EmergencyTrigger } {
	# Procedure called to validate EmergencyTrigger
	return true
}

proc update_PARAM_VALUE.EmergencyTriggerValue { PARAM_VALUE.EmergencyTriggerValue } {
	# Procedure called to update EmergencyTriggerValue when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EmergencyTriggerValue { PARAM_VALUE.EmergencyTriggerValue } {
	# Procedure called to validate EmergencyTriggerValue
	return true
}

proc update_PARAM_VALUE.Fin { PARAM_VALUE.Fin } {
	# Procedure called to update Fin when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Fin { PARAM_VALUE.Fin } {
	# Procedure called to validate Fin
	return true
}

proc update_PARAM_VALUE.Fsbus { PARAM_VALUE.Fsbus } {
	# Procedure called to update Fsbus when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Fsbus { PARAM_VALUE.Fsbus } {
	# Procedure called to validate Fsbus
	return true
}

proc update_PARAM_VALUE.SbusCheckValue { PARAM_VALUE.SbusCheckValue } {
	# Procedure called to update SbusCheckValue when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusCheckValue { PARAM_VALUE.SbusCheckValue } {
	# Procedure called to validate SbusCheckValue
	return true
}

proc update_PARAM_VALUE.SbusIntervallMs { PARAM_VALUE.SbusIntervallMs } {
	# Procedure called to update SbusIntervallMs when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusIntervallMs { PARAM_VALUE.SbusIntervallMs } {
	# Procedure called to validate SbusIntervallMs
	return true
}

proc update_PARAM_VALUE.SbusMaxValue { PARAM_VALUE.SbusMaxValue } {
	# Procedure called to update SbusMaxValue when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusMaxValue { PARAM_VALUE.SbusMaxValue } {
	# Procedure called to validate SbusMaxValue
	return true
}

proc update_PARAM_VALUE.SbusMinValue { PARAM_VALUE.SbusMinValue } {
	# Procedure called to update SbusMinValue when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusMinValue { PARAM_VALUE.SbusMinValue } {
	# Procedure called to validate SbusMinValue
	return true
}

proc update_PARAM_VALUE.SbusMode { PARAM_VALUE.SbusMode } {
	# Procedure called to update SbusMode when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusMode { PARAM_VALUE.SbusMode } {
	# Procedure called to validate SbusMode
	return true
}

proc update_PARAM_VALUE.SbusParityCheck { PARAM_VALUE.SbusParityCheck } {
	# Procedure called to update SbusParityCheck when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SbusParityCheck { PARAM_VALUE.SbusParityCheck } {
	# Procedure called to validate SbusParityCheck
	return true
}


proc update_MODELPARAM_VALUE.Fin { MODELPARAM_VALUE.Fin PARAM_VALUE.Fin } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Fin}] ${MODELPARAM_VALUE.Fin}
}

proc update_MODELPARAM_VALUE.Fsbus { MODELPARAM_VALUE.Fsbus PARAM_VALUE.Fsbus } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Fsbus}] ${MODELPARAM_VALUE.Fsbus}
}

proc update_MODELPARAM_VALUE.SbusIntervallMs { MODELPARAM_VALUE.SbusIntervallMs PARAM_VALUE.SbusIntervallMs } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusIntervallMs}] ${MODELPARAM_VALUE.SbusIntervallMs}
}

proc update_MODELPARAM_VALUE.SbusMode { MODELPARAM_VALUE.SbusMode PARAM_VALUE.SbusMode } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusMode}] ${MODELPARAM_VALUE.SbusMode}
}

proc update_MODELPARAM_VALUE.SbusParityCheck { MODELPARAM_VALUE.SbusParityCheck PARAM_VALUE.SbusParityCheck } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusParityCheck}] ${MODELPARAM_VALUE.SbusParityCheck}
}

proc update_MODELPARAM_VALUE.SbusCheckValue { MODELPARAM_VALUE.SbusCheckValue PARAM_VALUE.SbusCheckValue } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusCheckValue}] ${MODELPARAM_VALUE.SbusCheckValue}
}

proc update_MODELPARAM_VALUE.SbusMinValue { MODELPARAM_VALUE.SbusMinValue PARAM_VALUE.SbusMinValue } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusMinValue}] ${MODELPARAM_VALUE.SbusMinValue}
}

proc update_MODELPARAM_VALUE.SbusMaxValue { MODELPARAM_VALUE.SbusMaxValue PARAM_VALUE.SbusMaxValue } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SbusMaxValue}] ${MODELPARAM_VALUE.SbusMaxValue}
}

proc update_MODELPARAM_VALUE.EmergencyButton { MODELPARAM_VALUE.EmergencyButton PARAM_VALUE.EmergencyButton } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EmergencyButton}] ${MODELPARAM_VALUE.EmergencyButton}
}

proc update_MODELPARAM_VALUE.EmergencyChannel { MODELPARAM_VALUE.EmergencyChannel PARAM_VALUE.EmergencyChannel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EmergencyChannel}] ${MODELPARAM_VALUE.EmergencyChannel}
}

proc update_MODELPARAM_VALUE.EmergencyTriggerValue { MODELPARAM_VALUE.EmergencyTriggerValue PARAM_VALUE.EmergencyTriggerValue } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EmergencyTriggerValue}] ${MODELPARAM_VALUE.EmergencyTriggerValue}
}

proc update_MODELPARAM_VALUE.EmergencyTrigger { MODELPARAM_VALUE.EmergencyTrigger PARAM_VALUE.EmergencyTrigger } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EmergencyTrigger}] ${MODELPARAM_VALUE.EmergencyTrigger}
}

