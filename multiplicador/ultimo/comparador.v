module comparador #(
    parameter N         = 16,
    parameter CNT_WIDTH = $clog2(N+1)
)(
    input  wire [CNT_WIDTH-1:0] count,
    output wire                 Z
);

    assign Z = (count == N[CNT_WIDTH-1:0]) ? 1'b1 : 1'b0;

endmodule
