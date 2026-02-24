module clock_controller (
    input              clk,
    input              rst,
    input  [1:0]       slack_level,

    output reg [1:0]   freq_mode
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            freq_mode <= 2'b00;
        else begin
            case (slack_level)
                2'b00: freq_mode <= 2'b00; // SAFE → Highest freq
                2'b01: freq_mode <= 2'b01; // Moderate
                2'b10: freq_mode <= 2'b10; // Critical → Reduce freq
                default: freq_mode <= 2'b00;
            endcase
        end
    end

endmodule
