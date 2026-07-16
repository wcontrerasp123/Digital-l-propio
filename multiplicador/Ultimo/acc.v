module acc #(
    parameter N = 16
)(
    input  wire                clk,
    input  wire                LD,      
    input  wire                AD,      
    input  wire [2*N-1:0]      add_val, 
    output reg  [2*N-1:0]      R
);

    always @(negedge clk) begin
        if (LD)
            R <= {2*N{1'b0}};
        else if (AD)
            R <= R + add_val;
    end

endmodule
