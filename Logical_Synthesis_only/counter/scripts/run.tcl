source ../scripts/setup.tcl

analyze -format vhdl ../rtl/counter.vhdl

elaborate counter

set_top_module counter

read_sdc ../scripts/constraints.sdc

compile_logical

report_area
report_timing
report_power

write_verilog counter_netlist.v
write_sdc -output counter.sdc