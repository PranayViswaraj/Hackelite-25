module gesture_fsm (
    input clk,                // from clock divider
    input rst,                // reset button (active high)
    input [3:0] sensor_in,    // input from 3 flex + 1 proximity
    output reg [3:0] gesture  // gesture output code
);

    // State encoding
    parameter S_IDLE   = 4'b0000;
    parameter S_YES    = 4'b0001;
    parameter S_NO     = 4'b0010;
    parameter S_HELP   = 4'b0011;
    parameter S_WATER  = 4'b0100;
    parameter S_FOOD   = 4'b0101;
    parameter S_PAIN   = 4'b0110;
    parameter S_STOP   = 4'b0111;
    parameter S_GO     = 4'b1000;
    parameter S_HOME   = 4'b1001;
    parameter S_HUNGRY = 4'b1010;
    parameter S_THIRST = 4'b1011;
    parameter S_CALL   = 4'b1100;
    parameter S_EMERG  = 4'b1101;
    parameter S_OK     = 4'b1110;
    parameter S_THANKS = 4'b1111;

    reg [3:0] current_state, next_state;

    // Sequential block (state transition)
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (sensor_in)
            4'b1001: next_state = S_YES;     // Yes
            4'b0001: next_state = S_NO;      // No
            4'b1010: next_state = S_HELP;    // Help
            4'b1100: next_state = S_WATER;   // Water
            4'b0101: next_state = S_FOOD;    // Food
            4'b0110: next_state = S_PAIN;    // Pain
            4'b1110: next_state = S_STOP;    // Stop
            4'b0011: next_state = S_GO;      // Go
            4'b1111: next_state = S_HOME;    // Home
            4'b1000: next_state = S_HUNGRY;  // Hungry
            4'b0100: next_state = S_THIRST;  // Thirst
            4'b0010: next_state = S_CALL;    // Call
            4'b0111: next_state = S_EMERG;   // Emergency
            4'b1011: next_state = S_OK;      // OK
            4'b1101: next_state = S_THANKS;  // Thanks
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic (gesture code = state code itself)
    always @(*) begin
        case (current_state)
            S_YES:    gesture = 4'b0001;
            S_NO:     gesture = 4'b0010;
            S_HELP:   gesture = 4'b0011;
            S_WATER:  gesture = 4'b0100;
            S_FOOD:   gesture = 4'b0101;
            S_PAIN:   gesture = 4'b0110;
            S_STOP:   gesture = 4'b0111;
            S_GO:     gesture = 4'b1000;
            S_HOME:   gesture = 4'b1001;
            S_HUNGRY: gesture = 4'b1010;
            S_THIRST: gesture = 4'b1011;
            S_CALL:   gesture = 4'b1100;
            S_EMERG:  gesture = 4'b1101;
            S_OK:     gesture = 4'b1110;
            S_THANKS: gesture = 4'b1111;
            default:  gesture = 4'b0000;  // Idle
        endcase
    end

endmodule
