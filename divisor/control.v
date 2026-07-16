module control (
    input  wire clk,
    input  wire rst,   
    input  wire start,
    input  wire MSB,     // signo de R-B: 0=R>=B, 1=R<B
    input  wire Z,       
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
