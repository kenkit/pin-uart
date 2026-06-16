#!/bin/bash

# Automation script to create a new FPGA target directory with Makefile and config.tcl

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <part_number> [arch] [name] [iostandard]"
    echo "Example: $0 xc7z010clg400-1 zynq coraz7 LVCMOS33"
    echo "Example: $0 ice40up5k-sg48 ice40 upduino"
    exit 1
fi

PART=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# 0. Intelligent reformatting for Xilinx
if [[ "$PART" =~ ^([a-z0-9]+)-([0-9]+)([a-z]+[0-9]+)[a-z]?$ ]]; then
    PART="${BASH_REMATCH[1]}${BASH_REMATCH[3]}-${BASH_REMATCH[2]}"
fi

ARCH=$2
NAME=$3
IOSTANDARD=$4

# 1. Infer ARCH and VENDOR if not provided
if [ -z "$ARCH" ]; then
    case "$PART" in
        xc7a*)      ARCH="artix7"; VENDOR="xilinx" ;;
        xc7k*)      ARCH="kintex7"; VENDOR="xilinx" ;;
        xc7v*)      ARCH="virtex7"; VENDOR="xilinx" ;;
        xc7z*)      ARCH="zynq"; VENDOR="xilinx" ;;
        xcku*)      ARCH="kintexu"; VENDOR="xilinx" ;;
        xcvu*)      ARCH="virtexu"; VENDOR="xilinx" ;;
        xckp*)      ARCH="kintexup"; VENDOR="xilinx" ;;
        xcvp*)      ARCH="virtexup"; VENDOR="xilinx" ;;
        lfe5*)      ARCH="ecp5"; VENDOR="lattice" ;;
        ice40*)     ARCH="ice40"; VENDOR="ice40" ;;
        *)          ARCH="unknown"; VENDOR="unknown" ;;
    esac
else
    case "$ARCH" in
        artix7|kintex7|virtex7|zynq|kintexu|virtexu|kintexup|virtexup) VENDOR="xilinx" ;;
        ecp5)   VENDOR="lattice" ;;
        ice40)  VENDOR="ice40" ;;
        *)      VENDOR="unknown" ;;
    esac
fi

# 2. Use part number (sanitized) as name if not provided
if [ -z "$NAME" ]; then
    NAME=$(echo "$PART" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
fi

# 3. Default IOSTANDARD
if [ -z "$IOSTANDARD" ]; then
    if [ "$VENDOR" == "lattice" ] || [ "$VENDOR" == "ice40" ]; then
        IOSTANDARD="LVCMOS33"
    else
        IOSTANDARD="LVCMOS18"
    fi
fi

DIR="fpga_$NAME"

if [ -d "$DIR" ]; then
    echo "Error: Directory $DIR already exists."
    exit 1
fi

echo "Creating target in $DIR for part $PART (Arch: $ARCH)..."
mkdir -p "$DIR"

# 4. Create Makefile
if [ "$VENDOR" == "lattice" ]; then
    CAPACITY=$(echo "$PART" | grep -oP '\d+(?=f)' | head -n 1)
    if [ -z "$CAPACITY" ]; then CAPACITY="25"; fi
    PNR_FLAG="--${CAPACITY}k"

    RAW_PKG=$(echo "$PART" | rev | cut -d'-' -f1 | rev | grep -oP '[a-zA-Z]+[0-9]+' | head -n 1)
    if [[ "$RAW_PKG" == bg* ]]; then
        PACKAGE="CABGA${RAW_PKG#bg}"
    elif [[ "$RAW_PKG" == cabg* ]]; then
        PACKAGE="CABGA${RAW_PKG#cabg}"
    else
        PACKAGE="${RAW_PKG^^}"
    fi

    cat <<EOF > "$DIR/Makefile"
# FPGA settings
FPGA_PART = $PART
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = $ARCH
PNR_FLAG = $PNR_FLAG
PACKAGE = $PACKAGE

# Files for synthesis
SYN_FILES = ./fpga.v
SYN_FILES += ../rtl/pin_uart.v

# LPF files
LPF_FILES = ./fpga.lpf

all: \$(FPGA_TOP).bit

fpga.v fpga.lpf:
	tclsh ../generate.tcl

\$(FPGA_TOP).json: \$(SYN_FILES)
	yosys -p "synth_ecp5 -top \$(FPGA_TOP) -json \$@" \$^

\$(FPGA_TOP)_out.config: \$(FPGA_TOP).json \$(LPF_FILES)
	nextpnr-ecp5 \$(PNR_FLAG) --package \$(PACKAGE) --json \$(FPGA_TOP).json --lpf \$(LPF_FILES) --textcfg \$@

\$(FPGA_TOP).bit: \$(FPGA_TOP)_out.config
	ecppack \$< \$@

clean:
	rm -f \$(FPGA_TOP).json \$(FPGA_TOP)_out.config \$(FPGA_TOP).bit fpga.v fpga.lpf

program: \$(FPGA_TOP).bit
	openfpgaloader -b colorlight \$<
EOF

elif [ "$VENDOR" == "ice40" ]; then
    DEVICE=$(echo "$PART" | cut -d'-' -f1 | sed 's/ice40//')
    PACKAGE=$(echo "$PART" | cut -d'-' -f2)

    cat <<EOF > "$DIR/Makefile"
# FPGA settings
FPGA_PART = $PART
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = $ARCH
DEVICE = $DEVICE
PACKAGE = $PACKAGE

# Files for synthesis
SYN_FILES = ./fpga.v
SYN_FILES += ../rtl/pin_uart.v

# PCF files
PCF_FILES = ./fpga.pcf

all: \$(FPGA_TOP).bin

fpga.v fpga.pcf:
	tclsh ../generate.tcl

\$(FPGA_TOP).json: \$(SYN_FILES)
	yosys -p "synth_ice40 -top \$(FPGA_TOP) -json \$@" \$^

\$(FPGA_TOP).asc: \$(FPGA_TOP).json \$(PCF_FILES)
	/usr/bin/nextpnr-ice40 --\$(DEVICE) --package \$(PACKAGE) --json \$(FPGA_TOP).json --pcf \$(PCF_FILES) --asc \$@

\$(FPGA_TOP).bin: \$(FPGA_TOP).asc
	icepack \$< \$@

clean:
	rm -f \$(FPGA_TOP).json \$(FPGA_TOP).asc \$(FPGA_TOP).bin fpga.v fpga.pcf

program: \$(FPGA_TOP).bin
	iceprog \$<
EOF

else
    cat <<EOF > "$DIR/Makefile"
# FPGA settings
FPGA_PART = $PART
FPGA_TOP = fpga
FPGA_ARCH = $ARCH

# Files for synthesis
# Paths use ./ to prevent vivado.mk from prepending ../
SYN_FILES = ./fpga.v
SYN_FILES += ./rtl/pin_uart.v

# XDC files
XDC_FILES = ./fpga.xdc

# Configuration
CONFIG_TCL_FILES = ./config.tcl
CONFIG_TCL_FILES += ../generate.tcl

include ../common/vivado.mk

# Custom target to generate HDL/Constraints
fpga.v fpga.xdc:
	vivado -mode batch -source ../generate.tcl

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
	vivado -mode batch -source program.tcl
EOF
fi

# 5. Create config.tcl
cat <<EOF > "$DIR/config.tcl"
set iostandard "$IOSTANDARD"
EOF

echo "Done. Target created in $DIR."
echo "Run 'cd $DIR && make' to generate files and build bitstream."
