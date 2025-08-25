module clock_divider (
    input clk_in,        // 50 MHz clock from board
    input rst_n,         // active-low reset
    output reg clk_out   // divided clock (~1 Hz)
);

    // 50 MHz = 50,000,000 cycles/sec
    // To get 1 Hz, we need to count 25,000,000 cycles (half period)
    parameter DIVISOR = 25_000_000;

    reg [24:0] count;   // needs 25 bits to count up to 25M

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 25'd0;
            clk_out <= 1'b0;
        end
        else begin
            if (count == DIVISOR-1) begin
                count   <= 25'd0;
                clk_out <= ~clk_out;   // toggle clock
            end
            else
                count <= count + 1;
        end
    end

endmodule
