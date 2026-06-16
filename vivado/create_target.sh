#!/bin/bash

# Automation script to create a new FPGA target directory with Makefile and config.tcl

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <part_number> [arch] [name] [iostandard]"
    echo "Example: $0 xc7z010clg400-1 zynq coraz7 LVCMOS33"
    exit 1
fi

PART=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# 0. Intelligent reformatting
# Convert commercial part number (e.g. xc7z010-1clg400c) to Vivado part (e.g. xc7z010clg400-1)
# Pattern: <device>-<speed><package><temp> -> <device><package>-<speed>
if [[ "$PART" =~ ^([a-z0-9]+)-([0-9]+)([a-z]+[0-9]+)[a-z]?$ ]]; then
    PART="${BASH_REMATCH[1]}${BASH_REMATCH[3]}-${BASH_REMATCH[2]}"
fi

ARCH=$2
NAME=$3
IOSTANDARD=$4

# 1. Infer ARCH if not provided
if [ -z "$ARCH" ]; then
    case "$PART" in
        xc7a*)  ARCH="artix7" ;;
        xc7k*)  ARCH="kintex7" ;;
        xc7v*)  ARCH="virtex7" ;;
        xc7z*)  ARCH="zynq" ;;
        xcku*)  ARCH="kintexu" ;;
        xcvu*)  ARCH="virtexu" ;;
        xckp*)  ARCH="kintexup" ;;
        xcvp*)  ARCH="virtexup" ;;
        *)      ARCH="unknown" ;;
    esac
fi

# 2. Use part number (sanitized) as name if not provided
if [ -z "$NAME" ]; then
    NAME=$(echo "$PART" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
fi

# 3. Default IOSTANDARD
if [ -z "$IOSTANDARD" ]; then
    IOSTANDARD="LVCMOS18"
fi

DIR="fpga_$NAME"

if [ -d "$DIR" ]; then
    echo "Error: Directory $DIR already exists."
    exit 1
fi

echo "Creating target in $DIR for part $PART (Arch: $ARCH)..."
mkdir -p "$DIR"

# 4. Create Makefile
cat <<EOF > "$DIR/Makefile"
# FPGA settings
FPGA_PART = $PART
FPGA_TOP = fpga
FPGA_ARCH = $ARCH

# Files for synthesis
SYN_FILES = ./fpga.v
SYN_FILES += rtl/pin_uart.v

# XDC files
XDC_FILES = ./fpga.xdc

# IP
#IP_TCL_FILES = 

# Configuration
CONFIG_TCL_FILES = ./config.tcl
CONFIG_TCL_FILES += generate.tcl

include ../common/vivado.mk

fpga.v fpga.xdc:
	touch \$@

clean::
	-rm -rf fpga.v fpga.xdc

program: \$(FPGA_TOP).bit
	echo "open_hw" > program.tcl
	echo "connect_hw_server" >> program.tcl
	echo "open_hw_target" >> program.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> program.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> program.tcl
	echo "set_property PROGRAM.FILE {\$(FPGA_TOP).bit} [current_hw_device]" >> program.tcl
	echo "program_hw_devices [current_hw_device]" >> program.tcl
	echo "exit" >> program.tcl
	vivado -nojournal -nolog -mode batch -source program.tcl
EOF

# 5. Create config.tcl
# Determine clk_src based on ARCH (7-series use STARTUPE2, US/US+ use STARTUPE3)
CLK_SRC="STARTUPE2"
CLK_FREQ="65000000"
CLK_PERIOD="10"

if [[ "$ARCH" == *u* ]] || [[ "$ARCH" == *p* ]]; then
    CLK_SRC="STARTUPE3"
    CLK_FREQ="50000000"
    CLK_PERIOD="15"
fi

cat <<EOF > "$DIR/config.tcl"
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

# clock source
# STARTUPE2, STARTUPE3, IBUFG, IBUFGDS, IBUFDS_GTE2
set clk_src "$CLK_SRC"

if {\$clk_src == "STARTUPE2"} {

    # Fcfgmclk is 65 MHz with no specified tolerance, rounding to 10 ns period

    # frequency of clock source (in Hz)
    set clk_freq "$CLK_FREQ"
    # worst-case period for timing analysis (in ns)
    set clk_period "$CLK_PERIOD"

} elseif {\$clk_src == "STARTUPE3"} {

    # Fcfgmclk is 50 MHz +/- 15%, rounding to 15 ns period

    # frequency of clock source (in Hz)
    set clk_freq "$CLK_FREQ"
    # worst-case period for timing analysis (in ns)
    set clk_period "$CLK_PERIOD"

} else {

    # clock pin
    set clk_pin {}
    # iostandard for clock pin
    set clk_iostandard "$IOSTANDARD"

    # frequency of clock source (in Hz)
    set clk_freq "50000000"
    # worst-case period for timing analysis (in ns)
    set clk_period [format "%.3f" [expr 1000000000.0 / \$clk_freq]]

}

# desired baud rate
set baud "115200"

# number of groups to shift at the same time
# more groups reduces collisions at the expense of repetition rate
set group_count "32"

# iostandard for all pins
set iostandard "$IOSTANDARD"

# pins to skip
set skip_pins_by_index {}
set skip_pins_by_name {}
EOF

chmod +x "$DIR/Makefile" # Not really needed for Makefile but good practice for scripts
echo "Done. You can now go to $DIR and run 'make'."
