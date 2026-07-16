module contador #(
    parameter N         = 16,
    parameter CNT_WIDTH = $clog2(N+1)
)(
    input  wire                    clk,
    input  wire                    rst,   // = LD
    input  wire                    inc,   // = SH
    output reg  [CNT_WIDTH-1:0]    count
);

    always @(negedge clk) begin
        if (rst)
            count <= {CNT_WIDTH{1'b0}};
        else if (inc)
            count <= count + 1'b1;
    end

endmodule
