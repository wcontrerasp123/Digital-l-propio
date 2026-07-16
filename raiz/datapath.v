module datapath #(
    parameter N         = 16,
    parameter PW        = 8,          // N/2
    parameter RE_WIDTH  = 10,         // N/2 + 2
    parameter CNT_WIDTH = 4
)(
    input  wire             clk,
    input  wire [N-1:0]     a,
    input  wire             LD,
    input  wire             SH,
    input  wire             LDC,
    input  wire             LDR,
    input  wire             Ne,
    output wire              Sumf,   // hacia Control
    output wire              Z,      // hacia Control
    output wire [PW-1:0]     P,      // raiz (resultado)
    output wire [RE_WIDTH-1:0] Rem   // residuo (resultado)
);

    wire [N-1:0]         A_reg;
    wire [PW-1:0]        Co;
    wire [RE_WIDTH-1:0]  sub_result;
    wire [CNT_WIDTH-1:0] count;

    reg_re_a #(.N(N), .RE_WIDTH(RE_WIDTH)) u_reg_re_a (
        .clk        (clk),
        .LD         (LD),
        .SH         (SH),
        .Ne         (Ne),
        .a_in       (a),
        .sub_result (sub_result),
        .Re         (Rem),
        .A          (A_reg)
    );

    reg_p #(.PW(PW)) u_reg_p (
        .clk (clk),
        .LD  (LD),
        .SH  (SH),
        .LDR (LDR),
        .Ne  (Ne),
        .P   (P)
    );

    reg_co #(.PW(PW)) u_reg_co (
        .clk  (clk),
        .LDC  (LDC),
        .p_in (P),
        .Co   (Co)
    );

    sumador #(.PW(PW), .RE_WIDTH(RE_WIDTH)) u_sumador (
        .Re         (Rem),
        .Co         (Co),
        .sub_result (sub_result),
        .Sumf       (Sumf)
    );

    contador_i #(.WIDTH(CNT_WIDTH)) u_contador_i (
        .clk   (clk),
        .rst   (LD),
        .inc   (SH),
        .count (count)
    );

    comparador #(.ITERS(PW), .WIDTH(CNT_WIDTH)) u_comparador (
        .count (count),
        .Z     (Z)
    );

endmodule
