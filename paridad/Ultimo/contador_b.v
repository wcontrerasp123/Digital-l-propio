module contador_b #(
    parameter WIDTH = 4
)(
    input  wire              clk,
    input  wire              rst,   
    input  wire              inc,   
    output reg  [WIDTH-1:0]  b,
    output wire              ok     
);

    always @(negedge clk) begin
        if (rst)
            b <= {WIDTH{1'b0}};
        else if (inc)
            b <= b + 1'b1;
    end

    assign ok = ~b[0];

endmodule
