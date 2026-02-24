# -----------------------------------------------------------------------------
# File: fir.sdc
# Description: Timing constraints for FIR filter (Cadence/Synopsys format)
# Target: 200 MHz (5.0 ns period)
# -----------------------------------------------------------------------------

# Create Clock
create_clock -name clk -period 5.0 [get_ports clk]

# Input/Output Delays (estimated for 20% margin)
set_input_delay  1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay 1.0 -clock clk [all_outputs]

# Clock Uncertainty for jitter and skew
set_clock_uncertainty 0.2 [get_clocks clk]

# Max Transition/Capacitance (typical ASIC constraints)
set_max_transition 0.5 [current_design]
set_max_capacitance 0.1 [current_design]

# Environment
set_load 0.05 [all_outputs]
