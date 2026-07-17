module reg_a36 #(
    parameter N = 16
)(
    input  wire         clk,
    input  wire         LD,
    input  wire         SH,
    input  wire         COMMIT,
    input  wire         ADD,
    input  wire [2:0]   digit_sel,   
    input  wire [N-1:0] a_in,
    output reg  [35:0]  A
);

    always @(negedge clk) begin
        if (LD)
            A <= {20'b0, a_in};
        else if (SH)
            A <= A << 1;
        else if (COMMIT && ADD) begin
            case (digit_sel)
                3'd0: A[19:16] <= A[19:16] + 4'd3;
                3'd1: A[23:20] <= A[23:20] + 4'd3;
                3'd2: A[27:24] <= A[27:24] + 4'd3;
                3'd3: A[31:28] <= A[31:28] + 4'd3;
                3'd4: A[35:32] <= A[35:32] + 4'd3;
                default: ;
            endcase
        end
    end

endmodule
