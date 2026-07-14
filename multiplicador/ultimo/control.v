module control (
    input  wire clk,
    input  wire rst,     
    input  wire start,
    input  wire b_i,
    input  wire Z,
    output reg  LD,
    output reg  SH,
    output reg  AD,
    output reg  DONE
);

    localparam [2:0]
        IDLE    = 3'b000,   
        CHECK   = 3'b001,
        ADDST   = 3'b010,  
        SHIFTST = 3'b011,   
        DONEST  = 3'b100;   

    reg [2:0] state, next_state;

  
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case (state)
            IDLE:    next_state = start ? CHECK   : IDLE;
            CHECK:   next_state = b_i   ? ADDST   : SHIFTST;
            ADDST:   next_state = SHIFTST;
            SHIFTST: next_state = Z     ? DONEST  : CHECK;
            DONEST:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    
    always @(*) begin
        LD   = 1'b0;
        SH   = 1'b0;
        AD   = 1'b0;
        DONE = 1'b0;
        case (state)
            IDLE:    LD   = 1'b1;
            CHECK:   ; 
            ADDST:   AD   = 1'b1;
            SHIFTST: SH   = 1'b1;
            DONEST:  DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
