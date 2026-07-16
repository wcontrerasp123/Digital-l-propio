module contador_i #(
    parameter WIDTH = 4   // alcanza para contar 0..8 (N/2 con N=16)
)(
    input  wire              clk,
    input  wire              rst,   // = LD
    input  wire              inc,   // = SH
    output reg [WIDTH-1:0]   count
);

    always @(negedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (inc)
            count <= count + 1'b1;
    end

endmodule
