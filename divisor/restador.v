// ============================================================
// restador.v
// Restador en complemento a 2: calcula R - B.
// MSB = 1 si R < B (hubo "prestamo", resultado negativo)
// MSB = 0 si R >= B (resta valida, se puede usar result)
// Puramente combinacional (no tiene reloj).
// ============================================================
module restador #(
    parameter N = 16
)(
    input  wire [N-1:0] R,
    input  wire [N-1:0] B,
    output wire [N-1:0] result,
    output wire         MSB
);

    wire [N:0] diff;

    assign diff   = {1'b0, R} - {1'b0, B};
    assign result = diff[N-1:0];
    assign MSB    = diff[N];   // 1 = negativo (R<B), 0 = R>=B

endmodule
