module fir_top (
    input              clk,
    input              rst,
    input  signed [15:0] x_in,
    output signed [39:0] y_out
);

    // Internal signals
    wire [511:0] shift_data;   // 32 x 16 bits
    wire [511:0] coeff_data;   // 32 x 16 bits - FIR coefficients
    wire [1023:0] mult_data;   // 32 x 32 bits
    wire signed [39:0] sum_out;

    // Slack system signals
    wire [7:0] slack_value;
    wire [1:0] slack_level;
    wire [1:0] freq_mode;
    wire adaptive_clk;
    // Replica & monitoring
    wire replica_trigger = 1'b1;  // Always trigger (or tie to appropriate signal)
    wire replica_done;
    wire near_limit;
    wire [1:0] adaptive_mode;
    
    // FIR Filter Coefficients (Non-Zero!)
    // Initialize with a Hamming window-like pattern for bandpass response
    // These are the 32 tap coefficients, each 16 bits (signed)
    assign coeff_data = {
        16'sd100,   // h[31]
        16'sd98,    // h[30]  
        16'sd96,    // h[29]
        16'sd92,    // h[28]
        16'sd88,    // h[27]
        16'sd82,    // h[26]
        16'sd75,    // h[25]
        16'sd67,    // h[24]
        16'sd58,    // h[23]
        16'sd48,    // h[22]
        16'sd37,    // h[21]
        16'sd25,    // h[20]
        16'sd12,    // h[19]
        16'sd0,     // h[18] - center
        -16'sd12,   // h[17]
        -16'sd25,   // h[16]
        -16'sd37,   // h[15]
        -16'sd48,   // h[14]
        -16'sd58,   // h[13]
        -16'sd67,   // h[12]
        -16'sd75,   // h[11]
        -16'sd82,   // h[10]
        -16'sd88,   // h[9]
        -16'sd92,   // h[8]
        -16'sd96,   // h[7]
        -16'sd98,   // h[6]
        -16'sd100,  // h[5]
        -16'sd98,   // h[4]
        -16'sd96,   // h[3]
        -16'sd92,   // h[2]
        -16'sd88,   // h[1]
        -16'sd82    // h[0]
    };

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
        .h(coeff_data), // Connect FIR filter coefficients
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

endmodule
