// ============================================================
// reg_divisor.v
// Registro de B (divisor). Se carga con LDA y se mantiene fijo
// durante todo el proceso. Flanco de BAJADA (negedge clk).
// ============================================================
module reg_divisor #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire         LDA,
    input  wire [N-1:0] b_in,
    output reg  [N-1:0] B
);

    always @(negedge clk) begin
        if (LDA)
            B <= b_in;
    end

endmodule
