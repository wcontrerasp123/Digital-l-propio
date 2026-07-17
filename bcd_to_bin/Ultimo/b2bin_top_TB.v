module tb_b2bin;

    reg              clk;
    reg              rst;
    reg              start;
    reg  [15:0]      a;      
    wire [15:0]      bin;
    wire             DONE;

    integer errors = 0;
    integer tests  = 0;

    b2bin_top uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .bin   (bin),
        .DONE  (DONE)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    function [15:0] dec_to_bcd_packed(input integer val);
        integer d0, d1, d2, d3;
        begin
            d0 = val % 10;
            d1 = (val / 10) % 10;
            d2 = (val / 100) % 10;
            d3 = (val / 1000) % 10;
            dec_to_bcd_packed = {d3[3:0], d2[3:0], d1[3:0], d0[3:0]};
        end
    endfunction

    task run_test(input integer decimal_val);
        reg [15:0] bcd_in;
        reg [15:0] expected;
        begin
            tests    = tests + 1;
            bcd_in   = dec_to_bcd_packed(decimal_val);
            expected = decimal_val[15:0];

            a = bcd_in;
            start = 1'b0;
            @(posedge clk);

            start = 1'b1;
            @(posedge clk);
            @(posedge clk);
            start = 1'b0;

            wait (DONE == 1'b1);
            @(posedge clk);

            if (bin !== expected) begin
                $display("FALLO: decimal=%0d (bcd=%h) -> bin=%0d (esperado %0d)",
                          decimal_val, bcd_in, bin, expected);
                errors = errors + 1;
            end else begin
                $display("OK   : decimal=%0d (bcd=%h) -> bin=%0d", decimal_val, bcd_in, bin);
            end

            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("b2bin_top_TB.vcd");
        $dumpvars(0, tb_b2bin);

        rst   = 1'b1;
        start = 1'b0;
        a = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(0);      // 0000 -> 0
        run_test(9);      // 0009 -> 9
        run_test(10);     // 0010 -> 10
        run_test(67);     // 0067 -> 67
        run_test(150);    // 0150 -> 150
        run_test(1234);   // 1234 -> 1234
        run_test(9999);   // 9999 -> 9999 (maximo con 4 digitos)
        run_test(8);      // 0008 -> 8
        run_test(25);     // 0025 -> 25
        run_test(103);    // 0103 -> 103

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
