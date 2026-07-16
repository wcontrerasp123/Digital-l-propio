// ============================================================
// reg_ra.v
// Registro combinado {R,A} (dividendo/cociente + residuo).
// Se actualiza en flanco de BAJADA (negedge clk).
//
//  LDA=1 : carga A = a_in (dividendo), R = 0            (START)
//  CO=1  : desplaza {R,A} un bit a la izquierda           (SHIFT)
//  LDR=1 : carga R = sub_result (resultado de R-B)        (ADD)
//  AO=1  : fija el bit A(0) = 1 (bit de cociente)          (ADD)
// ============================================================
module reg_ra #(
    parameter N = 16
)(
    input  wire             clk,
    input  wire             LDA,
    input  wire             CO,
    input  wire             AO,
    input  wire             LDR,
    input  wire [N-1:0]     a_in,
    input  wire [N-1:0]     sub_result,
    output reg  [N-1:0]     R,
    output reg  [N-1:0]     A
);

    always @(negedge clk) begin
        if (LDA) begin
            A <= a_in;
            R <= {N{1'b0}};
        end else if (CO) begin
            {R, A} <= {R, A} << 1;
        end else begin
            if (LDR)
                R <= sub_result;
            if (AO)
                A[0] <= 1'b1;
        end
    end

endmodule
