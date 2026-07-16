// ============================================================
// divisor_top_TB.v
// Testbench autoverificable del divisor restaurador de
// numeros binarios (N=16 bits).
// ============================================================
`timescale 1ns/1ps

module tb_divisor;

    parameter N         = 16;
    parameter CNT_WIDTH = 5;

    reg              clk;
    reg              rst;
    reg              start;
    reg  [N-1:0]     a, b;
    wire [N-1:0]     Q, Rem;
    wire             DONE;

    integer errors = 0;
    integer tests  = 0;

    divisor_top #(.N(N), .CNT_WIDTH(CNT_WIDTH)) uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .b     (b),
        .Q     (Q),
        .Rem   (Rem),
        .DONE  (DONE)
    );

    // Generador de reloj: 10 ns de periodo
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task run_test(input [N-1:0] ta, input [N-1:0] tb);
        reg [N-1:0] expected_q, expected_r;
        begin
            tests      = tests + 1;
            expected_q = ta / tb;
            expected_r = ta % tb;

            a = ta;
            b = tb;
            start = 1'b0;
            @(posedge clk);

            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            // Espera a que la FSM llegue al estado END
            wait (DONE == 1'b1);
            @(posedge clk);

            if (Q !== expected_q || Rem !== expected_r) begin
                $display("FALLO: a=%0d b=%0d -> Q=%0d Rem=%0d (esperado Q=%0d Rem=%0d)",
                          ta, tb, Q, Rem, expected_q, expected_r);
                errors = errors + 1;
            end else begin
                $display("OK   : a=%0d b=%0d -> Q=%0d Rem=%0d", ta, tb, Q, Rem);
            end

            // Deja pasar un ciclo en ENDST y vuelve a START
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("divisor_top_TB.vcd");
        $dumpvars(0, tb_divisor);

        rst   = 1'b1;
        start = 1'b0;
        a = 0; b = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(16'd20,    16'd4);
        run_test(16'd100,   16'd7);
        run_test(16'd65535, 16'd1);
        run_test(16'd65535, 16'd65535);
        run_test(16'd1,     16'd1);
        run_test(16'd0,     16'd5);
        run_test(16'd12345, 16'd100);

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
