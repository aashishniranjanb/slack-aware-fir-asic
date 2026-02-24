
module slack_sensor #(
	parameter integer STAGE_DELAY_NS = 2,   // estimated critical stage delay
	parameter integer CLK_PERIOD_NS  = 5
)(
	input  logic clk,
	input  logic rst,

	output logic [7:0] slack_value   // quantified slack
);

	logic [7:0] slack_calc;

	always_ff @(posedge clk or posedge rst) begin
		if (rst)
			slack_calc <= 0;
		else
			slack_calc <= CLK_PERIOD_NS - STAGE_DELAY_NS;
	end

	assign slack_value = slack_calc;

endmodule

