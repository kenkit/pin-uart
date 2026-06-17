FPGA_PART = ice40hx1k-tq144
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = ice40
DEVICE = hx1k
PACKAGE = tq144

SYN_FILES = ./fpga.v
SYN_FILES += ./../../../rtl/pin_uart.v
SYN_FILES += ./../../../rtl/clock_gen.v

PCF_FILES = ./fpga.pcf

all: fpga.bin

fpga.v fpga.pcf:
	tclsh ../../../scripts/generate.tcl

fpga.json: $(SYN_FILES)
	yosys -p "read_verilog -D ARCH_ICE40 fpga.v ../../../rtl/pin_uart.v ../../../rtl/clock_gen.v; synth_ice40 -top fpga -json $@"

fpga.asc: fpga.json $(PCF_FILES)
	/usr/bin/nextpnr-ice40 --hx1k --package tq144 --json fpga.json --pcf $(PCF_FILES) --asc $@

fpga.bin: fpga.asc
	icepack $< $@

clean:
	rm -f fpga.json fpga.asc fpga.bin fpga.v fpga.pcf

program: fpga.bin
	iceprog $<
