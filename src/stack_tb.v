`timescale 1ns / 1ps

module stack_tb;

    parameter WIDTH = 8;
    parameter DEPTH_LOG2 = 2; // Depth of 4 for easy testing

    reg clk;
    reg rst;
    reg en_wr;
    reg en_rd;
    reg [WIDTH-1:0] data_wr;
    wire [WIDTH-1:0] data_rd;
    wire full;
    wire empty;

    stack #(
        .WIDTH(WIDTH),
        .DEPTH_LOG2(DEPTH_LOG2)
    ) uut (
        .clk(clk),
        .rst(rst),
        .en_wr(en_wr),
        .en_rd(en_rd),
        .data_wr(data_wr),
        .data_rd(data_rd),
        .full(full),
        .empty(empty)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize Inputs
        rst = 1;
        en_wr = 0;
        en_rd = 0;
        data_wr = 0;

        // Reset
        #15;
        rst = 0;
        #10;

        // Test Scenario 1: Push data until full
        $display("Pushing elements...");
        push_data(8'h11);
        push_data(8'h22);
        push_data(8'h33);
        push_data(8'h44);

        // Test Scenario 2: Try to push when full (ignore writing)
        $display("Trying to push when full...");
        push_data(8'h55);
        if (full) $display("Stack is full, correctly blocked push.");

        // Test Scenario 3: Pop data
        $display("Popping elements...");
        pop_data();
        pop_data();
        pop_data();
        pop_data();

        // Test Scenario 4: Try to pop when empty (ignore reading)
        $display("Trying to pop when empty...");
        pop_data();
        if (empty) $display("Stack is empty, correctly blocked pop.");

        // Finish simulation
        #20 $finish;
    end

    task push_data(input [WIDTH-1:0] val);
    begin
        @(posedge clk);
        en_wr = 1;
        data_wr = val;
        @(posedge clk);
        en_wr = 0;
        $display("Pushed %h | full=%b empty=%b", val, full, empty);
    end
    endtask

    task pop_data();
    begin
        @(posedge clk);
        en_rd = 1;
        @(posedge clk);
        en_rd = 0;
        $display("Popped %h | full=%b empty=%b", data_rd, full, empty);
    end
    endtask

endmodule
