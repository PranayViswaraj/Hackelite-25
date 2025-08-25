module top (
    input clk_50mhz,        // PIN_N14
    input rst_n,            // KEY0 (active-low reset)
    input [3:0] sw,         // SW[3:0] input (mock gesture sensors)
    output [3:0] led,       // LEDR[3:0] output (gesture result)
    output [6:0] HEX0,      // 7-seg display 0
    output [6:0] HEX1,      // 7-seg display 1
    output [6:0] HEX2,      // 7-seg display 2
    output [6:0] HEX3,      // 7-seg display 3
    output [6:0] HEX4,      // 7-seg display 4
    output [6:0] HEX5       // 7-seg display 5
);

    wire slow_clk;
    wire [3:0] gesture_code;   // internal wire for gesture FSM output

    // Clock divider to slow down input clock (~1 Hz)
    clock_divider u1 (
        .clk_in(clk_50mhz),
        .rst_n(rst_n),
        .clk_out(slow_clk)
    );

    // FSM (reset inverted because KEY0 is active-low)
    gesture_fsm u2 (
        .clk(slow_clk),
        .rst(~rst_n),         // KEY0 active-low → active-high reset
        .sensor_in(sw),       // 4-bit switches as input
        .gesture(gesture_code) // FSM output gesture_code
    );

    // Drive LEDs directly with gesture_code
    assign led = gesture_code;

    // Gesture display (7-seg)
    gesture_display disp (
        .gesture_code(gesture_code),
        .HEX0(HEX0), 
        .HEX1(HEX1), 
        .HEX2(HEX2),
        .HEX3(HEX3), 
        .HEX4(HEX4), 
        .HEX5(HEX5)
    );

endmodule
