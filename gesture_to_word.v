module gesture_to_word (
    input  [3:0] gesture_code,       // from FSM
    output reg [47:0] chars          // 6 ASCII chars concatenated {char5,...,char0}
);
    always @(*) begin
        case (gesture_code)
		      4'd0:  chars = {"      "};
            4'd1:  chars = {"   YES"};  // 2 spaces + Y E S + space = 6
            4'd2:  chars = {"    NO"};  // 3 spaces + N O + space = 6
            4'd3:  chars = {"  HELP"};  // pad with space
            4'd4:  chars = {" WATER"};
            4'd5:  chars = {"  FOOD"};
            4'd6:  chars = {"  PAIN"};
            4'd7:  chars = {"  STOP"};
            4'd8:  chars = {"    GO"};
            4'd9:  chars = {"  HOME"};
            4'd10: chars = {"HUNGRY"};
            4'd11: chars = {"THIRST"};
            4'd12: chars = {"  CALL"};
            4'd13: chars = {" EMERG"};
            4'd14: chars = {"    OK"};
            4'd15: chars = {"THANKS"};
            default: chars = {"      "}; // 6 spaces
        endcase
    end
endmodule
