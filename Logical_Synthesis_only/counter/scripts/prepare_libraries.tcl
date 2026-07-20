################################################################################
# Generate Fusion Libraries (one-time)
################################################################################

set_lc_options \
    -exec_path /softs/synopsys/lc/X-2025.06-SP2/bin/lc_shell

generate_fusion_libs \
    -reference_db {
        h35_CORELIB_V5_WC.db
        h35_IOLIBV5_WC.db
    } \
    -output_directory ./fusion_lib