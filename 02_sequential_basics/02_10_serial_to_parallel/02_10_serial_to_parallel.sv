//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
    // output flag
);
    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    // initial
    // begin
    //     $dumpfile("signals.vcd");                                        
    //     $dumpvars(0,testbench); // testbench  serial_to_parallel
    // end

    logic [width-1:0] serial_buffer, new_buffer;
    logic [$clog2(width):0] serial_counter;
    logic flag_comb, flag_ff;

  // State transition logic
  always_comb
  begin
    new_buffer = serial_buffer;

    if(serial_valid)
    begin
        // new_buffer = {serial_data, serial_buffer[width-1, 1]};
        // new_buffer[width-2:0] <= serial_buffer[width-1, 1];

        // new_buffer[0] = serial_buffer[1];
        // new_buffer[1] = serial_buffer[2];
        // new_buffer[2] = serial_buffer[3];
        // new_buffer[3] = serial_buffer[4];
        // new_buffer[4] = serial_buffer[5];
        // new_buffer[5] = serial_buffer[6];
        // new_buffer[6] = serial_buffer[7];
        // new_buffer[7] = serial_data;

        new_buffer[7] = serial_buffer[6];
        new_buffer[6] = serial_buffer[5];
        new_buffer[5] = serial_buffer[4];
        new_buffer[4] = serial_buffer[3];
        new_buffer[3] = serial_buffer[2];
        new_buffer[2] = serial_buffer[1];
        new_buffer[1] = serial_buffer[0];
        new_buffer[0] = serial_data;

        if(serial_counter == width)
        begin
            parallel_valid <= '1;
            // parallel_data <= {serial_data, serial_buffer[7:1]};
            parallel_data <= {serial_buffer[6:0], serial_data};
            // new_buffer <= '0;
            serial_counter <= '0;
        end
        else
            parallel_valid = '0;
            parallel_data = '0;
    end
    else
    begin
      parallel_valid <= '0;
      parallel_data <= '0;
    end


    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    // case (state)
    //   st_equal       : if (~ a &   b) new_state = st_a_less_b;
    //               else if (  a & ~ b) new_state = st_a_greater_b;
    //   st_a_less_b    : new_state = st_a_less_b;  // if (  a & ~ b) new_state = st_a_greater_b;
    //   st_a_greater_b : new_state = st_a_greater_b;  // if (~ a &   b) new_state = st_a_less_b;
    // endcase

    // verilator lint_on  CASEINCOMPLETE
  end

  // Output logic
//   assign { a_less_b, a_eq_b, a_greater_b } = new_state;

  always_ff @ (posedge clk)
    if (rst)
    begin
      serial_buffer <= '0;
      serial_counter <= '0;
    end
    else if(serial_valid)
    begin
      serial_buffer <= new_buffer;
      serial_counter <= serial_counter + 1'b1;
    end

endmodule
