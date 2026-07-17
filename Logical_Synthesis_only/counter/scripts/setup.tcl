###############################################################################
# Fusion Compiler - Logical Synthesis Setup
###############################################################################

###############################################################################
# Search Path
###############################################################################
set search_path [list \
    . \
    ../rtl \
    ../scripts \
    ../constraints \
    /asic/pdk/ams/AMS_410_CDS/synopsys/c35_1.8V \
    /softs/kits/ams/AMS_410_CDS/synopsys/c35_1.8V 

]

###############################################################################
# Libraries
###############################################################################
set target_library [list \
    c35_CORELIB_WC.db \
    c35_IOLIB_WC.db
]

set synthetic_library dw_foundation.sldb

set link_library [concat "*" $target_library $synthetic_library]

###############################################################################
# Non-Physical Mode
###############################################################################
set_non_physical_mode

###############################################################################
# Output Settings
###############################################################################
set sdfout_no_edge true

set hdlout_internal_busses true
set vhdlout_single_bit user
set vhdlout_preserve_hierarchical_types user

set bus_inference_style "%s_%d_"
set bus_naming_style "%s_%d"

set write_name_nets_same_as_ports true

###############################################################################
# Optional
###############################################################################
#check_library