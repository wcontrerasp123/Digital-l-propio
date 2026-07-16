module reg_re_a #(
    parameter N        = 16,
    parameter RE_WIDTH = 10
)(
    input  wire                   clk,
    input  wire                   LD,
    input  wire                   SH,
    input  wire                   Ne,
    input  wire [N-1:0]           a_in,
    input  wire [RE_WIDTH-1:0]    sub_result,
    output reg  [RE_WIDTH-1:0]    Re,
    output reg  [N-1:0]           A
);

    always @(negedge clk) begin
        if (LD) begin
            A  <= a_in;
            Re <= {RE_WIDTH{1'b0}};
        end else if (SH) begin
            {Re, A} <= {Re, A} << 2;
        end else if (Ne) begin
            Re <= sub_result;
        end
    end

endmodule

