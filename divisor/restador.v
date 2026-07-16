module restador #(
    parameter N = 16
)(
    input  wire [N-1:0] R,
    input  wire [N-1:0] B,
    output wire [N-1:0] result,
    output wire         MSB
);

    wire [N:0] diff;

    assign diff   = {1'b0, R} - {1'b0, B};
    assign result = diff[N-1:0];
    assign MSB    = diff[N];   // 1 = negativo (R<B), 0 = R>=B

endmodule
