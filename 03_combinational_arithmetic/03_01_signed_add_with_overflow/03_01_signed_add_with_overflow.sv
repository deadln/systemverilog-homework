//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

module s_add
(
  // input  clk,
  // input  rst,
  input  a,
  input  b,
  input carry,
  output sum,
  output carry_d
);

  // Task:
  // Implement a serial adder using only ^ (XOR), | (OR), & (AND), ~ (NOT) bitwise operations.
  //
  // Notes:
  // See Harris & Harris book
  // or https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder webpage
  // for information about the 1-bit full adder implementation.
  //
  // See the testbench for the output format ($display task).

  // logic carry;
  // wire carry_d;

  assign { carry_d, sum } = {a & b | a & carry | b & carry, a ^ b ^ carry};

  // always_ff @ (posedge clk)
  //   if (rst)
  //     carry <= '0;
  //   else
  //     carry <= carry_d;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_overflow
(
  input  [3:0] a, b,
  output [3:0] sum,
  output       overflow
);

  // Task:
  //
  // Implement a module that adds two signed numbers
  // and detects an overflow.
  //
  // By "signed" we mean "two's complement numbers".
  // See https://en.wikipedia.org/wiki/Two%27s_complement for details.
  //
  // The 'overflow' output bit should be set to 1
  // when the resulting sum (either positive or negative)
  // of two input arguments is greater or less than
  // 4-bit maximum or minimum signed number.
  //
  // Otherwise the 'overflow' should be set to 0.

  logic c1, c2, c3, c4;

  s_add a1(a[0], b[0], 0, sum[0], c1);
  s_add a2(a[1], b[1], c1, sum[1], c2);
  s_add a3(a[2], b[2], c2, sum[2], c3);
  s_add a4(a[3], b[3], c3, sum[3], c4);
  
  assign overflow = ~ a[3] & ~ b[3] & sum[3] | a[3] & b[3] & ~ sum[3] & c4;

endmodule
