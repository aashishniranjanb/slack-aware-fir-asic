module fir_multiplier_array (
    input              clk,
    input              rst,
    input  signed [511:0] x,  // 32 words of 16 bits each (flattened)
    input  signed [511:0] h,  // 32 words of 16 bits each (flattened)
    output [1023:0] p_out     // 32 words of 32 bits each (flattened)
);

    parameter TAPS    = 32;
    parameter DATA_W  = 16;
    parameter COEFF_W = 16;
    parameter PROD_W  = 32;

    // Internal arrays
    wire signed [15:0] x_arr [0:31];
    wire signed [15:0] h_arr [0:31];
    reg signed [31:0] p_out_r [0:31];
    integer i;

    // Unpack inputs
    assign x_arr[0]  = x[15:0];
    assign x_arr[1]  = x[31:16];
    assign x_arr[2]  = x[47:32];
    assign x_arr[3]  = x[63:48];
    assign x_arr[4]  = x[79:64];
    assign x_arr[5]  = x[95:80];
    assign x_arr[6]  = x[111:96];
    assign x_arr[7]  = x[127:112];
    assign x_arr[8]  = x[143:128];
    assign x_arr[9]  = x[159:144];
    assign x_arr[10] = x[175:160];
    assign x_arr[11] = x[191:176];
    assign x_arr[12] = x[207:192];
    assign x_arr[13] = x[223:208];
    assign x_arr[14] = x[239:224];
    assign x_arr[15] = x[255:240];
    assign x_arr[16] = x[271:256];
    assign x_arr[17] = x[287:272];
    assign x_arr[18] = x[303:288];
    assign x_arr[19] = x[319:304];
    assign x_arr[20] = x[335:320];
    assign x_arr[21] = x[351:336];
    assign x_arr[22] = x[367:352];
    assign x_arr[23] = x[383:368];
    assign x_arr[24] = x[399:384];
    assign x_arr[25] = x[415:400];
    assign x_arr[26] = x[431:416];
    assign x_arr[27] = x[447:432];
    assign x_arr[28] = x[463:448];
    assign x_arr[29] = x[479:464];
    assign x_arr[30] = x[495:480];
    assign x_arr[31] = x[511:496];

    assign h_arr[0]  = h[15:0];
    assign h_arr[1]  = h[31:16];
    assign h_arr[2]  = h[47:32];
    assign h_arr[3]  = h[63:48];
    assign h_arr[4]  = h[79:64];
    assign h_arr[5]  = h[95:80];
    assign h_arr[6]  = h[111:96];
    assign h_arr[7]  = h[127:112];
    assign h_arr[8]  = h[143:128];
    assign h_arr[9]  = h[159:144];
    assign h_arr[10] = h[175:160];
    assign h_arr[11] = h[191:176];
    assign h_arr[12] = h[207:192];
    assign h_arr[13] = h[223:208];
    assign h_arr[14] = h[239:224];
    assign h_arr[15] = h[255:240];
    assign h_arr[16] = h[271:256];
    assign h_arr[17] = h[287:272];
    assign h_arr[18] = h[303:288];
    assign h_arr[19] = h[319:304];
    assign h_arr[20] = h[335:320];
    assign h_arr[21] = h[351:336];
    assign h_arr[22] = h[367:352];
    assign h_arr[23] = h[383:368];
    assign h_arr[24] = h[399:384];
    assign h_arr[25] = h[415:400];
    assign h_arr[26] = h[431:416];
    assign h_arr[27] = h[447:432];
    assign h_arr[28] = h[463:448];
    assign h_arr[29] = h[479:464];
    assign h_arr[30] = h[495:480];
    assign h_arr[31] = h[511:496];

    // Multiplier array with pipeline stage for timing slack
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                p_out_r[i] <= 32'h0;
        end else begin
            for (i = 0; i < 32; i = i + 1)
                p_out_r[i] <= x_arr[i] * h_arr[i];
        end
    end

    // Pack output
    assign p_out = {p_out_r[31], p_out_r[30], p_out_r[29], p_out_r[28],
                    p_out_r[27], p_out_r[26], p_out_r[25], p_out_r[24],
                    p_out_r[23], p_out_r[22], p_out_r[21], p_out_r[20],
                    p_out_r[19], p_out_r[18], p_out_r[17], p_out_r[16],
                    p_out_r[15], p_out_r[14], p_out_r[13], p_out_r[12],
                    p_out_r[11], p_out_r[10], p_out_r[9],  p_out_r[8],
                    p_out_r[7],  p_out_r[6],  p_out_r[5],  p_out_r[4],
                    p_out_r[3],  p_out_r[2],  p_out_r[1],  p_out_r[0]};

endmodule
