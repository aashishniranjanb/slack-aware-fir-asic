module clock_divider (
    input  logic clk_in,
    input  logic rst,
    input  logic [1:0] mode,
    output logic clk_out
);

    logic [2:0] counter;

    always_ff @(posedge clk_in or posedge rst) begin
        if (rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @(*) begin
        case (mode)
            2'b00: clk_out = clk_in;          // full speed
            2'b01: clk_out = counter[0];      // /2
            2'b10: clk_out = counter[1];      // /4
            default: clk_out = clk_in;
        endcase
    end

endmodule
