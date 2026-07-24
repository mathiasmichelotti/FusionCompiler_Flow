################################################################################
# Search path
################################################################################

set search_path [list \
    ../rtl \
    ../constraints \
    /asic/pdk/ams/AMS_410_CDS/synopsys/h35v5_3.0V \
]

################################################################################
# Libraries
################################################################################

set synthetic_library dw_foundation.sldb

set target_library {
    h35_CORELIB_V5_WC.db
    h35_IOLIBV5_WC.db
}

set link_library "* $target_library $synthetic_library"

################################################################################
# Use generated Fusion libraries
################################################################################

set_ref_libs \
    -ref_libs {
        ./fusion_lib/flibs/h35_CORELIB_V5_WC
        ./fusion_lib/flibs/h35_IOLIBV5_WC
    }

################################################################################
# Non Physical Mode
################################################################################

set_non_physical_mode

################################################################################
# Output formatting
################################################################################

set_app_options -name file.verilog.output_v2001 -value true
set_app_options -name file.verilog.output_latch_primitives -value false