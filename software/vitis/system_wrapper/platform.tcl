# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct C:\Users\Steve\Desktop\zynq7020\vivado_prj\vitis\system_wrapper\platform.tcl
# 
# OR launch xsct and run below command.
# source C:\Users\Steve\Desktop\zynq7020\vivado_prj\vitis\system_wrapper\platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {system_wrapper}\
-hw {C:\Users\Steve\Desktop\zynq7020\vivado_prj\vitis\system_wrapper.xsa}\
-out {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis}

platform write
domain create -name {standalone_ps7_cortexa9_0} -display-name {standalone_ps7_cortexa9_0} -os {standalone} -proc {ps7_cortexa9_0} -runtime {cpp} -arch {32-bit} -support-app {hello_world}
platform generate -domains 
platform active {system_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
platform generate -quick
platform clean
platform clean
platform generate
bsp reload
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform clean
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
domain active {zynq_fsbl}
bsp reload
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
platform generate -domains 
bsp reload
domain active {zynq_fsbl}
bsp reload
bsp setlib -name openamp -ver 1.7
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains zynq_fsbl 
bsp reload
bsp reload
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
bsp reload
bsp removelib -name openamp
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains zynq_fsbl 
platform write
platform active {system_wrapper}
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp setlib -name xilffs -ver 4.8
bsp setlib -name xilrsa -ver 1.6
bsp write
bsp reload
catch {bsp regenerate}
domain active {zynq_fsbl}
bsp reload
bsp reload
platform generate -domains standalone_ps7_cortexa9_0 
platform generate
platform active {system_wrapper}
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp reload
domain active {zynq_fsbl}
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
platform generate -domains 
platform clean
platform generate
bsp reload
bsp config use_lfn "1"
bsp write
bsp reload
catch {bsp regenerate}
platform generate -domains standalone_ps7_cortexa9_0 
platform clean
platform clean
platform clean
platform generate
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
bsp reload
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
bsp reload
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
domain active {zynq_fsbl}
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform generate -domains standalone_ps7_cortexa9_0 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform active {system_wrapper}
domain active {zynq_fsbl}
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp reload
domain active {zynq_fsbl}
bsp reload
domain active {standalone_ps7_cortexa9_0}
bsp reload
bsp reload
domain active {zynq_fsbl}
bsp reload
platform active {system_wrapper}
domain active {zynq_fsbl}
bsp reload
bsp setlib -name lwip211 -ver 1.8
bsp removelib -name lwip211
bsp reload
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0,zynq_fsbl 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0,zynq_fsbl 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0,zynq_fsbl 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0 
platform generate -domains standalone_ps7_cortexa9_0 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform generate -domains zynq_fsbl 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate -domains standalone_ps7_cortexa9_0 
platform active {system_wrapper}
platform config -updatehw {C:/Users/Steve/Desktop/zynq7020/vivado_prj/vitis/system_wrapper.xsa}
platform generate
platform clean
platform clean
platform generate
platform generate
platform clean
platform generate
