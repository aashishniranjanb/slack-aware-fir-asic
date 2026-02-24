module fir_multiplier_array 
import fir_pkg::*;
(
    input  logic              clk,
    input  logic              rst,
    input  logic signed [DATA_W-1:0]  x [TAPS],
    input  logic signed [COEFF_W-1:0] h [TAPS],
    output logic signed [PROD_W-1:0]  p_out [TAPS]
);

    // Multiplier array with pipeline stage for timing slack
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < TAPS; i++)
                p_out[i] <= '0;
        end else begin
            for (int i = 0; i < TAPS; i++)
                p_out[i] <= x[i] * h[i];
        end
    end

endmodule : fir_multiplier_array
