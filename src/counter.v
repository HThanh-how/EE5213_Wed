`timescale 1ns / 1ps

module counter (
    input clk,
    input rst,
    input load,
    input en,
    input [4:0] cnt_in,
    output reg [4:0] cnt_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_out <= 5'b00000;
        end else if (load) begin
            cnt_out <= cnt_in;
        end else if (en) begin
            cnt_out <= cnt_out + 1;
        end
    end

endmodule
