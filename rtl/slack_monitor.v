module slack_monitor (
    input              clk_fast,
    input              clk_slow,
    input              rst,
    input              replica_done,
    output             near_limit
);

    reg sample_fast;
    reg sample_slow;

    always @(posedge clk_fast or posedge rst)
        if (rst)
            sample_fast <= 1'b0;
        else
            sample_fast <= replica_done;

    always @(posedge clk_slow or posedge rst)
        if (rst)
            sample_slow <= 1'b0;
        else
            sample_slow <= replica_done;

    assign near_limit = (sample_fast != sample_slow);

endmodule
