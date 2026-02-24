module slack_sensor #(
    parameter integer STAGE_DELAY_NS = 2,   // estimated critical stage delay
    parameter integer CLK_PERIOD_NS  = 5
)(
    input              clk,
    input              rst,

    output reg [7:0]   slack_value   // quantified slack
);

    reg [7:0] slack_calc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            slack_calc <= 8'h0;
        else
            slack_calc <= CLK_PERIOD_NS - STAGE_DELAY_NS;
    end

    assign slack_value = slack_calc;

endmodule
