`timescale 1ns / 1ps

module stack #(
    parameter WIDTH = 8,
    parameter DEPTH_LOG2 = 3
) (
    input clk,
    input rst,        // Asynchronous active-high reset
    input en_wr,      // Write enable
    input en_rd,      // Read enable
    input [WIDTH-1:0] data_wr,
    output reg [WIDTH-1:0] data_rd,
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
            data_rd <= 0;
        end else begin
            if (en_wr && !full) begin
                mem[sp] <= data_wr;
                sp <= sp + 1;
                empty <= 0;
                if (sp + 1 == MAX_DEPTH) 
                    full <= 1;
            end else if (en_rd && !empty) begin
                data_rd <= mem[sp - 1]; // LIFO
                sp <= sp - 1;
                full <= 0;
                if (sp - 1 == 0)
                    empty <= 1;
            end
        end
    end

endmodule
