// ============================================================
// contador_i.v
// Contador del indice i (recorre los 10 bits de 'a').
// Se actualiza en flanco de BAJADA (negedge clk).
// rst (=LD del control) lo reinicia a 0.
// inc (=inci del control) lo incrementa en 1.
// ============================================================
module contador_i #(
    parameter WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst,   // = LD
    input  wire              inc,   // = inci
    output reg [WIDTH-1:0]   count
);

    always @(negedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (inc)
            count <= count + 1'b1;
    end

endmodule
