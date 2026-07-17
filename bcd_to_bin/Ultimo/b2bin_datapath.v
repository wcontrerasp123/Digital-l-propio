module b2bin_datapath (
    input  wire         clk,
    input  wire [15:0]  a,           
    input  wire         LD,
    input  wire         SH,
    input  wire         LD_MSB,
    input  wire         COMMIT,
    input  wire [1:0]   digit_sel,
    output wire         SUB,     
    output wire         Z,       
    output wire [15:0]  bin      
);

    wire [31:0] A;
    wire [3:0]  digito_actual;
    wire [3:0]  MSB;
    wire [4:0]  count;

    assign digito_actual = (digit_sel == 2'd0) ? A[19:16] :
                            (digit_sel == 2'd1) ? A[23:20] :
                            (digit_sel == 2'd2) ? A[27:24] :
                                                   A[31:28];

    b2bin_reg_a32 u_reg_a32 (
        .clk       (clk),
        .LD        (LD),
        .SH        (SH),
        .COMMIT    (COMMIT),
        .SUB       (SUB),
        .digit_sel (digit_sel),
        .a_in      (a),
        .A         (A)
    );

    b2bin_reg_msb u_reg_msb (
        .clk           (clk),
        .LD_MSB        (LD_MSB),
        .digito_actual (digito_actual),
        .MSB           (MSB)
    );

    assign SUB = (MSB >= 4'd8) ? 1'b1 : 1'b0;
    assign bin = A[15:0];

    b2bin_contador_i #(.WIDTH(5)) u_contador_i (
        .clk   (clk),
        .rst   (LD),
        .inc   (SH),
        .count (count)
    );

    b2bin_comparador #(.N(16), .WIDTH(5)) u_comparador (
        .count (count),
        .Z     (Z)
    );

endmodule
