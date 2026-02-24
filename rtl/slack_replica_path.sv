module slack_replica_path #(
    parameter WIDTH = 16
)(
    input  logic clk,
    input  logic rst,
    input  logic trigger,
    output logic replica_done
);

    logic [WIDTH-1:0] stage1;
    logic [WIDTH-1:0] stage2;
    logic [WIDTH-1:0] stage3;

    // Delay chain mimicking multiplier + adder tree
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 0;
            stage2 <= 0;
            stage3 <= 0;
        end else begin
            stage1 <= trigger ? 16'hAAAA : stage1 + 1;
            stage2 <= stage1 ^ 16'h5555;
            stage3 <= stage2 + stage1;
        end
    end

    assign replica_done = stage3[0];

endmodule
