//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  logic n_a, n_b;
  logic m_and_1, res_and_1, m_and_2, res_and_2, m_or;

  // ~A ~B
  mux mux_not_a(1'b1, 1'b0, a, n_a);
  mux mux_not_b(1'b1, 1'b0, b, n_b);

  // AND gate 1
  mux mux_and_1(1'b0, 1'b1, a, m_and_1);
  mux mux_and_2(1'b0, n_b, m_and_1, res_and_1);

  // AND gate 2
  mux mux_and_3(1'b0, 1'b1, n_a, m_and_2);
  mux mux_and_4(1'b0, b, m_and_2, res_and_2);

  // OR gate
  mux mux_or_1(res_and_1, res_and_1, res_and_1, m_or);
  mux mux_or_2(res_and_2, 1'b1, m_or, o);


endmodule
