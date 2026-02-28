`timescale 1ns / 1ps

module stack #(
    parameter WIDTH = 8,
    parameter DEPTH_LOG2 = 3
) (
    input clk,
    input rst,        // Asynchronous active-high reset
    input push,       // Write enable
    input pop,        // Read enable
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output reg full,
    output reg empty
);

    localparam MAX_DEPTH = 1 << DEPTH_LOG2;

    reg [WIDTH-1:0] mem [0:MAX_DEPTH-1];
    reg [DEPTH_LOG2:0] sp; // Stack pointer, needs extra bit for full condition

    // Asynchronous reset and logic for sp, full, empty, dout
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            full <= 0;
            empty <= 1;
            dout <= 0;
        end else begin
            if (push && !full) begin
                mem[sp] <= din;
                sp <= sp + 1;
                empty <= 0;
                if (sp + 1 == MAX_DEPTH) 
                    full <= 1;
            end else if (pop && !empty) begin
                dout <= mem[sp - 1]; // LIFO
                sp <= sp - 1;
                full <= 0;
                if (sp - 1 == 0)
                    empty <= 1;
            end
        end
    end

endmodule
