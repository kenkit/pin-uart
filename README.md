# Pin UART Readme

GitHub repository: https://github.com/alexforencich/pin-uart

## Introduction

The pin UART is an FPGA board-level debugging and reverse-engineering utility.  The design drives pin names out of all of the IO pins on a device, which can then be probed with an oscilloscope with serial decode capability.

The build is scripted to generate the top-level HDL and pin constraint files based on the device pins.  Currently, Xilinx Vivado, Lattice ECP5, and iCE40 are supported.

## Dependencies

### Common
* **Tcl Interpreter (`tclsh`):** Used to run generation scripts.
* **Python 3:** Required for pin extraction.
* **GNU Make:** Required for the build system.

### Xilinx Vivado
* **Vivado:** Required for all Xilinx targets (synthesis, P&R, bitstream, and programming).

### Lattice ECP5 (Project Trellis)
* **Yosys:** For Verilog synthesis.
* **nextpnr-ecp5:** For placement and routing.
* **Project Trellis Database:** Required for pin extraction (`scripts/get_pins.py`). The script searches in:
    * `/usr/share/trellis/database/`
    * `~/.apio/packages/oss-cad-suite/share/trellis/database/`
* **ecppack:** For bitstream generation.
* **openfpgaloader:** (Recommended) For programming.

### Lattice iCE40 (Project IceStorm)
* **Yosys:** For Verilog synthesis.
* **nextpnr-ice40:** For placement and routing.
* **Project IceStorm (IceBox):** Database files (`chipdb-*.txt`) are required for pin extraction. The script searches in:
    * `~/.apio/packages/oss-cad-suite/share/icebox/`
* **icepack:** For bitstream generation.
* **iceprog:** For programming.

### Quick Install (Ubuntu/Debian)
```bash
# Basic dependencies
sudo apt install tcl python3 make

# Open-source FPGA tools
sudo apt install yosys nextpnr-ecp5 nextpnr-ice40 fpga-icestorm fpga-trellis openfpgaloader
```
Alternatively, the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) is a highly recommended all-in-one pre-built toolchain.

## How to build

### Creating New Projects

You can automate the creation of a new target project directory using the `create_target.sh` script or the `Makefile`. The script creates a new target in the `build/` directory (which is excluded from version control).

```bash
# Using Makefile:
make create PART=xc7a35t-1fgg484 ARCH=artix7 NAME=my_artix_board IO=LVCMOS33

# Using the script directly:
./create_target.sh <part_number> [arch] [name] [iostandard] [clk_pin] [clk_freq]
```

**Note:** If `clk_pin` and `clk_freq` are not specified, the design will attempt to use an internal oscillator (e.g. `STARTUPE3` for Xilinx, `OSCG` for ECP5, `SB_HFOSC` for iCE40).

#### Examples:

**Xilinx Artix-7**
* **Internal Clock:**
  `./create_target.sh xc7a35t-1fgg484 artix7 my_artix_board LVCMOS33`
* **External Clock (100MHz on pin E3):**
  `make create PART=xc7a35t-1fgg484 ARCH=artix7 NAME=my_artix_ext CLK_PIN=E3 CLK_FREQ=100000000`

**Lattice ECP5**
* **Internal Clock:**
  `./create_target.sh LFE5U-25F-6BG256C ecp5 my_ecp5_board LVCMOS33`
* **External Clock (25MHz on pin B1):**
  `./create_target.sh LFE5U-25F-6BG256C ecp5 my_ecp5_ext LVCMOS33 B1 25000000`

**Lattice iCE40**
* **Internal Clock:**
  `./create_target.sh ice40hx1k-tq144 ice40 my_ice40_board LVCMOS33`
* **External Clock (12MHz on pin 35):**
  `make create PART=ice40hx1k-tq144 ARCH=ice40 NAME=my_ice40_ext CLK_PIN=35 CLK_FREQ=12000000`

After creating the target, navigate to the generated directory in `build/` and run `make`:

```bash
cd build/xilinx/my_artix_board
make
```

## Documentation

### `pin_uart` module

The `pin_uart` module is a simple state machine that will shift out the configured string when triggered, including appropriate start and stop bits.
