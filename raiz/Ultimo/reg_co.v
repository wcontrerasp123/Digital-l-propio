module reg_co #(
    parameter PW = 8
)(
    input  wire            clk,
    input  wire            LDC,
    input  wire [PW-1:0]   p_in,
    output reg  [PW-1:0]   Co
);

    always @(negedge clk) begin
        if (LDC)
            Co <= p_in;
    end

endmodule
