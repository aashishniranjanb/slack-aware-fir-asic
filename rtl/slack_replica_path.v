module slack_replica_path #(
    parameter WIDTH = 16
)(
    input              clk,
    input              rst,
    input              trigger,
    output reg         replica_done
);

    reg [WIDTH-1:0] stage1;
    reg [WIDTH-1:0] stage2;
    reg [WIDTH-1:0] stage3;

    // Delay chain mimicking multiplier + adder tree
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= {WIDTH{1'b0}};
            stage2 <= {WIDTH{1'b0}};
            stage3 <= {WIDTH{1'b0}};
        end else begin
            stage1 <= trigger ? 16'hAAAA : stage1 + 1;
            stage2 <= stage1 ^ 16'h5555;
            stage3 <= stage2 + stage1;
        end
    end

    assign replica_done = stage3[0];

endmodule
