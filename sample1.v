// ==================== UART TRANSMITTER ====================
module uart_tx(
    input clk,
    input reset_n,
    input start,
    input [7:0] data,
    output reg tx,
    output reg busy
);
    parameter CLK_HZ = 50_000_000;
    parameter BAUD = 9600;
    localparam DIV = CLK_HZ/BAUD;

    reg [12:0] clk_cnt;
    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            tx <= 1;
            busy <= 0;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= 10'b1111111111;
        end else if (start && !busy) begin
            busy <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= {1'b1, data, 1'b0}; // Stop + data + start
            tx <= 0;
        end else if (busy) begin
            if (clk_cnt < DIV-1) clk_cnt <= clk_cnt + 1;
            else begin
                clk_cnt <= 0;
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                if (bit_cnt == 9) busy <= 0;
                else bit_cnt <= bit_cnt + 1;
            end
        end
    end
endmodule


// ==================== FRAME BUILDER FSM ====================
module dfp_frame_fsm(
    input clk,
    input reset_n,
    input tx_busy,
    output reg [7:0] tx_data,
    output reg tx_start
);
    reg [3:0] state;
    reg [3:0] byte_cnt;

    // Example frame: Play track #1
    wire [7:0] frame [0:9];
    assign frame[0]=8'h7E;
    assign frame[1]=8'hFF;
    assign frame[2]=8'h06;
    assign frame[3]=8'h03; // CMD: play track
    assign frame[4]=8'h00;
    assign frame[5]=8'h00;
    assign frame[6]=8'h01; // Track 1
    assign frame[7]=8'hFE; // checksum high
    assign frame[8]=8'hF7; // checksum low
    assign frame[9]=8'hEF;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 0;
            byte_cnt <= 0;
            tx_start <= 0;
            tx_data <= 8'h00;
        end else begin
            case(state)
                0: begin
                    if (!tx_busy) begin
                        tx_data <= frame[byte_cnt];
                        tx_start <= 1;
                        state <= 1;
                    end
                end
                1: begin
                    tx_start <= 0;
                    state <= 2;
                end
                2: begin
                    if (!tx_busy) begin
                        byte_cnt <= byte_cnt + 1;
                        if (byte_cnt == 9) state <= 3;
                        else state <= 0;
                    end
                end
                3: state <= 3; // done
            endcase
        end
    end
endmodule


// ==================== TOP-LEVEL MODULE ====================
module dfplayer_top(
    input clk,
    input reset_n,
    output tx
);
    wire [7:0] tx_data;
    wire tx_start;
    wire tx_busy;

    dfp_frame_fsm fsm_inst(
        .clk(clk),
        .reset_n(reset_n),
        .tx_busy(tx_busy),
        .tx_data(tx_data),
        .tx_start(tx_start)
    );

    uart_tx uart_inst(
        .clk(clk),
        .reset_n(reset_n),
        .start(tx_start),
        .data(tx_data),
        .tx(tx),
        .busy(tx_busy)
    );
endmodule


// ==================== TESTBENCH ====================
module tb_dfplayer;
    reg clk = 0;
    reg reset_n = 0;
    wire tx;

    dfplayer_top uut(
        .clk(clk),
        .reset_n(reset_n),
        .tx(tx)
    );

    // Clock 50 MHz (20ns period)
    always #10 clk = ~clk;

    initial begin
        $dumpfile("dfplayer.vcd");
        $dumpvars(0,tb_dfplayer);

        reset_n = 0;
        #100 reset_n = 1;

        #5000;
        $finish;
    end
endmodule
