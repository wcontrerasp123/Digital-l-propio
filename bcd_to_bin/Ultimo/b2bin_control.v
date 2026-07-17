module b2bin_control (
    input  wire clk,
    input  wire rst,
    input  wire start,
    input  wire SUB,
    input  wire Z,
    output reg  LD,
    output reg  SH,
    output reg  LD_MSB,
    output reg  COMMIT,
    output reg  [1:0] digit_sel,
    output reg  DONE
);

    localparam [3:0]
        START  = 4'd0,
        SHIFT  = 4'd1,
        CHECK1 = 4'd2, SUB1 = 4'd3,
        CHECK2 = 4'd4, SUB2 = 4'd5,
        CHECK3 = 4'd6, SUB3 = 4'd7,
        CHECK4 = 4'd8, SUB4 = 4'd9,
        DONEST = 4'd10;

    reg [3:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            START:  next_state = start ? SHIFT  : START;
            SHIFT:  next_state = Z     ? DONEST : CHECK1;

            CHECK1: next_state = SUB ? SUB1 : CHECK2;
            SUB1:   next_state = CHECK2;

            CHECK2: next_state = SUB ? SUB2 : CHECK3;
            SUB2:   next_state = CHECK3;

            CHECK3: next_state = SUB ? SUB3 : CHECK4;
            SUB3:   next_state = CHECK4;

            CHECK4: next_state = SUB ? SUB4 : SHIFT;
            SUB4:   next_state = SHIFT;

            DONEST: next_state = start ? START : DONEST;
            default: next_state = START;
        endcase
    end

    always @(*) begin
        LD        = 1'b0;
        SH        = 1'b0;
        LD_MSB    = 1'b0;
        COMMIT    = 1'b0;
        digit_sel = 2'd0;
        DONE      = 1'b0;
        case (state)
            START:  LD = 1'b1;
            SHIFT:  SH = 1'b1;

            CHECK1: begin LD_MSB = 1'b1; digit_sel = 2'd0; end
            SUB1:   begin COMMIT = 1'b1; digit_sel = 2'd0; end

            CHECK2: begin LD_MSB = 1'b1; digit_sel = 2'd1; end
            SUB2:   begin COMMIT = 1'b1; digit_sel = 2'd1; end

            CHECK3: begin LD_MSB = 1'b1; digit_sel = 2'd2; end
            SUB3:   begin COMMIT = 1'b1; digit_sel = 2'd2; end

            CHECK4: begin LD_MSB = 1'b1; digit_sel = 2'd3; end
            SUB4:   begin COMMIT = 1'b1; digit_sel = 2'd3; end

            DONEST: DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
