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
