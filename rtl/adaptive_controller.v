module adaptive_controller (
    input              clk,
    input              rst,
    input              near_limit,
    output reg [1:0]   mode
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            mode <= 2'b00;
        else begin
            if (near_limit)
                mode <= 2'b10;  // reduce frequency
            else
                mode <= 2'b00;  // max frequency
        end
    end

endmodule
