module comparador #(
    parameter ITERS = 8,   // = N/2
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] count,
    output wire             Z
);

    assign Z = (count == ITERS[WIDTH-1:0]) ? 1'b1 : 1'b0;

endmodule
