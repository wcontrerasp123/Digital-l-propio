module datapath #(
    parameter N         = 16,
    parameter CNT_WIDTH = $clog2(N+1)
)(
    input  wire             clk,
    input  wire [N-1:0]     a,
    input  wire [N-1:0]     b,
    input  wire             LD,
    input  wire             SH,
    input  wire             AD,
    output wire             b_i,   
    output wire             Z,     
    output wire [2*N-1:0]   R      
);

    wire [CNT_WIDTH-1:0] count;
    wire [2*N-1:0]       a_shifted;

    reg_b #(.N(N)) u_reg_b (
        .clk   (clk),
        .LD    (LD),
        .b_in  (b),
        .idx   (count),
        .b_i   (b_i)
    );

    contador #(.N(N)) u_contador (
        .clk   (clk),
        .rst   (LD),
        .inc   (SH),
        .count (count)
    );

    comparador #(.N(N)) u_comparador (
        .count (count),
        .Z     (Z)
    );

    lsr #(.N(N)) u_lsr (
        .clk   (clk),
        .LD    (LD),
        .SH    (SH),
        .a_in  (a),
        .a_out (a_shifted)
    );

    acc #(.N(N)) u_acc (
        .clk     (clk),
        .LD      (LD),
        .AD      (AD),
        .add_val (a_shifted),
        .R       (R)
    );

endmodule
