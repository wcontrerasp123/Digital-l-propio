module tb_paridad;

    parameter N         = 10;
    parameter IDX_WIDTH = 4;

    reg              clk;
    reg              rst;
    reg              start;
    reg  [N-1:0]     a;
    wire             ok;
    wire             DONE;

    integer errors = 0;
    integer tests  = 0;

    paridad_top #(.N(N), .IDX_WIDTH(IDX_WIDTH)) uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .ok    (ok),
        .DONE  (DONE)
    );

    
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task run_test(input [N-1:0] ta);
        reg expected;
        begin
            tests    = tests + 1;
            expected = ~(^ta);  

            a = ta;
            start = 1'b0;
            @(posedge clk);

            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            
            wait (DONE == 1'b1);
            @(posedge clk);

            if (ok !== expected) begin
                $display("FALLO: a=%b -> ok=%b (esperado %b)", ta, ok, expected);
                errors = errors + 1;
            end else begin
                $display("OK   : a=%b -> ok=%b", ta, ok);
            end

            
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("paridad_top_TB.vcd");
        $dumpvars(0, tb_paridad);

        rst   = 1'b1;
        start = 1'b0;
        a = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(10'b0000000000); // 0 unos  -> par   -> ok=1
        run_test(10'b0000000001); // 1 uno   -> impar -> ok=0
        run_test(10'b1111111111); // 10 unos -> par   -> ok=1
        run_test(10'b1010101010); // 5 unos  -> impar -> ok=0
        run_test(10'b1100110011); // 6 unos  -> par   -> ok=1
        run_test(10'b1000000000); // 1 uno   -> impar -> ok=0
        run_test(10'b0101010101); // 5 unos  -> impar -> ok=0

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
