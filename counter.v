`timescale 1ns / 1ps

module counter #(
    parameter N = 8 // Default counter width is 8 bits
) (
    input wire clk,
    input wire rst_n, // Active-low asynchronous reset
    input wire [1:0] control,
    input wire [N-1:0] parallel_in,
    output reg [N-1:0] count_out
);

    // Sequential logic block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_out <= {N{1'b0}}; // Reset counter to 0
        end else begin
            case (control)
                // 2'b00: Hold current state
                2'b00: count_out <= count_out;

                // 2'b01: Count up
                2'b01: count_out <= count_out + 1;

                // 2'b10: Count down
                2'b10: count_out <= count_out - 1;

                // 2'b11: Parallel Load
                2'b11: count_out <= parallel_in;

                // Default case to prevent latches in combinational logic,
                // though not strictly necessary here, it's good practice.
                default: count_out <= count_out;
            endcase
        end
    end

endmodule