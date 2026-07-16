// ============================================================
// comparador.v
// Compara el contador i contra N (16 = cantidad de bits de A).
// Z=1 cuando i llega a 16 -> ya se hicieron las 16 iteraciones.
// ============================================================
module comparador #(
    parameter N     = 16,
    parameter WIDTH = 5
)(
    input  wire [WIDTH-1:0] count,
    output wire             Z
);

    assign Z = (count == N[WIDTH-1:0]) ? 1'b1 : 1'b0;

endmodule
