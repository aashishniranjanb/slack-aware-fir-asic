module slack_monitor (
    input  logic clk_fast,
    input  logic clk_slow,
    input  logic rst,
    input  logic replica_done,
    output logic near_limit
);

    logic sample_fast;
    logic sample_slow;

    always_ff @(posedge clk_fast or posedge rst)
        if (rst)
            sample_fast <= 0;
        else
            sample_fast <= replica_done;

    always_ff @(posedge clk_slow or posedge rst)
        if (rst)
            sample_slow <= 0;
        else
            sample_slow <= replica_done;

    assign near_limit = (sample_fast != sample_slow);

endmodule
