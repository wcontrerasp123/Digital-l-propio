module b2bin_reg_msb (
    input  wire       clk,
    input  wire       LD_MSB,
    input  wire [3:0] digito_actual,
    output reg  [3:0] MSB
);

    always @(negedge clk) begin
        if (LD_MSB)
            MSB <= digito_actual;
    end

endmodule
