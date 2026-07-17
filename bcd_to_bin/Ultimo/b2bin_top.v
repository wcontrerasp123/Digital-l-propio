module b2bin_top (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [15:0]  a,      // BCD empacado (4 digitos)
    output wire [15:0]  bin,
    output wire         DONE
);

    wire LD, SH, LD_MSB, COMMIT;
    wire [1:0] digit_sel;
    wire SUB, Z;

    b2bin_control u_control (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .SUB        (SUB),
        .Z          (Z),
        .LD         (LD),
        .SH         (SH),
        .LD_MSB     (LD_MSB),
        .COMMIT     (COMMIT),
        .digit_sel  (digit_sel),
        .DONE       (DONE)
    );

    b2bin_datapath u_datapath (
        .clk       (clk),
        .a         (a),
        .LD        (LD),
        .SH        (SH),
        .LD_MSB    (LD_MSB),
        .COMMIT    (COMMIT),
        .digit_sel (digit_sel),
        .SUB       (SUB),
        .Z         (Z),
        .bin       (bin)
    );

endmodule
