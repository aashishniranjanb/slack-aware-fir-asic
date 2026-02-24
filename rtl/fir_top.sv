module fir_top (
    input  logic clk,
    input  logic rst,
    input  logic signed [15:0] x_in,
    output logic signed [31:0] y_out
);

    // Internal signals
    logic signed [15:0] shift_data [0:31];
    logic signed [31:0] mult_data  [0:31];
    logic signed [31:0] sum_out;

    // Slack system signals
    logic [7:0] slack_value;
    logic [1:0] slack_level;
    logic [1:0] freq_mode;
    logic adaptive_clk;
    // Replica & monitoring
    logic replica_trigger;
    logic replica_done;
    logic near_limit;
    logic [1:0] adaptive_mode;

    // Estimation / reporting
`ifndef SYNTHESIS
    real v_selected;
    real power_ratio;
    real energy_ratio;
`endif

    // FIR Blocks (run on adaptive clock)
    fir_shift_reg u_shift (
        .clk(adaptive_clk),
        .rst(rst),
        .x_in(x_in),
        .x_out(shift_data)
    );

    fir_multiplier_array u_mult (
        .clk(adaptive_clk),
        .rst(rst),
        .x(shift_data),
        .h(), // coefficients may be local or parameterized
        .p_out(mult_data)
    );

    fir_adder_tree u_add (
        .clk(adaptive_clk),
        .rst(rst),
        .p_in(mult_data),
        .y_out(sum_out)
    );

    assign y_out = sum_out;

    // Slack Monitoring
    slack_sensor u_slack_sensor (
        .clk(clk),
        .rst(rst),
        .slack_value(slack_value)
    );

    slack_quantizer u_slack_quant (
        .slack_value(slack_value),
        .slack_level(slack_level)
    );

    // Replica critical path runs on the fast input clock
    slack_replica_path u_replica (
        .clk(clk),
        .rst(rst),
        .trigger(replica_trigger),
        .replica_done(replica_done)
    );

    // Monitor compares replica timing across two domains (fast and adaptive)
    slack_monitor u_monitor (
        .clk_fast(clk),
        .clk_slow(adaptive_clk),
        .rst(rst),
        .replica_done(replica_done),
        .near_limit(near_limit)
    );

    // Adaptive controller selects a safe mode based on near_limit
    adaptive_controller u_adaptive_ctrl (
        .clk(clk),
        .rst(rst),
        .near_limit(near_limit),
        .mode(adaptive_mode)
    );

    // Map adaptive mode to clock divider mode (simple passthrough)
    assign freq_mode = adaptive_mode;

    // Clock division — generate adaptive clock for FIR
    clock_divider u_div (
        .clk_in(clk),
        .rst(rst),
        .mode(freq_mode),
        .clk_out(adaptive_clk)
    );

    // Voltage scaling analytical estimator (monitoring/estimation/reporting)
`ifndef SYNTHESIS
    voltage_scaling_model u_voltage_model (
        .slack_value(slack_value),
        .f_current(200), // example MHz; replace with measured/param
        .v_selected(v_selected),
        .power_ratio(power_ratio),
        .energy_ratio(energy_ratio)
    );
`endif

endmodule
