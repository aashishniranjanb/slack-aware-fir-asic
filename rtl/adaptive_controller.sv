module adaptive_controller (
    input  logic clk,
    input  logic rst,
    input  logic near_limit,
    output logic [1:0] mode
);

    always_ff @(posedge clk or posedge rst) begin
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
