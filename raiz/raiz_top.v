module raiz_top #(
    parameter N         = 16,
    parameter PW        = 8,     // N/2
    parameter RE_WIDTH  = 10,    // N/2 + 2
    parameter CNT_WIDTH = 4
)(
    input  wire                 clk,
    input  wire                 rst,
    input  wire                 start,
    input  wire [N-1:0]         a,
    output wire [PW-1:0]        P,      // raiz
    output wire [RE_WIDTH-1:0]  Rem,    // residuo
    output wire                 DONE
);

    wire LD, SH, LDC, LDR, Ne;
    wire Sumf, Z;

    control u_control (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .Sumf  (Sumf),
        .Z     (Z),
        .LD    (LD),
        .SH    (SH),
        .LDC   (LDC),
        .LDR   (LDR),
        .Ne    (Ne),
        .DONE  (DONE)
    );

    datapath #(.N(N), .PW(PW), .RE_WIDTH(RE_WIDTH), .CNT_WIDTH(CNT_WIDTH)) u_datapath (
        .clk  (clk),
        .a    (a),
        .LD   (LD),
        .SH   (SH),
        .LDC  (LDC),
        .LDR  (LDR),
        .Ne   (Ne),
        .Sumf (Sumf),
        .Z    (Z),
        .P    (P),
        .Rem  (Rem)
    );

endmodule
