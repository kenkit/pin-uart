create_project -force -part xc7a35tfgg484-1 fpga
add_files -fileset sources_1 defines.v ./fpga.v ./../../../rtl/pin_uart.v ./../../../rtl/clock_gen.v
set_property top fpga [current_fileset]
add_files -fileset constrs_1 ./fpga.xdc
source ./config.tcl
source ./../../../scripts/generate.tcl
