# Pin UART for Vivado

## Introduction

This variant of the pin UART supports Vivado.  The build process uses a TCL script to extract a list of device GPIO pins and write out the top-level HDL and constraints files, as a result no external pinout files are required.

The clock source can be either the internal configuration ring oscillator via STARTUPE2/STARTUPE3, or an external single-ended or differential oscillator.

## How to build

Set the target part in the `Makefile`, and adjust other settings as appropriate in `config.tcl`.  Then, run `make` to build.  Ensure that the Xilinx Vivado toolchain components are in PATH.

## Creating New Projects

You can automate the creation of a new target project directory using the `create_target.sh` script.

```bash
# Usage:
./create_target.sh <part_number> [arch] [name] [iostandard]

# Examples:
# Xilinx:
./create_target.sh xc7z010clg400-1 zynq coraz7 LVCMOS33

# ECP5 (e.g. Colorlight):
./create_target.sh LFE5U-25F-6BG256C ecp5 colorlight LVCMOS33

# iCE40 (e.g. IceStick):
./create_target.sh ice40hx1k-tq144 ice40 icestick LVCMOS33
```

This will create a new directory (e.g., `fpga_colorlight/`), generate the necessary `Makefile` and `config.tcl`, and prepare the environment for building.


## How to run

Run `make program` to program the target board with Vivado.  Then, probe IO pins with an oscilloscope with serial decode capability.  The baud rate may not be completely accurate when running off of an internal oscillator (i.e. STARTUPE3) so the decoder on the scope may need to be set to use a non-standard baud rate, and the rate may vary from part to part and with device temperature.
