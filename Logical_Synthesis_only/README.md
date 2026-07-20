# Fusion Compiler – Non-Physical Logical Synthesis Example

This directory contains an example flow for **non-physical logical synthesis** using **Synopsys Fusion Compiler**.

The example includes a simple VHDL counter together with the Tcl scripts required to perform RTL analysis, elaboration, constraint loading, and logical synthesis.

## Directory Structure

- `rtl/` – RTL source files
- `constraints/` – Timing constraints (SDC)
- `scripts/` – Tcl scripts used to run the synthesis flow
- `work/` – Generated outputs, reports, and intermediate files

## Current Status

The synthesis flow works correctly with **PDKs that provide Fusion Compiler-compatible NDM libraries**.

However, older PDKs (such as AMS H35) only provide **Liberty (.db)** libraries and do not include **NDM (Fusion Library)** reference libraries.

Although Fusion Compiler provides the `generate_fusion_libs` utility to generate Fusion libraries from Liberty databases, the generated libraries could not be successfully integrated into the non-physical synthesis flow. As a result, `compile_logical` still requires a valid NDM reference library.

For this reason, this example is currently expected to work only with **newer PDKs that already provide NDM libraries**.

## Notes

- This example targets **logical synthesis only**.
- Physical implementation (floorplanning, placement, CTS, routing, etc.) is **not** included.
- The Tcl scripts can be used as a starting point for Fusion Compiler logical synthesis flows with compatible PDKs.