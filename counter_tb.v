`timescale 1ns / 1ps

module counter_tb;

    reg clk;
    reg rst;
    reg load;
    reg enab;
    reg [4:0] cnt_in;
    wire [4:0] cnt_out;

    // Instantiate the counter
    counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .enab(enab),
        .cnt_in(cnt_in),
        .cnt_out(cnt_out)
    );

    // Clock generation (10 unit period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;
        load = 0;
        enab = 0;
        cnt_in = 0;

        // Wait for global reset to finish
        #15;
        
        // At time 20 rst=0 load=1 enab=1 cnt_in=10101 => 21
        #5; // Time 20
        rst = 0;
        load = 1;
        enab = 1;
        cnt_in = 5'b10101;
        #2; // Slight delay to let signals settle before printing
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;
        
        // At time 30 rst=0 load=1 enab=1 cnt_in=01010 => 10
        #5; // Time 30
        rst = 0;
        load = 1;
        enab = 1;
        cnt_in = 5'b01010;
        #2;
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;
        
        // At time 40 rst=0 load=1 enab=1 cnt_in=11111 => 31
        #5; // Time 40
        rst = 0;
        load = 1;
        enab = 1;
        cnt_in = 5'b11111;
        #2;
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;
        
        // At time 50 rst=1 load=1 enab=1 cnt_in=11111 => 31
        #5; // Time 50
        rst = 1;
        load = 1;
        enab = 1;
        cnt_in = 5'b11111;
        #2;
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;
        
        // At time 60 rst=0 load=1 enab=1 cnt_in=11111 => 31
        #5; // Time 60
        rst = 0;
        load = 1;
        enab = 1;
        cnt_in = 5'b11111;
        #2;
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;
        
        // At time 70 rst=0 load=0 enab=1 cnt_in=11111 => 31
        #5; // Time 70
        rst = 0;
        load = 0;
        enab = 1;
        cnt_in = 5'b11111;
        #2;
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time-2, rst, load, enab, cnt_in, cnt_out);
        #3;

        #20;
        $finish;
    end
    
    // Using simple approach to sample right after clock edge to match exact values given in exercise
    // Actually the values depend on the clock edge, if clk is poedge, and events happen around it. 
    // In typical testbench, we should apply inputs before clock edge. Let's adjust timing slightly if needed.
endmodule
