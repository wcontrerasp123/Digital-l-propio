// ============================================================
// control.v
// FSM del divisor restaurador (Moore), 5 estados:
//   START -> SHIFT -> CHECK -> ADD/(salto) -> ... -> END
// El registro de estado va en flanco de SUBIDA (posedge clk).
// Salidas por estado, segun el diagrama de estados:
//   START: LDA=1 CO=0 AO=0 INC=0 LDR=0 DONE=0
//   SHIFT: LDA=0 CO=1 AO=0 INC=1 LDR=0 DONE=0
//   CHECK: LDA=0 CO=0 AO=0 INC=0 LDR=0 DONE=0
//   ADD:   LDA=0 CO=0 AO=1 INC=0 LDR=1 DONE=0
//   ENDST: LDA=0 CO=0 AO=0 INC=0 LDR=0 DONE=1
// ============================================================
module control (
    input  wire clk,
    input  wire rst,     // reset general (asincrono, activo alto)
    input  wire start,
    input  wire MSB,     // signo de R-B: 0=R>=B, 1=R<B
    input  wire Z,       // 1 = ya se hicieron las N iteraciones
    output reg  LDA,
    output reg  CO,
    output reg  AO,
    output reg  INC,
    output reg  LDR,
    output reg  DONE
);

    localparam [2:0]
        START = 3'b000,
        SHIFT = 3'b001,
        CHECK = 3'b010,
        ADDST = 3'b011,
        ENDST = 3'b100;

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
            START: next_state = start ? SHIFT : START;
            SHIFT: next_state = CHECK;
            CHECK: next_state = MSB ? (Z ? ENDST : SHIFT) : ADDST;
            ADDST: next_state = Z ? ENDST : SHIFT;
            ENDST: next_state = START;
            default: next_state = START;
        endcase
    end

    // Salidas (Moore, dependen solo del estado)
    always @(*) begin
        LDA  = 1'b0;
        CO   = 1'b0;
        AO   = 1'b0;
        INC  = 1'b0;
        LDR  = 1'b0;
        DONE = 1'b0;
        case (state)
            START: LDA  = 1'b1;
            SHIFT: begin CO = 1'b1; INC = 1'b1; end
            CHECK: ; // sin senales activas
            ADDST: begin AO = 1'b1; LDR = 1'b1; end
            ENDST: DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
