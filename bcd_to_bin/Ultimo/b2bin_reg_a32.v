module b2bin_reg_a32 (
    input  wire         clk,
    input  wire         LD,
    input  wire         SH,
    input  wire         COMMIT,
    input  wire         SUB,
    input  wire [1:0]   digit_sel,   
    input  wire [15:0]  a_in,       
    output reg  [31:0]  A
);

    always @(negedge clk) begin
        if (LD)
            A <= {a_in, 16'b0};
        else if (SH)
            A <= A >> 1;
        else if (COMMIT && SUB) begin
            case (digit_sel)
                2'd0: A[19:16] <= A[19:16] - 4'd3;
                2'd1: A[23:20] <= A[23:20] - 4'd3;
                2'd2: A[27:24] <= A[27:24] - 4'd3;
                2'd3: A[31:28] <= A[31:28] - 4'd3;
            endcase
        end
    end

endmodule
