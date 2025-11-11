//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01


    // States
  enum logic[1:0]
  {
     worker_inactive = 2'b00,
     worker_0        = 2'b01,
     worker_1        = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (requests)
      2'b00: new_state = worker_inactive;
      2'b01: new_state = worker_0;
      2'b10: new_state = worker_1;
      2'b11: if(state == worker_inactive || state == worker_1) new_state = worker_0;
             else new_state = worker_1;
      default: new_state = state;
    endcase

    // verilator lint_on  CASEINCOMPLETE
  end

  // Output logic
  assign grants = new_state;

  always_ff @ (posedge clk)
    if (rst)
      state <= worker_inactive;
    else
      state <= new_state;

endmodule
