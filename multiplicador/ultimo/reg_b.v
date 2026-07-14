module reg_b #(
    parameter N         = 16,
    parameter CNT_WIDTH = $clog2(N+1)
)(
    input  wire                  clk,
    input  wire                  LD,     
    input  wire [N-1:0]          b_in,   
    input  wire [CNT_WIDTH-1:0]  idx,    
    output wire                  b_i     
);

    reg [N-1:0] b_reg;

    always @(negedge clk) begin
        if (LD)
            b_reg <= b_in;
    end

    // Multiplexor: selecciona el bit "idx" del registro guardado
    assign b_i = (idx < N) ? b_reg[idx] : 1'b0;

endmodule
