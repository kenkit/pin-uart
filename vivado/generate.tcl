# Copyright (c) 2023 Alex Forencich
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if { ![info exists vendor] } {
    if { [info commands get_package_pins] != "" } {
        set vendor "xilinx"
    } else {
        set arch ""
        if {[info exists env(FPGA_ARCH)]} {
            set arch $env(FPGA_ARCH)
        } elseif {[file exists "Makefile"]} {
            set fp [open "Makefile" r]
            while {[gets $fp line] >= 0} {
                if {[regexp {^FPGA_ARCH\s*=\s*(.*)} $line -> match]} { set arch [string trim $match]; if {$arch == "ice40"} {set vendor "ice40"}
                    set arch [string trim $match]
                    break
                }
            }
            close $fp
        }
        
        if {$arch == "ecp5"} { set vendor "lattice" }
        if {$arch == "ice40"} { set vendor "ice40" }
        if {$arch == "artix7" || $arch == "kintex7" || $arch == "virtex7" || $arch == "zynq"} { set vendor "xilinx" }
    }
}

if {![info exists vendor]} { set vendor "lattice" }

if { ![info exists clk_src] } {
    if {$vendor == "lattice"} {
        set clk_src "OSCG"
    } elseif {$vendor == "ice40"} {
        set clk_src "SB_HFOSC"
    } else {
        set clk_src "STARTUPE3"
    }
}

# 2. Pin Discovery
if {$vendor == "xilinx"} {
    set_property design_mode PinPlanning [current_fileset]
    open_io_design
    set pins [get_package_pins -filter {IS_GENERAL_PURPOSE==1}]
} else {
    # Pin discovery via python script
    if {[info exists env(FPGA_PART)]} {
        set part $env(FPGA_PART)
    } elseif {[file exists "Makefile"]} {
        set fp [open "Makefile" r]
        while {[gets $fp line] >= 0} {
            if {[regexp {^FPGA_PART\s*=\s*(.*)} $line -> match]} {
                set part [string trim $match]
                break
            }
        }
        close $fp
    }

    if {![info exists part]} {
        puts "Error: FPGA_PART not set"
        exit 1
    }
    
    set pkg ""
    if {$vendor == "ice40"} {
        # Extract package for ice40
        if {[file exists "Makefile"]} {
            set fp [open "Makefile" r]
            while {[gets $fp line] >= 0} {
                if {[regexp {^PACKAGE\s*=\s*(.*)} $line -> match]} {
                    set pkg [string trim $match]
                    break
                }
            }
            close $fp
        }
    }

    set pins [exec python3 ../get_pins.py $vendor $part $pkg]
}

# sort pins by name
proc sort_bga_pins {pins} {
    foreach pin $pins {lappend pairs [list $pin [regsub {^\D\d+$} $pin {_&}]]}
    foreach pair [lsort -index 1 -dictionary $pairs] {lappend result [lindex $pair 0]}
    return $result
}

set pins [sort_bga_pins $pins]

# 3. Clock & Baud Settings
if {$clk_src == "OSCG"} {
    if { ![info exists clk_freq] } { set clk_freq "38750000" }
    if { ![info exists clk_period] } { set clk_period "25.8" }
} elseif {$clk_src == "SB_HFOSC"} {
    if { ![info exists clk_freq] } { set clk_freq "48000000" }
    if { ![info exists clk_period] } { set clk_period "20.8" }
}

if { ![info exists clk_pin] } { set clk_pin {} }
if { ![info exists clk_iostandard] } { set clk_iostandard "LVCMOS18" }
if { ![info exists clk_freq] } { set clk_freq "50000000" }
if { ![info exists clk_period] } { set clk_period [format "%.3f" [expr 1000000000.0 / $clk_freq]] }
if { ![info exists baud] } { set baud "115200" }
if { ![info exists group_count] } { set group_count "32" }
if { ![info exists iostandard] } {
    if {$vendor == "lattice" || $vendor == "ice40"} { set iostandard "LVCMOS33" } else { set iostandard "LVCMOS18" }
}

# 4. Write Verilog
set fp [open "fpga.v" w]
puts $fp "/* Generated Verilog ... */"
puts $fp "`resetall\n`timescale 1ns / 1ps\n`default_nettype none\n\nmodule fpga ("

