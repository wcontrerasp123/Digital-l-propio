// ============================================================
// comparador.v
// Compara el contador i contra N (10 = cantidad de bits de a).
// Z=1 cuando i llega a 10 -> ya se recorrieron los 10 bits.
// ============================================================
module comparador #(
    parameter N     = 10,
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] count,
    output wire             Z
);

    assign Z = (count == N[WIDTH-1:0]) ? 1'b1 : 1'b0;

endmodule
