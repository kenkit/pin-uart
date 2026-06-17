FPGA_PART = lfe5u-25f-6bg256c
export FPGA_PART
FPGA_TOP = fpga
FPGA_ARCH = ecp5
PNR_FLAG = --25k
PACKAGE = CABGA256

SYN_FILES = ./fpga.v
SYN_FILES += ./../../../rtl/pin_uart.v
SYN_FILES += ./../../../rtl/clock_gen.v

LPF_FILES = ./fpga.lpf

all: fpga.bit

fpga.v fpga.lpf:
	tclsh ../../../scripts/generate.tcl

fpga.json: $(SYN_FILES)
	yosys -p "read_verilog -D ARCH_ECP5 fpga.v ../../../rtl/pin_uart.v ../../../rtl/clock_gen.v; synth_ecp5 -top fpga -json $@"

fpga_out.config: fpga.json $(LPF_FILES)
	nextpnr-ecp5 --25k --package CABGA256 --json fpga.json --lpf $(LPF_FILES) --textcfg $@

fpga.bit: fpga_out.config
	ecppack $< $@

clean:
	rm -f fpga.json fpga_out.config fpga.bit fpga.v fpga.lpf

program: fpga.bit
	openfpgaloader -b colorlight $<
