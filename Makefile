all: sim

VLOG = \
	hdl/nBitAdder_TB.sv \
	hdl/CarryLookAheadAdder4Bit.sv \
	hdl/nBitCarryLookAheadAdder.sv

sim:
	vlib work
	vlog -source $(VLOG)

run: sim
	vsim -c

clean: 
	rm -rf work/ *.log transcript *.zip

package: clean
	zip PLong_HW1.zip * hdl/*
