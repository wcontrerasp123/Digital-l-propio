// ============================================================
// reg_a.v
// Registro de 'a' (10 bits fijos) + mux de seleccion de bit.
// Guarda 'a' cuando LD=1 (flanco de bajada, ver nota abajo),
// y expone el bit actual a(i) segun el indice del contador i.
// ============================================================
module reg_a #(
    parameter N         = 10,
    parameter IDX_WIDTH = 4      // alcanza para contar 0..10
)(
    input  wire                  clk,
    input  wire                  LD,
    input  wire [N-1:0]          a_in,
    input  wire [IDX_WIDTH-1:0]  idx,
    output wire                  a_i
);

    reg [N-1:0] a_reg;

    // Datapath: se actualiza en flanco de BAJADA (negedge),
    // medio ciclo despues de que Control cambia de estado en subida.
    always @(negedge clk) begin
        if (LD)
            a_reg <= a_in;
    end

    assign a_i = (idx < N) ? a_reg[idx] : 1'b0;

endmodule
