// ============================================================
// contador_b.v
// Contador de unos: cuenta cuantos bits de 'a' son 1.
// Se actualiza en flanco de BAJADA (negedge clk).
// rst (=LD del control) lo reinicia a 0.
// inc (=incb del control) lo incrementa en 1 (cuando a(i)=1).
// La salida "ok" es la NEGACION del bit 0 de b: el bit de
// paridad (1 si la cantidad de unos es PAR, 0 si es IMPAR).
// ============================================================
module contador_b #(
    parameter WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst,   // = LD
    input  wire              inc,   // = incb
    output reg  [WIDTH-1:0]  b,
    output wire              ok     // = b[0], bit de paridad
);

    always @(negedge clk) begin
        if (rst)
            b <= {WIDTH{1'b0}};
        else if (inc)
            b <= b + 1'b1;
    end

    assign ok = ~b[0];

endmodule
