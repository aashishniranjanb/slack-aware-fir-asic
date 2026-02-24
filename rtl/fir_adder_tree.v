module fir_adder_tree (
    input              clk,
    input              rst,
    input  signed [1023:0] p_in,  // 32 words of 32 bits each
    output signed [39:0] y_out
);

    parameter TAPS   = 32;
    parameter PROD_W = 32;
    parameter ACC_W  = 40;

    // Unpack input array
    wire signed [31:0] p_in_arr [0:31];

    assign p_in_arr[0]  = p_in[31:0];
    assign p_in_arr[1]  = p_in[63:32];
    assign p_in_arr[2]  = p_in[95:64];
    assign p_in_arr[3]  = p_in[127:96];
    assign p_in_arr[4]  = p_in[159:128];
    assign p_in_arr[5]  = p_in[191:160];
    assign p_in_arr[6]  = p_in[223:192];
    assign p_in_arr[7]  = p_in[255:224];
    assign p_in_arr[8]  = p_in[287:256];
    assign p_in_arr[9]  = p_in[319:288];
    assign p_in_arr[10] = p_in[351:320];
    assign p_in_arr[11] = p_in[383:352];
    assign p_in_arr[12] = p_in[415:384];
    assign p_in_arr[13] = p_in[447:416];
    assign p_in_arr[14] = p_in[479:448];
    assign p_in_arr[15] = p_in[511:480];
    assign p_in_arr[16] = p_in[543:512];
    assign p_in_arr[17] = p_in[575:544];
    assign p_in_arr[18] = p_in[607:576];
    assign p_in_arr[19] = p_in[639:608];
    assign p_in_arr[20] = p_in[671:640];
    assign p_in_arr[21] = p_in[703:672];
    assign p_in_arr[22] = p_in[735:704];
    assign p_in_arr[23] = p_in[767:736];
    assign p_in_arr[24] = p_in[799:768];
    assign p_in_arr[25] = p_in[831:800];
    assign p_in_arr[26] = p_in[863:832];
    assign p_in_arr[27] = p_in[895:864];
    assign p_in_arr[28] = p_in[927:896];
    assign p_in_arr[29] = p_in[959:928];
    assign p_in_arr[30] = p_in[991:960];
    assign p_in_arr[31] = p_in[1023:992];

    // Stage 1 (32 → 16)
    reg signed [39:0] s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7;
    reg signed [39:0] s1_8, s1_9, s1_10, s1_11, s1_12, s1_13, s1_14, s1_15;

    // Stage 2 (16 → 8)
    reg signed [39:0] s2_0, s2_1, s2_2, s2_3, s2_4, s2_5, s2_6, s2_7;

    // Stage 3 (8 → 4)
    reg signed [39:0] s3_0, s3_1, s3_2, s3_3;

    // Stage 4 (4 → 2)
    reg signed [39:0] s4_0, s4_1;

    // Stage 5 (2 → 1)
    reg signed [39:0] s5;

    // ==============================
    // Stage 1
    // ==============================
    always @(posedge clk) begin
        if (rst) begin
            s1_0 <= 40'h0;  s1_1 <= 40'h0;  s1_2 <= 40'h0;  s1_3 <= 40'h0;
            s1_4 <= 40'h0;  s1_5 <= 40'h0;  s1_6 <= 40'h0;  s1_7 <= 40'h0;
            s1_8 <= 40'h0;  s1_9 <= 40'h0;  s1_10 <= 40'h0; s1_11 <= 40'h0;
            s1_12 <= 40'h0; s1_13 <= 40'h0; s1_14 <= 40'h0; s1_15 <= 40'h0;
        end else begin
            s1_0 <= $signed(p_in_arr[0]) + $signed(p_in_arr[1]);
            s1_1 <= $signed(p_in_arr[2]) + $signed(p_in_arr[3]);
            s1_2 <= $signed(p_in_arr[4]) + $signed(p_in_arr[5]);
            s1_3 <= $signed(p_in_arr[6]) + $signed(p_in_arr[7]);
            s1_4 <= $signed(p_in_arr[8]) + $signed(p_in_arr[9]);
            s1_5 <= $signed(p_in_arr[10]) + $signed(p_in_arr[11]);
            s1_6 <= $signed(p_in_arr[12]) + $signed(p_in_arr[13]);
            s1_7 <= $signed(p_in_arr[14]) + $signed(p_in_arr[15]);
            s1_8 <= $signed(p_in_arr[16]) + $signed(p_in_arr[17]);
            s1_9 <= $signed(p_in_arr[18]) + $signed(p_in_arr[19]);
            s1_10 <= $signed(p_in_arr[20]) + $signed(p_in_arr[21]);
            s1_11 <= $signed(p_in_arr[22]) + $signed(p_in_arr[23]);
            s1_12 <= $signed(p_in_arr[24]) + $signed(p_in_arr[25]);
            s1_13 <= $signed(p_in_arr[26]) + $signed(p_in_arr[27]);
            s1_14 <= $signed(p_in_arr[28]) + $signed(p_in_arr[29]);
            s1_15 <= $signed(p_in_arr[30]) + $signed(p_in_arr[31]);
        end
    end

    // ==============================
    // Stage 2
    // ==============================
    always @(posedge clk) begin
        if (rst) begin
            s2_0 <= 40'h0; s2_1 <= 40'h0; s2_2 <= 40'h0; s2_3 <= 40'h0;
            s2_4 <= 40'h0; s2_5 <= 40'h0; s2_6 <= 40'h0; s2_7 <= 40'h0;
        end else begin
            s2_0 <= s1_0 + s1_1;
            s2_1 <= s1_2 + s1_3;
            s2_2 <= s1_4 + s1_5;
            s2_3 <= s1_6 + s1_7;
            s2_4 <= s1_8 + s1_9;
            s2_5 <= s1_10 + s1_11;
            s2_6 <= s1_12 + s1_13;
            s2_7 <= s1_14 + s1_15;
        end
    end

    // ==============================
    // Stage 3
    // ==============================
    always @(posedge clk) begin
        if (rst) begin
            s3_0 <= 40'h0; s3_1 <= 40'h0; s3_2 <= 40'h0; s3_3 <= 40'h0;
        end else begin
            s3_0 <= s2_0 + s2_1;
            s3_1 <= s2_2 + s2_3;
            s3_2 <= s2_4 + s2_5;
            s3_3 <= s2_6 + s2_7;
        end
    end

    // ==============================
    // Stage 4
    // ==============================
    always @(posedge clk) begin
        if (rst) begin
            s4_0 <= 40'h0; s4_1 <= 40'h0;
        end else begin
            s4_0 <= s3_0 + s3_1;
            s4_1 <= s3_2 + s3_3;
        end
    end

    // ==============================
    // Stage 5 (Final)
    // ==============================
    always @(posedge clk) begin
        if (rst) begin
            s5 <= 40'h0;
        end else begin
            s5 <= s4_0 + s4_1;
        end
    end

    assign y_out = s5;

endmodule
