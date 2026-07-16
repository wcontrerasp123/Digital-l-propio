// ============================================================
// divisor_top.v
// Modulo TOP: une Control (FSM) y Datapath (camino de datos)
// del divisor restaurador de numeros binarios.
// ============================================================
module divisor_top #(
    parameter N         = 16,
    parameter CNT_WIDTH = 5
)(
    input  wire             clk,
    input  wire             rst,
    input  wire             start,
    input  wire [N-1:0]     a,      // dividendo
    input  wire [N-1:0]     b,      // divisor
    output wire [N-1:0]     Q,      // cociente
    output wire [N-1:0]     Rem,    // residuo
    output wire             DONE
);

    wire LDA, CO, AO, INC, LDR;
    wire MSB, Z;

    control u_control (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .MSB   (MSB),
        .Z     (Z),
        .LDA   (LDA),
        .CO    (CO),
        .AO    (AO),
        .INC   (INC),
        .LDR   (LDR),
        .DONE  (DONE)
    );

    datapath #(.N(N), .CNT_WIDTH(CNT_WIDTH)) u_datapath (
        .clk (clk),
        .a   (a),
        .b   (b),
        .LDA (LDA),
        .CO  (CO),
        .AO  (AO),
        .INC (INC),
        .LDR (LDR),
        .MSB (MSB),
        .Z   (Z),
        .Q   (Q),
        .Rem (Rem)
    );

endmodule
