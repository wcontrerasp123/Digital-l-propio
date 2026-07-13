// ============================================================
// reg_b.v
// Registro/Multiplexor de B
// Guarda el multiplicador 'b' cuando LD=1, y expone el bit
// actual b(i) seleccionado por el indice del contador (idx).
// ============================================================
module reg_b #(
    parameter N         = 16,
    parameter CNT_WIDTH = $clog2(N+1)
)(
    input  wire                  clk,
    input  wire                  LD,     // carga b (viene de Control)
    input  wire [N-1:0]          b_in,   // entrada b del top
    input  wire [CNT_WIDTH-1:0]  idx,    // indice i (del contador)
    output wire                  b_i     // bit b(i) actual
);

    reg [N-1:0] b_reg;

    always @(negedge clk) begin
        if (LD)
            b_reg <= b_in;
    end

    // Multiplexor: selecciona el bit "idx" del registro guardado
    assign b_i = (idx < N) ? b_reg[idx] : 1'b0;

endmodule
