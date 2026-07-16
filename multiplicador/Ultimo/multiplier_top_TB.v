module tb_multiplier;

    parameter N = 16;

    reg                  clk;
    reg                  rst;
    reg                  start;
    reg  [N-1:0]         a, b;
    wire [2*N-1:0]       R;
    wire                 DONE;

    integer errors = 0;
    integer tests  = 0;

    multiplier_top #(.N(N)) uut (
        .clk   (clk),
        .rst   (rst),
        .start (start),
        .a     (a),
        .b     (b),
        .R     (R),
        .DONE  (DONE)
    );

  
    initial clk = 1'b0;
    always #5 clk = ~clk;

    task run_test(input [N-1:0] ta, input [N-1:0] tb);
        reg [2*N-1:0] expected;
        begin
            tests    = tests + 1;
            expected = ta * tb;

            a = ta;
            b = tb;
            start = 1'b0;
            @(posedge clk);

            
            start = 1'b1;
            @(posedge clk);
            @(posedge clk);
            start = 1'b0;

            
            wait (DONE == 1'b1);
            @(posedge clk);

            if (R !== expected) begin
                $display("FALLO: a=%0d b=%0d -> R=%0d (esperado %0d)", ta, tb, R, expected);
                errors = errors + 1;
            end else begin
                $display("OK   : a=%0d b=%0d -> R=%0d", ta, tb, R);
            end


            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("multiplier_top_TB.vcd");
        $dumpvars(0, tb_multiplier);

        rst   = 1'b1;
        start = 1'b0;
        a = 0; b = 0;
        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);

        run_test(16'd5,     16'd3);
        run_test(16'd1000,  16'd1000);
        run_test(16'd65535, 16'd65535);
        run_test(16'd0,     16'd12345);
        run_test(16'd1,     16'd1);
        run_test(16'd30000, 16'd2);
        run_test(16'd43690, 16'd21845);

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("TODAS LAS PRUEBAS PASARON (%0d/%0d)", tests, tests);
        else
            $display("%0d DE %0d PRUEBAS FALLARON", errors, tests);

        $finish;
    end

endmodule
