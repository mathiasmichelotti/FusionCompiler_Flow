# FusionCompiler_Flow
A complete Synopsys Fusion Compiler flow, including library setup, synthesis, floorplanning, placement, routing, timing analysis, and report generation.

# Standard Cell Libraries

Before running a physical design flow in Fusion Compiler, it is important to understand the different library formats used throughout the implementation process.

## Technology File (.tf)

The **Technology File (.tf)** describes the fabrication process and routing technology.

It contains information such as:

- Routing layers (M1, M2, M3, ...)
- Via definitions
- Design rules
- Default routing directions
- Site definitions
- Manufacturing grid

Fusion Compiler uses this file to build the technology database and create the physical workspace.

---

## Liberty Library (.lib / .db)

The Liberty library contains the **logical and timing characterization** of every standard cell.

Each cell includes information such as:

- Boolean functionality
- Pin directions
- Input capacitance
- Output drive strength
- Propagation delays
- Setup and hold times
- Internal power
- Leakage power

Although the original format is **.lib**, Synopsys tools generally use the compiled binary version (**.db**) for faster loading.

---

## Frame Library (.ndm)

The Frame NDM contains the **physical description** of the standard cells.

It provides:

- Cell dimensions
- Cell boundaries
- Pin locations
- Obstructions
- Placement information

Unlike Liberty files, it does **not** contain timing information.

---

## Timing NDM

Fusion Compiler combines the physical information from the Frame NDM with the timing information from the Liberty databases to create a **Timing NDM**.

This unified database allows the tool to access both logical and physical information from a single library.

---

## TLU+ Files

TLU+ files contain **parasitic technology models**.

Instead of describing the standard cells, they describe how the **interconnect** behaves after routing.

Fusion Compiler uses them to estimate:

- Wire resistance (R)
- Wire capacitance (C)
- Interconnect delay

Typically two models are loaded:

- **RCMAX** → worst-case interconnect delays (used for setup analysis)
- **RCMIN** → best-case interconnect delays (used for hold analysis)

These models are associated with timing corners using:

```tcl
set_parasitic_parameters \
    -late_spec RCMAX \
    -early_spec RCMIN
```

---

## Layer Map (layers.map)

The TLU+ files use the layer names defined by the foundry extraction flow, while Fusion Compiler uses the names defined in the technology database.

The **layers.map** file maps both naming conventions.

Example:

```
TLU+      Fusion Compiler
M1   -->  M1
M2   -->  M2
M3   -->  M3
```

Without this mapping, Fusion Compiler cannot associate the parasitic models with the routing layers.

---

## Summary

| File | Purpose |
|------|---------|
| **.tf** | Technology and routing rules |
| **.lib / .db** | Timing, power and logical description of cells |
| **Frame .ndm** | Physical layout of cells |
| **Timing .ndm** | Combined physical and timing library used by Fusion Compiler |
| **TLU+** | Interconnect parasitic models (R and C) |
| **layers.map** | Maps TLU+ layer names to technology layer names |



## Current Progress

Below is a summary of the technologies currently tested with Fusion Compiler.

| Technology | Status | Notes |
|------------|--------|-------|
| **GlobalFoundries 22nm** | ✅ Fully working | All required files are available. The Fusion Compiler libraries (NDM) must be generated before running the flow. |
| **GlobalFoundries 12LP** | ✅ Fully working | All required files are available. The Fusion Compiler libraries (NDM) must be generated before running the flow. |
| **Intel 18A GLP** | ⚠️ Partially working | Intel provides the required NDM libraries, so there is no need to generate them. However, the PDK does not include TLU+ files, making the physical synthesis flow incomplete. |
| **Samsung 08nv** | ⚠️ Partially working | The Fusion Compiler libraries (NDM) must be generated before running the flow. In addition, the PDK does not include TLU+ files, making the physical synthesis flow incomplete. |
| **Older technologies (AMS 0.35 µm, AMS 0.18 µm, etc.)** | ❌ Not supported for physical synthesis | These PDKs do not provide the required TLU+, technology (`.tf`), or `frame_only.ndm` files, making physical synthesis impossible in Fusion Compiler. |

### Logical Synthesis Only

Logical synthesis using only Liberty (`.db`) libraries has been investigated, and the corresponding Tcl scripts are available in the `Logical_Synthesis_only` directory as a starting point.

However, Fusion Compiler still expects Fusion-compatible reference libraries (NDM) during `compile_logical`. Although `generate_fusion_libs` can generate Fusion libraries from Liberty databases, this flow is not yet fully functional for legacy PDKs. Consequently, logical synthesis is currently considered experimental for older technologies.

