// ============================================================
// control.v
// FSM del multiplicador (Moore), 5 estados:
//   IDLE (Inicio) -> CHECK -> ADD/SHIFT -> ... -> DONE_ST (End)
// Salidas por estado, segun el diagrama de estados:
//   IDLE:    LD=1 SH=0 AD=0 DONE=0
//   CHECK:   LD=0 SH=0 AD=0 DONE=0
//   ADDST:   LD=0 SH=0 AD=1 DONE=0
//   SHIFTST: LD=0 SH=1 AD=0 DONE=0
//   DONEST:  LD=0 SH=0 AD=0 DONE=1
// ============================================================
module control (
    input  wire clk,
    input  wire rst,     // reset general (asincrono, activo alto)
    input  wire start,
    input  wire b_i,
    input  wire Z,
    output reg  LD,
    output reg  SH,
    output reg  AD,
    output reg  DONE
);

    localparam [2:0]
        IDLE    = 3'b000,   // Inicio
        CHECK   = 3'b001,
        ADDST   = 3'b010,   // ADD
        SHIFTST = 3'b011,   // Shift
        DONEST  = 3'b100;   // End

    reg [2:0] state, next_state;

    // Registro de estado
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Logica de siguiente estado
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

    // Salidas (Moore, dependen solo del estado)
    always @(*) begin
        LD   = 1'b0;
        SH   = 1'b0;
        AD   = 1'b0;
        DONE = 1'b0;
        case (state)
            IDLE:    LD   = 1'b1;
            CHECK:   ; // sin senales activas
            ADDST:   AD   = 1'b1;
            SHIFTST: SH   = 1'b1;
            DONEST:  DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
