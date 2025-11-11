//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);
    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101

    logic spare_1;

    assign b = a ? a & spare_1 : a;
    // if(a)
    //     b <= a & spare_1;
    // else
    //     b <= a;

    always_ff @ (posedge clk)
    if (rst)
    begin
        spare_1 <= '0;
    end
    else if(a)
        spare_1 <= spare_1 ^ '1;


endmodule
