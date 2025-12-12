//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

// A non-parameterized module
// that implements the signed multiplication of 4-bit numbers
// which produces 8-bit result

module signed_mul_4
(
  input  signed [3:0] a, b,
  output signed [7:0] res
);

  assign res = a * b;

endmodule

// A parameterized module
// that implements the unsigned multiplication of N-bit numbers
// which produces 2N-bit result

module unsigned_mul
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  output [2 * n - 1:0] res
);

  assign res = a * b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

// Task:
//
// Implement a parameterized module
// that produces either signed or unsigned result
// of the multiplication depending on the 'signed_mul' input bit.

module signed_or_unsigned_mul
#(
  parameter int n = 8
)
(
  input  [    n - 1:0] a, b,
  input                signed_mul,
  output [2 * n - 1:0] res
);

  wire signed [2*n-1:0] a_s = $signed({{n{a[n-1]}}, a});
  wire signed [2*n-1:0] b_s = $signed({{n{b[n-1]}}, b});

  wire        [2*n-1:0] a_u = {{n{1'b0}}, a};
  wire        [2*n-1:0] b_u = {{n{1'b0}}, b};

  wire signed [2*n-1:0] prod_s = a_s * b_s;
  wire        [2*n-1:0] prod_u = a_u * b_u;

  // Выбор режима
  assign res = signed_mul ? prod_s[2*n-1:0] : prod_u;

endmodule