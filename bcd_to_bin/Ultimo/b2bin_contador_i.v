module b2bin_contador_i #(
    parameter WIDTH = 5
)(
    input  wire              clk,
    input  wire              rst,
    input  wire              inc,
    output reg [WIDTH-1:0]   count
);

    always @(negedge clk) begin
        if (rst)
            count <= {WIDTH{1'b0}};
        else if (inc)
            count <= count + 1'b1;
    end

endmodule
