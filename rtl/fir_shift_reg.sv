// -----------------------------------------------------------------------------
// Module: fir_shift_reg
// Description: 32-stage shift register using SystemVerilog logic and arrays.
// -----------------------------------------------------------------------------

module fir_shift_reg
import fir_pkg::*;
(
    input  logic              clk,
    input  logic              rst,
    input  logic signed [DATA_W-1:0] x_in,
    output logic signed [DATA_W-1:0] x_out [TAPS]
);

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < TAPS; i++) begin
                x_out[i] <= '0;
            end
        end else begin
            x_out[0] <= x_in;
            for (int i = 1; i < TAPS; i++) begin
                x_out[i] <= x_out[i-1];
            end
        end
    end

endmodule : fir_shift_reg
