`timescale 1ns/1ps

module fir_tb;
    import fir_pkg::*;

    logic                     clk;
    logic                     rst;
    logic signed [DATA_W-1:0] x_in;
    logic signed [ACC_W-1:0]  y_out;

    // FIR Top level instance
    fir_top uut (
        .clk  (clk),
        .rst  (rst),
        .x_in (x_in),
        .y_out(y_out)
    );

    // Clock Generation (200 MHz -> 5ns period)
    initial begin
        clk = 0;
        forever #2.5 clk = ~clk;
    end

    // Test Procedure
    initial begin
        // Initialize
        rst = 1; 
        x_in = '0;

        // Reset Sequence
        #20;
        @(posedge clk);
        rst = 0;

        // Apply Impulse
        #10;
        @(posedge clk);
        x_in = 16'sd1;
        @(posedge clk);
        x_in = 16'sd0;

        // Latency is 7 cycles:
        // 1 (Shift) -> 1 (Mult) -> 5 (Adder Tree) = 7 cycles
        repeat (50) @(posedge clk);

        // Apply Step
        $display("Applying Step Input...");
        x_in = 16'sd1;
        repeat (100) @(posedge clk);

        $display("SystemVerilog FIR ASIC-Ready Test Complete");
        $finish;
    end


    // Monitoring
    always @(posedge clk) begin
        if (!rst)
            $display("Time=%0t | x_in=%d | y_out=%d", $time, x_in, y_out);
    end

endmodule
