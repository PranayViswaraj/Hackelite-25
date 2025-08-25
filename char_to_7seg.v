// 7-Segment encoder (Common Anode)
// Segment order: {g, f, e, d, c, b, a}
module char_to_7seg (
    input  [7:0] char,     // ASCII code (A-Z, 0-9)
    output reg [6:0] seg   // 7-seg pattern
);
    always @(*) begin
        case (char)
            "A": seg = 7'b0001000;
            "B": seg = 7'b0000011; // b
            "C": seg = 7'b1000110;
            "D": seg = 7'b0100001; // d
            "E": seg = 7'b0000110;
            "F": seg = 7'b0001110;
            "G": seg = 7'b0010000;
            "H": seg = 7'b0001001;
            "I": seg = 7'b1111001;
            "J": seg = 7'b1100001;
				"K": seg = 7'b0001010;
            "L": seg = 7'b1000111;
				"M": seg = 7'b1001000;
            "N": seg = 7'b0101011;
            "O": seg = 7'b1000000;
            "P": seg = 7'b0001100;
				"Q": seg = 7'b0011000;
            "R": seg = 7'b0101111;
            "S": seg = 7'b0010010;
            "T": seg = 7'b0000111;
            "U": seg = 7'b1000001;
				"V": seg = 7'b1100011;
				"W": seg = 7'b0011101;
				"X": seg = 7'b0011011;
            "Y": seg = 7'b0010001;
				"Z": seg = 7'b0100100;
            "-": seg = 7'b1111110;
            "0": seg = 7'b1000000;
            "1": seg = 7'b1111001;
            "2": seg = 7'b0100100;
            "3": seg = 7'b0110000;
            "4": seg = 7'b0011001;
            "5": seg = 7'b0010010;
            "6": seg = 7'b0000010;
            "7": seg = 7'b1111000;
            "8": seg = 7'b0000000;
            "9": seg = 7'b0010000;
            default: seg = 7'b1111111; // blank
        endcase
    end
endmodule
