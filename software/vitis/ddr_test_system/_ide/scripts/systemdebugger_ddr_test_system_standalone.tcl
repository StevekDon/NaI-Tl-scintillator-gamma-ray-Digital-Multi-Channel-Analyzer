# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\Users\Steve\Desktop\zynq7020\vivado_prj\vitis\ddr_test_system\_ide\scripts\systemdebugger_ddr_test_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\Users\Steve\Desktop\zynq7020\vivado_prj\vitis\ddr_test_system\_ide\scripts\systemdebugger_ddr_test_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "my vendor co my board 0ABC01A" && level==0 && jtag_device_ctx=="jsn-my board-0ABC01A-23727093-0"}
fpga -file C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/ddr_test/_ide/bitstream/system_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper/export/system_wrapper/hw/system_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/ddr_test/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/ddr_test/Debug/ddr_test.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
