module paridad_top #(
    parameter N         = 10,
    parameter IDX_WIDTH = 4
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             start,
    input  wire [N-1:0]     a,
    output wire             ok,
    output wire             DONE
);

    wire LD, inci, incb;
    wire a_i, Z;
    wire [IDX_WIDTH-1:0] b_debug;

    control u_control (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a_i   (a_i),
        .Z     (Z),
        .LD    (LD),
        .inci  (inci),
        .incb  (incb),
        .DONE  (DONE)
    );

    datapath #(.N(N), .IDX_WIDTH(IDX_WIDTH)) u_datapath (
        .clk     (clk),
        .a       (a),
        .LD      (LD),
        .inci    (inci),
        .incb    (incb),
        .a_i     (a_i),
        .Z       (Z),
        .ok      (ok),
        .b_debug (b_debug)
    );

endmodule
