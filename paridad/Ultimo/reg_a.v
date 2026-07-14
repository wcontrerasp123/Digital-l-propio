module reg_a #(
    parameter N         = 10,
    parameter IDX_WIDTH = 4      
)(
    input  wire                  clk,
    input  wire                  LD,
    input  wire [N-1:0]          a_in,
    input  wire [IDX_WIDTH-1:0]  idx,
    output wire                  a_i
);

    reg [N-1:0] a_reg;

    
    always @(negedge clk) begin
        if (LD)
            a_reg <= a_in;
    end

    assign a_i = (idx < N) ? a_reg[idx] : 1'b0;

endmodule
