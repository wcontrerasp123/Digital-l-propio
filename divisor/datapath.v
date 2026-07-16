module datapath #(
    parameter N          = 16,
    parameter CNT_WIDTH  = 5
)(
    input  wire             clk,
    input  wire [N-1:0]     a,      
    input  wire [N-1:0]     b,      
    input  wire             LDA,
    input  wire             CO,
    input  wire             AO,
    input  wire             INC,
    input  wire             LDR,
    output wire             MSB,    
    output wire             Z,      
    output wire [N-1:0]     Q,      
    output wire [N-1:0]     Rem     
);

    wire [N-1:0]        B_reg;
    wire [N-1:0]         sub_result;
    wire [CNT_WIDTH-1:0] count;

    reg_divisor #(.N(N)) u_reg_divisor (
        .clk  (clk),
        .LDA  (LDA),
        .b_in (b),
        .B    (B_reg)
    );

    restador #(.N(N)) u_restador (
        .R      (Rem),
        .B      (B_reg),
        .result (sub_result),
        .MSB    (MSB)
    );

    reg_ra #(.N(N)) u_reg_ra (
        .clk        (clk),
        .LDA        (LDA),
        .CO         (CO),
        .AO         (AO),
        .LDR        (LDR),
        .a_in       (a),
        .sub_result (sub_result),
        .R          (Rem),
        .A          (Q)
    );

    contador_i #(.WIDTH(CNT_WIDTH)) u_contador_i (
        .clk   (clk),
        .rst   (LDA),
        .inc   (INC),
        .count (count)
    );

    comparador #(.N(N), .WIDTH(CNT_WIDTH)) u_comparador (
        .count (count),
        .Z     (Z)
    );

endmodule
