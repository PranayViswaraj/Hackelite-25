module gesture_display (
    input  [3:0] gesture_code,
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
    // Flattened 6 chars × 8 bits = 48-bit bus
    wire [47:0] chars;

    // Decode gesture → 6 chars (packed into one bus)
    gesture_to_word u1(.gesture_code(gesture_code), .chars(chars));

    // Convert chars → 7-seg (slice bus into 8-bit chunks)
    char_to_7seg d0(.char(chars[7:0]),    .seg(HEX0));
    char_to_7seg d1(.char(chars[15:8]),   .seg(HEX1));
    char_to_7seg d2(.char(chars[23:16]),  .seg(HEX2));
    char_to_7seg d3(.char(chars[31:24]),  .seg(HEX3));
    char_to_7seg d4(.char(chars[39:32]),  .seg(HEX4));
    char_to_7seg d5(.char(chars[47:40]),  .seg(HEX5));

endmodule
