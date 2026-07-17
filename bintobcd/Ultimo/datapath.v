module datapath #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire [N-1:0] a,
    input  wire         LD,
    input  wire         SH,
    input  wire         LD_MSB,
    input  wire         COMMIT,
    input  wire [2:0]   digit_sel,
    output wire         ADD,     
    output wire         Z,      
    output wire [19:0]  bcd      // resultado final 
);

    wire [35:0] A;
    wire [3:0]  digito_actual;
    wire [3:0]  MSB;
    wire [4:0]  count;

    // Multiplexor: extrae el digito seleccionado del registro grande
    assign digito_actual = (digit_sel == 3'd0) ? A[19:16] :
                            (digit_sel == 3'd1) ? A[23:20] :
                            (digit_sel == 3'd2) ? A[27:24] :
                            (digit_sel == 3'd3) ? A[31:28] :
                                                   A[35:32];

    reg_a36 #(.N(N)) u_reg_a36 (
        .clk       (clk),
        .LD        (LD),
        .SH        (SH),
        .COMMIT    (COMMIT),
        .ADD       (ADD),
        .digit_sel (digit_sel),
        .a_in      (a),
        .A         (A)
    );

    reg_msb_propio u_reg_msb (
        .clk           (clk),
        .LD_MSB        (LD_MSB),
        .digito_actual (digito_actual),
        .MSB           (MSB)
    );

    assign ADD = (MSB > 4'd4) ? 1'b1 : 1'b0;
    assign bcd = A[35:16];

    contador_i #(.WIDTH(5)) u_contador_i (
        .clk   (clk),
        .rst   (LD),
        .inc   (SH),
        .count (count)
    );

    comparador #(.N(N), .WIDTH(5)) u_comparador (
        .count (count),
        .Z     (Z)
    );

endmodule
