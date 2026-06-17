#!/bin/bash

show_help() {
    echo "Usage: $0 [OPTIONS] <part_number> [arch] [name] [iostandard] [clk_pin] [clk_freq]"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit."
    echo
    echo "Arguments:"
    echo "  part_number   Target FPGA part (e.g., xc7a35t-1fgg484, LFE5U-25F-6BG256C)"
    echo "  arch          FPGA architecture (optional)"
    echo "  name          Project name (optional)"
    echo "  iostandard    I/O standard (optional)"
    echo "  clk_pin       External clock pin (optional)"
    echo "  clk_freq      External clock frequency in Hz (optional)"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [ "$#" -lt 1 ]; then
    show_help
    exit 1
fi

PART=$(echo "$1" | tr '[:upper:]' '[:lower:]')

if [[ "$PART" =~ ^([a-z0-9]+)-([0-9]+)([a-z]+[0-9]+)[a-z]?$ ]]; then
    PART="${BASH_REMATCH[1]}${BASH_REMATCH[3]}-${BASH_REMATCH[2]}"
fi

ARCH=$2
NAME=$3
IOSTANDARD=$4
CLK_PIN=$5
CLK_FREQ=$6

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

if [ -z "$NAME" ]; then
    NAME=$(echo "$PART" | tr '-' '_' | tr '[:upper:]' '[:lower:]')
fi

if [ -z "$IOSTANDARD" ]; then
    if [ "$VENDOR" == "lattice" ] || [ "$VENDOR" == "ice40" ]; then
        IOSTANDARD="LVCMOS33"
    else
        IOSTANDARD="LVCMOS18"
    fi
fi

DIR="targets/${VENDOR}/$NAME"

if [ -d "$DIR" ]; then
    echo "Error: Directory $DIR already exists."
    exit 1
fi

echo "Creating target in $DIR for part $PART (Arch: $ARCH)..."
mkdir -p "$DIR"

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

    cat <<'EOF' > "$DIR/Makefile"
FPGA_PART = $(PART)
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = $(ARCH)
PNR_FLAG = $(PNR_FLAG)
PACKAGE = $(PACKAGE)

SYN_FILES = ./fpga.v
SYN_FILES += ./../../../rtl/pin_uart.v
SYN_FILES += ./../../../rtl/clock_gen.v

LPF_FILES = ./fpga.lpf

all: $(FPGA_TOP).bit

fpga.v fpga.lpf:
	tclsh ../../../scripts/generate.tcl

$(FPGA_TOP).json: $(SYN_FILES)
	yosys -p "read_verilog -D ARCH_ECP5 fpga.v ../../../rtl/pin_uart.v ../../../rtl/clock_gen.v; synth_ecp5 -top $(FPGA_TOP) -json $@"

$(FPGA_TOP)_out.config: $(FPGA_TOP).json $(LPF_FILES)
	nextpnr-ecp5 $(PNR_FLAG) --package $(PACKAGE) --json $(FPGA_TOP).json --lpf $(LPF_FILES) --textcfg $@

$(FPGA_TOP).bit: $(FPGA_TOP)_out.config
	ecppack $< $@

clean:
	rm -f $(FPGA_TOP).json $(FPGA_TOP)_out.config $(FPGA_TOP).bit fpga.v fpga.lpf

program: $(FPGA_TOP).bit
	openfpgaloader -b colorlight $<
EOF
    sed -i "s/\$(PART)/$PART/g" "$DIR/Makefile"
    sed -i "s/\$(ARCH)/$ARCH/g" "$DIR/Makefile"
    sed -i "s/\$(PNR_FLAG)/$PNR_FLAG/g" "$DIR/Makefile"
    sed -i "s/\$(PACKAGE)/$PACKAGE/g" "$DIR/Makefile"
    sed -i "s/\$(FPGA_TOP)/fpga/g" "$DIR/Makefile"

elif [ "$VENDOR" == "ice40" ]; then
    DEVICE=$(echo "$PART" | cut -d'-' -f1 | sed 's/ice40//')
    PACKAGE=$(echo "$PART" | cut -d'-' -f2)

    cat <<'EOF' > "$DIR/Makefile"
FPGA_PART = $(PART)
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = $(ARCH)
DEVICE = $(DEVICE)
PACKAGE = $(PACKAGE)

SYN_FILES = ./fpga.v
SYN_FILES += ./../../../rtl/pin_uart.v
SYN_FILES += ./../../../rtl/clock_gen.v

PCF_FILES = ./fpga.pcf

all: $(FPGA_TOP).bin

fpga.v fpga.pcf:
	tclsh ../../../scripts/generate.tcl

$(FPGA_TOP).json: $(SYN_FILES)
	yosys -p "read_verilog -D ARCH_ICE40 fpga.v ../../../rtl/pin_uart.v ../../../rtl/clock_gen.v; synth_ice40 -top $(FPGA_TOP) -json $@"

$(FPGA_TOP).asc: $(FPGA_TOP).json $(PCF_FILES)
	/usr/bin/nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $(FPGA_TOP).json --pcf $(PCF_FILES) --asc $@

$(FPGA_TOP).bin: $(FPGA_TOP).asc
	icepack $< $@

clean:
	rm -f $(FPGA_TOP).json $(FPGA_TOP).asc $(FPGA_TOP).bin fpga.v fpga.pcf

program: $(FPGA_TOP).bin
	iceprog $<
EOF
    sed -i "s/\$(PART)/$PART/g" "$DIR/Makefile"
    sed -i "s/\$(ARCH)/$ARCH/g" "$DIR/Makefile"
    sed -i "s/\$(DEVICE)/$DEVICE/g" "$DIR/Makefile"
    sed -i "s/\$(PACKAGE)/$PACKAGE/g" "$DIR/Makefile"
    sed -i "s/\$(FPGA_TOP)/fpga/g" "$DIR/Makefile"

else
    cat <<'EOF' > "$DIR/Makefile"
FPGA_PART = $(PART)
FPGA_TOP = fpga
FPGA_ARCH = $(ARCH)

SYN_FILES = ./fpga.v
SYN_FILES += ./../../../rtl/pin_uart.v
SYN_FILES += ./../../../rtl/clock_gen.v

XDC_FILES = ./fpga.xdc

CONFIG_TCL_FILES = ./config.tcl
CONFIG_TCL_FILES += ./../../../scripts/generate.tcl

include ../../xilinx/common/vivado.mk

fpga.v fpga.xdc:
	vivado -mode batch -source ../../../scripts/generate.tcl

clean::
	-rm -rf fpga.v fpga.xdc

program: $(FPGA_TOP).bit
	echo "open_hw" > program.tcl
	echo "connect_hw_server" >> program.tcl
	echo "open_hw_target" >> program.tcl
	echo "current_hw_device [lindex [get_hw_devices] 0]" >> program.tcl
	echo "refresh_hw_device -update_hw_probes false [current_hw_device]" >> program.tcl
	echo "set_property PROGRAM.FILE {$(FPGA_TOP).bit} [current_hw_device]" >> program.tcl
	echo "program_hw_devices [current_hw_device]" >> program.tcl
	echo "exit" >> program.tcl
	vivado -mode batch -source program.tcl
EOF
    sed -i "s/\$(PART)/$PART/g" "$DIR/Makefile"
    sed -i "s/\$(ARCH)/$ARCH/g" "$DIR/Makefile"
    sed -i "s/\$(FPGA_TOP)/fpga/g" "$DIR/Makefile"
fi

CLK_SRC="STARTUPE2"
if [[ "$ARCH" == *u* ]] || [[ "$ARCH" == *p* ]]; then
    CLK_SRC="STARTUPE3"
fi

cat <<EOF > "$DIR/config.tcl"
set iostandard "$IOSTANDARD"
set clk_pin "$CLK_PIN"
set clk_freq "$CLK_FREQ"
set clk_iostandard "$IOSTANDARD"
EOF

echo "Done. Target created in $DIR."
echo "Run 'cd $DIR && make' to generate files and build bitstream."
