// ============================================================
// datapath.v
// Camino de datos del contador de unos (paridad).
// Conecta: reg_a (registro + mux), contador_i, comparador,
// contador_b (contador de unos).
// ============================================================
module datapath #(
    parameter N         = 10,
    parameter IDX_WIDTH = 4
)(
    input  wire                     clk,
    input  wire [N-1:0]             a,
    input  wire                     LD,
    input  wire                     inci,
    input  wire                     incb,
    output wire                     a_i,      // hacia Control
    output wire                     Z,        // hacia Control
    output wire                     ok,       // resultado final (paridad)
    output wire [IDX_WIDTH-1:0]     b_debug   // cuenta de unos (para observar en simulacion)
);

    wire [IDX_WIDTH-1:0] count_i;

    reg_a #(.N(N), .IDX_WIDTH(IDX_WIDTH)) u_reg_a (
        .clk  (clk),
        .LD   (LD),
        .a_in (a),
        .idx  (count_i),
        .a_i  (a_i)
    );

    contador_i #(.WIDTH(IDX_WIDTH)) u_contador_i (
        .clk   (clk),
        .rst   (LD),
        .inc   (inci),
        .count (count_i)
    );

    comparador #(.N(N), .WIDTH(IDX_WIDTH)) u_comparador (
        .count (count_i),
        .Z     (Z)
    );

    contador_b #(.WIDTH(IDX_WIDTH)) u_contador_b (
        .clk (clk),
        .rst (LD),
        .inc (incb),
        .b   (b_debug),
        .ok  (ok)
    );

endmodule
