`ifndef SYNTHESIS
module voltage_scaling_model #(
    parameter real V_NOM  = 1.0,
    parameter real V_MIN  = 0.8,
    parameter real VTH    = 0.3,
    parameter real ALPHA  = 1.3
)(
    input  logic [7:0] slack_value,
    input  logic [31:0] f_current,   // current frequency in MHz
    output real v_selected,
    output real power_ratio,
    output real energy_ratio
);

    real slack_factor;
    real v_calc;

    always_comb begin
        // Normalize slack
        slack_factor = slack_value / 5.0;

        // Voltage selection proportional to slack
        v_calc = V_NOM - (slack_factor * 0.2);

        if (v_calc < V_MIN)
            v_selected = V_MIN;
        else
            v_selected = v_calc;

        // Dynamic power scaling
        power_ratio = (v_selected * v_selected) / (V_NOM * V_NOM);

        // Energy per sample scaling (assuming throughput scaled)
        energy_ratio = power_ratio;
    end

endmodule
`endif
