
# Root Makefile for pin-uart project

# List of all FPGA target directories
TARGETS = $(patsubst %/Makefile,%,$(wildcard build/*/*/Makefile))

.PHONY: all $(TARGETS) create clean help

all: $(TARGETS)

$(TARGETS):
	$(MAKE) -C $@

# Target to create a new FPGA project
# Usage: make create PART=<part_number> [ARCH=<arch>] [NAME=<name>] [IO=<iostandard>]
create:
	@if [ -z "$(PART)" ]; then \
		echo "Usage: make create PART=<part_number> [ARCH=<arch>] [NAME=<name>] [IO=<iostandard>]"; \
		echo "Example: make create PART=xc7z010clg400-1 ARCH=zynq NAME=coraz7 IO=LVCMOS33"; \
		exit 1; \
	fi
	./create_target.sh "$(PART)" "$(ARCH)" "$(NAME)" "$(IO)"

clean:
	for dir in $(TARGETS); do $(MAKE) -C $$dir clean; done

help:
	@echo "pin-uart project management"
	@echo ""
	@echo "Available targets:"
	@echo "  all             Build all existing FPGA targets"
	@echo "  <target_dir>    Build a specific target (e.g. make fpga_7a35t)"
	@echo "  create          Create a new target scaffolding"
	@echo "                  Required: PART=<part_number>"
	@echo "                  Optional: ARCH=<arch>, NAME=<name>, IO=<iostandard>"
	@echo "  clean           Clean all targets"
	@echo ""
	@echo "Example:"
	@echo "  make create PART=xc7z010clg400-1 NAME=coraz7 IO=LVCMOS33"
