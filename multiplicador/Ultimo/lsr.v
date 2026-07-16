module lsr #(
    parameter N = 16
)(
    input  wire                clk,
    input  wire                LD,    
    input  wire                SH,    
    input  wire [N-1:0]        a_in,
    output reg  [2*N-1:0]      a_out
);

    always @(negedge clk) begin
        if (LD)
            a_out <= {{N{1'b0}}, a_in};  
        else if (SH)
            a_out <= a_out << 1;       
    end

endmodule
