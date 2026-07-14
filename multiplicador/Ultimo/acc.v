// ============================================================
// acc.v
// Acumulador (registro R).
// rst(=LD) pone R en 0.
// add(=AD) suma el valor actual del LSR (a desplazado) a R.
// ============================================================
module acc #(
    parameter N = 16
)(
    input  wire                clk,
    input  wire                LD,      // rst del acumulador
    input  wire                AD,      // add
    input  wire [2*N-1:0]      add_val, // valor de LSR (a<<i)
    output reg  [2*N-1:0]      R
);

    always @(negedge clk) begin
        if (LD)
            R <= {2*N{1'b0}};
        else if (AD)
            R <= R + add_val;
    end

endmodule
