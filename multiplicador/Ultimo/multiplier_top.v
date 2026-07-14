// ============================================================
// multiplier_top.v
// Modulo TOP: une Control (FSM) y Datapath (camino de datos)
// ============================================================
module multiplier_top #(
    parameter N = 16
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             start,
    input  wire [N-1:0]     a,
    input  wire [N-1:0]     b,
    output wire [2*N-1:0]   R,
    output wire             DONE
);

    wire LD, SH, AD;
    wire b_i, Z;

    control u_control (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .b_i   (b_i),
        .Z     (Z),
        .LD    (LD),
        .SH    (SH),
        .AD    (AD),
        .DONE  (DONE)
    );

    datapath #(.N(N)) u_datapath (
        .clk (clk),
        .a   (a),
        .b   (b),
        .LD  (LD),
        .SH  (SH),
        .AD  (AD),
        .b_i (b_i),
        .Z   (Z),
        .R   (R)
    );

endmodule
