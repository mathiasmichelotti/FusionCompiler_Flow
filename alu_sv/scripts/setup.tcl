################################################################################
# GlobalFoundries 22nm - Fusion Compiler Setup
################################################################################

################################################################################
# Library paths
################################################################################

set LIB_DIR "/asic/ip/DesignWare_logic_libs/globalfoundaries22nhsp/32hd116/hdl/lvt/2.00a"

################################################################################
# Technology file
################################################################################

set TECH_FILE \
"$LIB_DIR/ndm/tf/gf22nspllogl32hdl116f_7M_2Mx_4Cx_1Ox_LB.tf"

################################################################################
# Reference library (generated with Library Manager)
################################################################################

# Use YOUR generated NDM
set REF_LIB "../../counter/work/gf22nspllogl32hdl116f_frame_timing_ccs.ndm"

# Alternatively:
# set REF_LIB "$LIB_DIR/ndm/gf22nspllogl32hdl116f_frame_timing_ccs.ndm"

################################################################################
# Check files
################################################################################

if {![file exists $TECH_FILE]} {
    error "Technology file not found:\n$TECH_FILE"
}

if {![file exists $REF_LIB]} {
    error "Reference library not found:\n$REF_LIB"
}

################################################################################
# Print configuration
################################################################################

puts ""
puts "===================================================="
puts "Fusion Compiler Setup"
puts "===================================================="
puts "Technology file : $TECH_FILE"
puts "Reference NDM   : $REF_LIB"
puts "===================================================="
puts ""

################################################################################
# Create design library
################################################################################

create_lib work \
    -technology $TECH_FILE \
    -ref_libs $REF_LIB

################################################################################
# Library information
################################################################################

puts ""
puts "Current library"
puts "---------------"
current_lib

puts ""
puts "Reference libraries"
puts "-------------------"
report_ref_libs

puts ""
puts "Site definitions"
puts "----------------"
report_site_defs

puts ""
puts "Number of library cells"
puts "-----------------------"
puts [sizeof_collection [get_lib_cells */*/frame]]

puts ""
puts "Example inverter cells"
puts "----------------------"
get_lib_cells *INV*

puts ""
puts "Example buffer cells"
puts "--------------------"
get_lib_cells *BUF*

puts ""
puts "Example AND cells"
puts "-----------------"
get_lib_cells *AND*

puts ""
puts "Example XOR cells"
puts "-----------------"
get_lib_cells *XOR*

puts ""
puts "===================================================="
puts "Setup completed successfully."
puts "===================================================="