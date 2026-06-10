.PHONY: cocotb

cocotb:
	$(MAKE) -f $(shell cocotb-config --makefiles)/Makefile.sim \
		SIM=icarus \
		WAVES=1 \
		VERILOG_SOURCES=$(PWD)/../../src/*.v \
		TOPLEVEL=top_system \
		COCOTB_TEST_MODULES=testbench