// ============================================================
// control.v
// FSM del contador de unos / paridad (Moore), 6 estados:
//   START -> CHECK -> ADDB/ADDI -> CHECK2 -> ... -> END
// El registro de estado va en flanco de SUBIDA (posedge clk).
// Salidas por estado, segun el diagrama de estados:
//   START:  LD=1 inci=0 incb=0 DONE=0
//   CHECK:  LD=0 inci=0 incb=0 DONE=0
//   ADDB:   LD=0 inci=0 incb=1 DONE=0   (b = b+1)
//   ADDI:   LD=0 inci=1 incb=0 DONE=0   (i = i+1)
//   CHECK2: LD=0 inci=0 incb=0 DONE=0
//   ENDST:  LD=0 inci=0 incb=0 DONE=1
// ============================================================
module control (
    input  wire clk,
    input  wire rst,     // reset general (asincrono, activo alto)
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
            ENDST:   next_state = START;
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
