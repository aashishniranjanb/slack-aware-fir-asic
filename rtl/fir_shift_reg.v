// Module: fir_shift_reg
// Description: 32-stage shift register using Verilog
// 
module fir_shift_reg (
    input              clk,
    input              rst,
    input  signed [15:0] x_in,
    output [511:0] x_out  // 32 words of 16 bits each (flattened)
);

    parameter TAPS   = 32;
    parameter DATA_W = 16;

    // Internal register array
    reg signed [15:0] x_out_r [0:31];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                x_out_r[i] <= 16'h0;
            end
        end else begin
            x_out_r[0] <= x_in;
            for (i = 1; i < 32; i = i + 1) begin
                x_out_r[i] <= x_out_r[i-1];
            end
        end
    end

    // Pack array into output bus
    assign x_out = {x_out_r[31], x_out_r[30], x_out_r[29], x_out_r[28],
                    x_out_r[27], x_out_r[26], x_out_r[25], x_out_r[24],
                    x_out_r[23], x_out_r[22], x_out_r[21], x_out_r[20],
                    x_out_r[19], x_out_r[18], x_out_r[17], x_out_r[16],
                    x_out_r[15], x_out_r[14], x_out_r[13], x_out_r[12],
                    x_out_r[11], x_out_r[10], x_out_r[9],  x_out_r[8],
                    x_out_r[7],  x_out_r[6],  x_out_r[5],  x_out_r[4],
                    x_out_r[3],  x_out_r[2],  x_out_r[1],  x_out_r[0]};

endmodule
