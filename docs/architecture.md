# 32-Tap ASIC-Ready FIR Filter Architecture (Refined)

## Overview
This FIR filter is designed for professional ASIC implementation, featuring a fully pipelined 7-stage architecture to maximize timing slack and throughput. It uses 40-bit internal precision to prevent overflow during large summation operations.

## Directory Structure
The project follows standard ASIC industrial organization:
```text
slack_aware_fir/
├── rtl/                # Synthesizable SystemVerilog
├── tb/                 # SystemVerilog Testbench
├── constraints/        # SDC Timing Constraints (200 MHz)
├── scripts/            # Tool automation scripts
├── reports/            # Synthesis & Timing outputs
├── sim/                # Simulation logs and waveforms
└── docs/               # Architecture and Paper drafts
```

## Functional Decomposition
- **`fir_pkg`**: Global parameters (`ACC_W=40`, `TAPS=32`).
- **`fir_shift_reg`**: 32-stage registered delay line.
- **`fir_multiplier_array`**: **Pipelined** multiplier stage using synchronous registers.
- **`fir_adder_tree`**: **5-stage fully pipelined** binary reduction tree.

## Latency Breakdown
The design features a total latency of **7 clock cycles**:
1. **Shift Register**: 1 cycle.
2. **Multiplier Pipeline**: 1 cycle.
3. **Adder Tree Stages**: 5 cycles.
Total: 7 cycles.

## Interface
| Signal | Width | Direction | Description |
|---|---|---|---|
| `clk` | 1 | Input | 200 MHz System Clock |
| `rst` | 1 | Input | Sync Reset (Active High) |
| `x_in` | 16 | Input | Signed Input Data |
| `y_out` | 40 | Output | Filtered Output (Extended Precision) |

## Implementation for Research
The pipelined structure is ideal for **Slack Monitoring** and **Canary Flip-Flop** insertion, as each functional boundary is isolated by registers, providing clear measurement points for timing margin analysis.
