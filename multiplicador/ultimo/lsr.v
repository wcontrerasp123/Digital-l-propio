// ============================================================
// lsr.v
// Registro de 'a' con corrimiento a la izquierda.
// Se carga con 'a' (extendido con ceros) cuando LOAD_A(=LD)=1.
// Se desplaza 1 bit a la izquierda cuando SH=1 (multiplica x2).
// Ancho de 2N bits para poder acumular el producto completo.
// ============================================================
module lsr #(
    parameter N = 16
)(
    input  wire                clk,
    input  wire                LD,     // LOAD_A
    input  wire                SH,     // shift
    input  wire [N-1:0]        a_in,
    output reg  [2*N-1:0]      a_out
);

    always @(negedge clk) begin
        if (LD)
            a_out <= {{N{1'b0}}, a_in};   // carga a, extendido con ceros
        else if (SH)
            a_out <= a_out << 1;          // corrimiento a la izquierda
    end

endmodule
