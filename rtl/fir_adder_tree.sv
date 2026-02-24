module fir_adder_tree
import fir_pkg::*;
(
    input  logic clk,
    input  logic rst,

    input  logic signed [PROD_W-1:0] p_in [TAPS],
    output logic signed [ACC_W-1:0]  y_out
);

    // Stage 1 (32 → 16)
    logic signed [ACC_W-1:0] s1 [TAPS/2];

    // Stage 2 (16 → 8)
    logic signed [ACC_W-1:0] s2 [TAPS/4];

    // Stage 3 (8 → 4)
    logic signed [ACC_W-1:0] s3 [TAPS/8];

    // Stage 4 (4 → 2)
    logic signed [ACC_W-1:0] s4 [TAPS/16];

    // Stage 5 (2 → 1)
    logic signed [ACC_W-1:0] s5;

    // ==============================
    // Stage 1
    // ==============================
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i=0; i<TAPS/2; i++)
                s1[i] <= '0;
        end else begin
            for (int i=0; i<TAPS/2; i++)
                s1[i] <= $signed(p_in[2*i]) + $signed(p_in[2*i+1]);
        end
    end

    // ==============================
    // Stage 2
    // ==============================
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i=0; i<TAPS/4; i++)
                s2[i] <= '0;
        end else begin
            for (int i=0; i<TAPS/4; i++)
                s2[i] <= s1[2*i] + s1[2*i+1];
        end
    end

    // ==============================
    // Stage 3
    // ==============================
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i=0; i<TAPS/8; i++)
                s3[i] <= '0;
        end else begin
            for (int i=0; i<TAPS/8; i++)
                s3[i] <= s2[2*i] + s2[2*i+1];
        end
    end

    // ==============================
    // Stage 4
    // ==============================
    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i=0; i<TAPS/16; i++)
                s4[i] <= '0;
        end else begin
            for (int i=0; i<TAPS/16; i++)
                s4[i] <= s3[2*i] + s3[2*i+1];
        end
    end

    // ==============================
    // Stage 5 (Final)
    // ==============================
    always_ff @(posedge clk) begin
        if (rst)
            s5 <= '0;
        else
            s5 <= s4[0] + s4[1];
    end

    // Output register
    always_ff @(posedge clk) begin
        if (rst)
            y_out <= '0;
        else
            y_out <= s5;
    end

endmodule : fir_adder_tree