for { set i 0 } { $i < [llength $pins] } { incr i } {
    set pin [lindex $pins $i]
    set port_name "P$pin"
    if {$vendor == "lattice" || $vendor == "xilinx"} { set port_name "P$pin" }
    
    if { $i < [expr [llength $pins]-1 ] } {
        puts $fp "    output wire $port_name,"
    } else {
        puts $fp "    output wire $port_name"
    }
}

puts $fp ");\n\nwire clk_int;"

# Primitives
if {$clk_src == "OSCG"} {
    puts $fp "// Lattice ECP5 OSCG\nwire clk_osc;\nOSCG #(.DIV(8)) osc_inst (.OSC(clk_osc));\nassign clk_int = clk_osc;"
} elseif {$clk_src == "SB_HFOSC"} {
    puts $fp "// iCE40 SB_HFOSC\nwire clk_osc;\nSB_HFOSC #(.CLKHF_DIV(\"0b00\")) hfosc_inst (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk_osc));\nassign clk_int = clk_osc;"
} elseif {$clk_src == "STARTUPE2"} {
    puts $fp "// Xilinx STARTUPE2\nwire cfgmclk;\nSTARTUPE2 startupe2_inst (.CFGMCLK(cfgmclk));\nBUFG clk_bufg_inst (.I(cfgmclk), .O(clk_int));"
} elseif {$clk_src == "STARTUPE3"} {
    puts $fp "// Xilinx STARTUPE3\nwire cfgmclk;\nSTARTUPE3 startupe3_inst (.CFGMCLK(cfgmclk));\nBUFG clk_bufg_inst (.I(cfgmclk), .O(clk_int));"
}

puts $fp "\nlocalparam CLK_FREQ = $clk_freq;\nlocalparam BAUD = $baud;\nlocalparam PIN_COUNT = [llength $pins];\nlocalparam GROUP_COUNT = $group_count;"
puts $fp "
reg shift_rst_reg = 1'b0;
reg \[31:0\] group_select_reg = 0;
reg \[GROUP_COUNT-1:0\] shift_reg = 0;
reg \[31:0\] prescale_reg = CLK_FREQ / BAUD;
reg \[5:0\] shift_count_reg = 0;

always @(posedge clk_int) begin
    shift_rst_reg <= 1'b0;
    shift_reg <= 0;
    if (prescale_reg) begin
        prescale_reg <= prescale_reg - 1;
    end else begin
        prescale_reg <= CLK_FREQ / BAUD;
        if (shift_count_reg) begin
            shift_count_reg <= shift_count_reg - 1;
            shift_reg\[group_select_reg % GROUP_COUNT\] <= 1'b1;
        end else begin
            shift_count_reg <= 6'h3f;
            shift_rst_reg <= 1'b1;
            group_select_reg <= group_select_reg + 1;
        end
    end
end
"

for { set i 0 } { $i < [llength $pins] } { incr i } {
    set pin [lindex $pins $i]
    set port_name "P$pin"
    if {$vendor == "lattice" || $vendor == "xilinx"} { set port_name "P$pin" }
    
    puts $fp "pin_uart #(.NAME(\"${pin}\")) pin_${port_name}_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg\[${i}%GROUP_COUNT\]), .out(${port_name}));"
}

puts $fp "\nendmodule\n`resetall"
close $fp

# 5. Write Constraints
if {$vendor == "lattice"} {
    set fp [open "fpga.lpf" w]
    puts $fp "BLOCK ASYNC;\nBLOCK RESETPATHS;\nFREQUENCY NET \"clk_int\" $clk_freq Hz;"
    foreach pin $pins {
        puts $fp "LOCATE COMP \"P$pin\" SITE \"$pin\";\nIOBUF PORT \"P$pin\" IO_TYPE=$iostandard;"
    }
    close $fp
} elseif {$vendor == "ice40"} {
    set fp [open "fpga.pcf" w]
    foreach pin $pins {
        puts $fp "set_io P$pin $pin"
    }
    close $fp


} else {
    set fp [open "fpga.xdc" w]
    puts $fp "# Xilinx Constraints"
    foreach pin $pins {
        puts $fp "set_property -dict {LOC $pin IOSTANDARD $iostandard} \[get_ports P$pin\]"
    }
    close $fp
    close_design
    set_property design_mode RTL [current_fileset]
}
