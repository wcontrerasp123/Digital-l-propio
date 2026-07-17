module bin2bcd_top #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire [N-1:0] a,
    output wire [19:0]  bcd,
    output wire         DONE
);

    wire LD, SH, LD_MSB, COMMIT;
    wire [2:0] digit_sel;
    wire ADD, Z;

    control u_control (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .ADD        (ADD),
        .Z          (Z),
        .LD         (LD),
        .SH         (SH),
        .LD_MSB     (LD_MSB),
        .COMMIT     (COMMIT),
        .digit_sel  (digit_sel),
        .DONE       (DONE)
    );

    datapath #(.N(N)) u_datapath (
        .clk       (clk),
        .a         (a),
        .LD        (LD),
        .SH        (SH),
        .LD_MSB    (LD_MSB),
        .COMMIT    (COMMIT),
        .digit_sel (digit_sel),
        .ADD       (ADD),
        .Z         (Z),
        .bcd       (bcd)
    );

endmodule
