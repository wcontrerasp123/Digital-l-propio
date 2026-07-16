// ============================================================
// contador_i.v
// Contador del indice i (cuenta las N iteraciones del ciclo
// de division). Flanco de BAJADA (negedge clk).
// rst (=LDA del control) lo reinicia a 0.
// inc (=INC del control) lo incrementa en 1.
// ============================================================
module contador_i #(
    parameter WIDTH = 5   // alcanza para contar 0..16
)(
    input  wire              clk,
    input  wire              rst,   // = LDA
    input  wire              inc,   // = INC
    output reg [WIDTH-1:0]   count
);

    always @(negedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (inc)
            count <= count + 1'b1;
    end

endmodule
