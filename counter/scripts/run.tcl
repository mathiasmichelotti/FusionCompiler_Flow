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
# Setup
################################################################################

source setup.tcl

################################################################################
# Parasitic Technology (TLU+)
################################################################################

puts ""
puts "========================================"
puts "Reading TLU+ Technology"
puts "========================================"

set TLUP_DIR \
"/asic/pdk/globalfoundries/22FDX-PLUS/V1.0_3.4/PlaceRoute/ICC/TLUPlus/10M_2Mx_4Cx_2Bx_2Jx_LBthick"

set TLUP_MAP \
"/asic/ip/DesignWare_logic_libs/globalfoundaries22nhsp/32hd116/hdl/lvt/2.00a/demo/pnr/FC/input_files/tlup/layers.map"

set TLUP_MAX \
"$TLUP_DIR/22fdsoi_10M_2Mx_4Cx_2Bx_2Jx_LBthick_FuncRCmax_detailed.tluplus"

set TLUP_MIN \
"$TLUP_DIR/22fdsoi_10M_2Mx_4Cx_2Bx_2Jx_LBthick_FuncRCmin_detailed.tluplus"

read_parasitic_tech \
    -tlup $TLUP_MAX \
    -layermap $TLUP_MAP \
    -name RCMAX

read_parasitic_tech \
    -tlup $TLUP_MIN \
    -layermap $TLUP_MAP \
    -name RCMIN

################################################################################
# RTL Analysis
################################################################################

puts ""
puts "========================================"
puts "RTL Analysis"
puts "========================================"

analyze -format vhdl counter.vhdl

################################################################################
# Elaboration
################################################################################

puts ""
puts "========================================"
puts "Elaboration"
puts "========================================"

elaborate counter

set_top_module counter

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

compile_fusion


#read_def test.def
initialize_floorplan \
    -site_def unit \
    -core_utilization 0.6 \
    -core_offset 5

place_opt


################################################################################
# Reports
################################################################################

puts ""
puts "========================================"
puts "QoR Report"
puts "========================================"

report_qor

puts ""
puts "========================================"
puts "Timing Report"
puts "========================================"

report_timing

puts ""
puts "========================================"
puts "Area Report"
puts "========================================"

report_area

puts ""
puts "========================================"
puts "Power Report"
puts "========================================"

report_power

################################################################################
# Write Results
################################################################################

puts ""
puts "========================================"
puts "Writing Outputs"
puts "========================================"

write_verilog counter_netlist.v

write_sdc -output counter_final.sdc

write_def counter.def


puts ""
puts "========================================"
puts "Start Routing"
puts "========================================"

route_auto
route_opt

extract_rc


puts ""
puts "========================================"
puts "Flow Finished Successfully, opening GUI"
puts "========================================"


gui_start