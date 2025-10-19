//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux_2_1
(
  input        [3:0] d0, d1,
  input              sel,
  output logic [3:0] y
);

  always_comb
    if (sel)
      y = d1;
    else
      y = d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module mux_4_1
(
  input        [3:0] d0, d1, d2, d3,
  input        [1:0] sel,
  output logic [3:0] y
);

  // Task:
  // Using code for mux_2_1 as an example,
  // write code for 4:1 mux using the "if" statement
  logic mux1, mux2. mux3;

  if(sel[0]) begin
    mux1 = d1;
    mux2 = d3;
  end
  else begin
    mux1 = d0;
    mux2 = d2;
  end
  
  if(sel[1])
    mux3 = mux2;
  else
    mux3 = mux1;

  assign y = mux3;

endmodule
