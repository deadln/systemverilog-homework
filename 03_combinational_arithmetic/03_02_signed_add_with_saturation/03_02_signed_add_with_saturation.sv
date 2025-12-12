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

module check_overflow
(
  input c1,c2,c3,
  output res

);

  assign res = ~ c1 & ~ c2 & c3;

endmodule

module check_underflow
(
  input c1,c2,c3,c4,
  output res

);

  assign res = c1 & c2 & ~ c3 & c4;

endmodule

// module set_max
// (
//   output [3:0] val
// );
//   always_comb
//   assign val = 4'b0111
// endmodule

// module set_min
// (
//   output [3:0] val
// );
//   always_comb
//   assign val = 4'b1101
// endmodule

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

module signed_add_with_saturation
(
  input  [3:0] a, b,
  output logic [3:0] sum
);

  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.

    wire c1, c2, c3, c4;
    wire ov_var, un_var;
    wire [3:0] res;
    // logic [3:0] up_const = '1;//4'b0111;
    // logic [3:0] down_const = '0;//4'b1000;//4'b1111;  // конкатенация?

    s_add a1(a[0], b[0], '0, res[0], c1);
    s_add a2(a[1], b[1], c1, res[1], c2);
    s_add a3(a[2], b[2], c2, res[2], c3);
    s_add a4(a[3], b[3], c3, res[3], c4);

    // check_overflow co(c1, c2, c3, ov_var);
    // check_underflow cu(c1, c2, c3, c4, un_var);
    // always_comb
    // begin
    // end
  // always_comb
  // begin
    // assign ov_var = ~ c1 & ~ c2 & c3;
    // assign un_var = c1 & c2 & ~ c3 & c4;
    // always_comb // тернарный оператор
    //   if (ov_var)
    //     // set_max mx(sum);
    //     sum = up_const;
    //   else if (un_var)
    //   //   // set_min mn(sum);
    //     sum = down_const;
    //   else
    //     sum = res;


    // assign ov_var = (~ a[3] & ~ b[3] & sum[3]);
    // assign un_var = (a[3] & b[3] & ~ sum[3] & c4);
    // assign sum = (ov_var | un_var) ? (un_var ? 4'b1000 : 4'b0111) : res;  // ЗАВИСАЕТ ПРИ ПРОВЕРКЕ 	•`_´•

    wire sum_sign;
    wire overflow;

    assign sum_sign = res[3];
    assign overflow = ( a[3] == b[3] ) && (a[3] != sum_sign);
    assign sum = overflow ? (a[3] ? 4'b1000 : 4'b0111) : res;

  


endmodule
