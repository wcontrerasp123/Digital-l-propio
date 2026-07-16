module control (
    input  wire clk,
    input  wire rst,    
    input  wire start,
    input  wire a_i,
    input  wire Z,
    output reg  LD,
    output reg  inci,
    output reg  incb,
    output reg  DONE
);

    localparam [2:0]
        START  = 3'b000,
        CHECK  = 3'b001,
        ADDB   = 3'b010,
        ADDI   = 3'b011,
        CHECK2 = 3'b100,
        ENDST  = 3'b101;

    reg [2:0] state, next_state;

    // Registro de estado: flanco de SUBIDA
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= START;
        else
            state <= next_state;
    end

    // Logica de siguiente estado
    always @(*) begin
        case (state)
            START:   next_state = start ? CHECK  : START;
            CHECK:   next_state = a_i   ? ADDB   : ADDI;
            ADDB:    next_state = ADDI;
            ADDI:    next_state = CHECK2;
            CHECK2:  next_state = Z ? ENDST : CHECK;
            ENDST:   next_state = start ? START : ENDST;
            default: next_state = START;
        endcase
    end

    // Salidas (Moore, dependen solo del estado)
    always @(*) begin
        LD   = 1'b0;
        inci = 1'b0;
        incb = 1'b0;
        DONE = 1'b0;
        case (state)
            START:   LD   = 1'b1;
            CHECK:   ; // sin senales activas
            ADDB:    incb = 1'b1;
            ADDI:    inci = 1'b1;
            CHECK2:  ; // sin senales activas
            ENDST:   DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
