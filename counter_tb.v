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

        #12; // Time 12
        rst = 0; load = 1; enab = 1; cnt_in = 5'b10101; 
        #8;  // Time 20 (after posedge at 15)
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);
        
        #2; // Time 22
        rst = 0; load = 1; enab = 1; cnt_in = 5'b01010;
        #8; // Time 30
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);
        
        #2; // Time 32
        rst = 0; load = 1; enab = 1; cnt_in = 5'b11111;
        #8; // Time 40
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);
        
        #2; // Time 42
        rst = 1; load = 1; enab = 1; cnt_in = 5'b11111;
        #8; // Time 50
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);
        
        #2; // Time 52
        rst = 0; load = 1; enab = 1; cnt_in = 5'b11111;
        #8; // Time 60
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);
        
        #2; // Time 62
        rst = 0; load = 0; enab = 1; cnt_in = 5'b11111;
        #8; // Time 70
        $display("At time %0t rst=%b load=%b enab=%b cnt_in=%b cnt_out=%b", $time, rst, load, enab, cnt_in, cnt_out);

        #10;
        $finish;
    end
    
    // Using simple approach to sample right after clock edge to match exact values given in exercise
    // Actually the values depend on the clock edge, if clk is poedge, and events happen around it. 
    // In typical testbench, we should apply inputs before clock edge. Let's adjust timing slightly if needed.
endmodule
