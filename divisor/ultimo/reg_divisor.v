module reg_divisor #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire         LDA,
    input  wire [N-1:0] b_in,
    output reg  [N-1:0] B
);

    always @(negedge clk) begin
        if (LDA)
            B <= b_in;
    end

endmodule
