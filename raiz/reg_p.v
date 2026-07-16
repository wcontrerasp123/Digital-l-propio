module reg_p #(
    parameter PW = 8    // ancho de P = N/2
)(
    input  wire            clk,
    input  wire            LD,
    input  wire            SH,
    input  wire            LDR,
    input  wire            Ne,     
    output reg  [PW-1:0]   P
);

    always @(negedge clk) begin
        if (LD)
            P <= {PW{1'b0}};
        else if (SH)
            P <= P << 1;
        else if (LDR)
            P[0] <= Ne;
    end

endmodule
