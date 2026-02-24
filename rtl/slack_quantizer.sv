module slack_quantizer #(
    parameter SAFE_TH      = 3,
    parameter WARNING_TH   = 2
)(
    input  logic [7:0] slack_value,
    output logic [1:0] slack_level
);

    always @(*) begin
        if (slack_value >= SAFE_TH)
            slack_level = 2'b00;   // SAFE
        else if (slack_value >= WARNING_TH)
            slack_level = 2'b01;   // MODERATE
        else
            slack_level = 2'b10;   // CRITICAL
    end

endmodule
