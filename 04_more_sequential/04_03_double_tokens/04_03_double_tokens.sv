//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110

    logic [7:0] counter_1;
    logic res_b, res_overflow;

    always_comb
    begin
        if(a)
            res_b = '1;
        else if (counter_1 != 8'b00000000)
            res_b = '1;
        else
            res_b = '0;
        
        if(counter_1 > 3'd200)
            res_overflow = '1;
        else
            res_overflow = '0;
    end
    
    assign b = res_b;
    assign overflow = res_overflow;
    

    always_ff @ (posedge clk)
    begin
        if (rst)
        begin
            counter_1 <= 8'b00000000;
        end
        if(a)
            counter_1 <= counter_1 + '1;
        else if(counter_1 != 8'b00000000)
            counter_1 <= counter_1 - '1;
    end

endmodule
