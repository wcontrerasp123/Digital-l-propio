module comparador #(
    parameter N     = 10,
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] count,
    output wire             Z
);

    assign Z = (count == N[WIDTH-1:0]) ? 1'b1 : 1'b0;

endmodule
