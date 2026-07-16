module control (
    input  wire clk,
    input  wire rst,    
    input  wire start,
    input  wire Sumf,
    input  wire Z,
    output reg  LD,
    output reg  SH,
    output reg  LDC,
    output reg  LDR,
    output reg  Ne,
    output reg  DONE
);

    localparam [2:0]
        START  = 3'b000,
        STAD1  = 3'b001,
        STAD2  = 3'b010,
        CHECK1 = 3'b011,
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
            START:  next_state = start ? STAD1 : START;
            STAD1:  next_state = STAD2;
            STAD2:  next_state = Sumf ? CHECK1 : CHECK2;
            CHECK1: next_state = Z ? ENDST : STAD1;
            CHECK2: next_state = Z ? ENDST : STAD1;
            ENDST:  next_state = START;
            default: next_state = START;
        endcase
    end

    // Salidas (Moore, dependen solo del estado)
    always @(*) begin
        LD   = 1'b0;
        SH   = 1'b0;
        LDC  = 1'b0;
        LDR  = 1'b0;
        Ne   = 1'b0;
        DONE = 1'b0;
        case (state)
            START:  LD  = 1'b1;
            STAD1:  SH  = 1'b1;
            STAD2:  LDC = 1'b1;
            CHECK1: begin LDR = 1'b1; Ne = 1'b1; end
            CHECK2: begin LDR = 1'b1; Ne = 1'b0; end
            ENDST:  DONE = 1'b1;
            default: ;
        endcase
    end

endmodule
