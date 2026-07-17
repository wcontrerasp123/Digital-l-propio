module tb_bin2bcd;

    parameter N = 16;

    reg              clk;
    reg              rst;
    reg              start;
    reg  [N-1:0]     a;
    wire [19:0]      bcd;
    wire             DONE;

    integer errors = 0;
    integer tests  = 0;

    bin2bcd_top #(.N(N)) uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .bcd   (bcd),
        .DONE  (DONE)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    function [19:0] bin_to_bcd_ref(input integer val);
        integer d0, d1, d2, d3, d4;
        begin
            d0 = val % 10;
            d1 = (val / 10) % 10;
            d2 = (val / 100) % 10;
            d3 = (val / 1000) % 10;
            d4 = (val / 10000) % 10;
            bin_to_bcd_ref = {d4[3:0], d3[3:0], d2[3:0], d1[3:0], d0[3:0]};
        end
    endfunction

    task run_test(input [N-1:0] ta);
        reg [19:0] expected;
        begin
            tests    = tests + 1;
            expected = bin_to_bcd_ref(ta);

            a = ta;
            start = 1'b0;
            @(posedge clk);

            start = 1'b1;
            @(posedge clk);
            @(posedge clk);
            start = 1'b0;

            wait (DONE == 1'b1);
            @(posedge clk);

            if (bcd !== expected) begin
                $display("FALLO: a=%0d -> bcd=%h (esperado %h = %0d%0d%0d%0d%0d decimal)",
                          ta, bcd, expected,
                          expected[19:16], expected[15:12], expected[11:8], expected[7:4], expected[3:0]);
                errors = errors + 1;
            end else begin
                $display("OK   : a=%0d -> bcd=%h (%0d%0d%0d%0d%0d)",
                          ta, bcd,
                          bcd[19:16], bcd[15:12], bcd[11:8], bcd[7:4], bcd[3:0]);
            end

            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("bin2bcd_top_TB.vcd");
        $dumpvars(0, tb_bin2bcd);

        rst   = 1'b1;
        start = 1'b0;
        a = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(16'd0);       // 0     -> 00000
        run_test(16'd9);       // 9     -> 00009
        run_test(16'd10);      // 10    -> 00010
        run_test(16'd150);     // 150   -> 00150
        run_test(16'd1234);    // 1234  -> 01234
        run_test(16'd9999);    // 9999  -> 09999
        run_test(16'd10000);   // 10000 -> 10000
        run_test(16'd65535);   // 65535 -> 65535 (maximo de 16 bits)
        run_test(16'd8);       // 8     -> 00008 (no necesita correccion)
        run_test(16'd25);      // 25    -> 00025

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
