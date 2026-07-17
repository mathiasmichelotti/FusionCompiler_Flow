################################################################################
# Fusion Compiler Tutorial Flow
################################################################################

################################################################################
# Search Path
################################################################################

lappend search_path ./rtl
lappend search_path ./constraints
lappend search_path ./scripts
lappend search_path ../rtl
lappend search_path ../constraints
lappend search_path ../scripts




################################################################################
# Set variables
################################################################################
set REPORT_DIR ../reports
set PR_DIR    $REPORT_DIR/pr
set SYNTH_DIR $REPORT_DIR/synth



################################################################################
# Setup
################################################################################

source ../../fc_setup/globalfoundaries12lp/fc_setup.tcl

################################################################################
# Parasitic Technology (TLU+)
################################################################################

puts ""
puts "========================================"
puts "Reading TLU+ Technology"
puts "========================================"

read_parasitic_tech \
    -tlup $TLUP_MAX \
    -name RCMAX

read_parasitic_tech \
    -tlup $TLUP_MIN \
    -name RCMIN

################################################################################
# RTL Analysis
################################################################################

puts ""
puts "========================================"
puts "RTL Analysis"
puts "========================================"

analyze -format sv pck_control.sv
analyze -format sv alu.sv
analyze -format sv alu_top.sv

################################################################################
# Elaboration
################################################################################

puts ""
puts "========================================"
puts "Elaboration"
puts "========================================"

elaborate alu_top

set_top_module alu_top

################################################################################
# Design Information
################################################################################

puts ""
puts "========================================"
puts "Design Information"
puts "========================================"

current_lib
current_block

report_design
report_hierarchy

puts ""
puts "Ports:"
get_ports *


################################################################################
# Physical Constraints
################################################################################

puts ""
puts "========================================"
puts "Reading DEF"
puts "========================================"

#read_def test.def



################################################################################
# Timing Constraints
################################################################################

puts ""
puts "========================================"
puts "Reading SDC"
puts "========================================"

###############################################################################
# MCMM
###############################################################################

create_mode functional

if {[sizeof_collection [get_corners default]] == 0} {
    create_corner default
}

create_scenario \
    -name functional_default \
    -mode functional \
    -corner default

current_scenario functional_default

read_sdc constraints.sdc
################################################################################
# Associate RC models with current timing corner
################################################################################

puts ""
puts "========================================"
puts "Assigning Parasitic Models"
puts "========================================"

set_parasitic_parameters \
    -late_spec RCMAX \
    -early_spec RCMIN

################################################################################
# Useful Reports Before Compile
################################################################################

puts ""
puts "========================================"
puts "Pre-Compile Reports"
puts "========================================"

report_clocks
report_modes
report_corners
report_ref_libs


################################################################################
# Compile
################################################################################

puts ""
puts "========================================"
puts "compile_fusion"
puts "========================================"

set_extraction_options -reference_direction horizontal

compile_fusion


report_power > ../reports/synth/power.rep
report_area > ../reports/synth/area.rep
report_timing > ../reports/synth/timing.rep



#read_def test.def
initialize_floorplan \
    -site_def unit \
    -core_utilization 0.7 \
    -core_offset 2

place_pins -self

place_opt



################################################################################
# Write Results
################################################################################

puts ""
puts "========================================"
puts "Writing Outputs"
puts "========================================"

write_verilog alu_netlist.v

write_sdc -output alu_final.sdc

write_def alu.def


puts ""
puts "========================================"
puts "Start Routing"
puts "========================================"

route_auto
route_opt


puts ""
puts "========================================"
puts "Checking Routes"
puts "========================================"
check_routes


puts ""
puts "========================================"
puts "Flow Finished Successfully, opening GUI"
puts "========================================"




report_power > ../reports/pr/power.rep
report_utilization  > ../reports/pr/area.rep
report_timing > ../reports/pr/timing.rep


gui_start