module sumador #(
    parameter PW      = 8,
    parameter RE_WIDTH = 10
)(
    input  wire [RE_WIDTH-1:0] Re,
    input  wire [PW-1:0]       Co,
    output wire [RE_WIDTH-1:0] sub_result,
    output wire                Sumf
);

    wire [RE_WIDTH-1:0] trial;
    wire [RE_WIDTH:0]   diff;

    assign trial      = {{(RE_WIDTH-PW-1){1'b0}}, Co, 1'b1};
    assign diff        = {1'b0, Re} - {1'b0, trial};
    assign sub_result  = diff[RE_WIDTH-1:0];
    assign Sumf        = ~diff[RE_WIDTH];   // 1 = Re>=trial (sin prestamo)

endmodule
