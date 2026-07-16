module tb_raiz;

    parameter N         = 16;
    parameter PW        = 8;
    parameter RE_WIDTH  = 10;
    parameter CNT_WIDTH = 4;

    reg              clk;
    reg              rst;
    reg              start;
    reg  [N-1:0]     a;
    wire [PW-1:0]        P;
    wire [RE_WIDTH-1:0]  Rem;
    wire                 DONE;

    integer errors = 0;
    integer tests  = 0;

    raiz_top #(.N(N), .PW(PW), .RE_WIDTH(RE_WIDTH), .CNT_WIDTH(CNT_WIDTH)) uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .P     (P),
        .Rem   (Rem),
        .DONE  (DONE)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    function integer isqrt(input integer val);
        integer p;
        begin
            p = 0;
            while ((p+1)*(p+1) <= val)
                p = p + 1;
            isqrt = p;
        end
    endfunction

    task run_test(input [N-1:0] ta);
        integer expected_p, expected_rem;
        begin
            tests        = tests + 1;
            expected_p   = isqrt(ta);
            expected_rem = ta - expected_p*expected_p;

            a = ta;
            start = 1'b0;
            @(posedge clk);

            // Pulso de start de 2 ciclos: cubre ENDST->START->STAD1
            start = 1'b1;
            @(posedge clk);
            @(posedge clk);
            start = 1'b0;

            // Espera a que la FSM llegue al estado END
            wait (DONE == 1'b1);
            @(posedge clk);

            if (P !== expected_p[PW-1:0] || Rem !== expected_rem[RE_WIDTH-1:0]) begin
                $display("FALLO: a=%0d -> P=%0d Rem=%0d (esperado P=%0d Rem=%0d)",
                          ta, P, Rem, expected_p, expected_rem);
                errors = errors + 1;
            end else begin
                $display("OK   : a=%0d -> P=%0d Rem=%0d", ta, P, Rem);
            end

            // Deja pasar un ciclo en ENDST y vuelve a START
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("raiz_top_TB.vcd");
        $dumpvars(0, tb_raiz);

        rst   = 1'b1;
        start = 1'b0;
        a = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(16'd0);      // 0    -> P=0   Rem=0
        run_test(16'd1);      // 1    -> P=1   Rem=0
        run_test(16'd144);    // 144  -> P=12  Rem=0  (cuadrado perfecto)
        run_test(16'd150);    // 150  -> P=12  Rem=6  (no perfecto)
        run_test(16'd65535);  // max  -> P=255 Rem=254
        run_test(16'd255);    // 255  -> P=15  Rem=30
        run_test(16'd65025);  // 255^2 = 65025 -> P=255 Rem=0
        run_test(16'd2);      // 2    -> P=1   Rem=1
        run_test(16'd10000);  // 100^2 = 10000 -> P=100 Rem=0

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
