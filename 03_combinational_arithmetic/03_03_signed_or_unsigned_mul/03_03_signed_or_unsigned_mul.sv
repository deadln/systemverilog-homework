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
# (
  parameter n = 8
)
(
  input  [    n - 1:0] a, b,
  input                signed_mul,
  output [2 * n - 1:0] res
);

  // logic mul_sign;
  // logic [2 * n - 1:0] res_unsigned;

  // always_comb begin
  //   if(signed_mul)
  //   begin
  //     mul_sign = a[n-1] ^ b[n-1];
  //     res_unsigned = a * b;
  //     res = a*b;// {mul_sign, res_unsigned[2 * n - 1:0]};
  //   end
  //   else
  //     res = a * b;
  // end


  wire mul_sign;
  logic [n - 1:0] temp_a;
  logic [n - 1:0] temp_b;
  wire [2 * n - 1:0] res_backup;
  logic [2 * n - 1:0] res_backup2;
  logic [2 * n - 1:0] res_backup_signed;
  logic [1:0] if_statement;

  assign mul_sign = a[n-1] ^ b[n-1];
  assign res_backup = a * b;
  // assign res_backup2 = a[n - 1:0] * b[n - 1:0];
  // assign res_backup_signed = {mul_sign, res_backup2[2 * n - 2:0]};
  always_comb
    if(signed_mul && a[n-1] && b[n-1]) begin
      // Первый вариант (ломается на -7 * -7)
      // res_backup2 = (res_backup - 1) ^ '1;// 8'b11111111;
      // // res_backup_signed = {1'b0, res_backup2[2 * n - 2: 0]};
      // res_backup_signed[2*n - 1] = 1'b0;
      // res_backup_signed[2*n - 2:0] = res_backup2;

      // Второй вариант
      temp_a = (a - 1) ^ '1;// 8'b11111111;
      temp_b = (b - 1) ^ '1;// 8'b11111111;
      res_backup_signed = temp_a * temp_b;
      if_statement = 2'b00;
    end
    // else if(signed_mul && (a == 8'b00000001 || b == 8'b00000001))
    // begin
    //   if(a == 8'b00000001)
    //   begin
    //     // res_backup = b;
    //     res_backup_signed = {4'b0000, b};
    //   end
    //   else
    //   begin
    //     // res_backup = a;
    //     res_backup_signed = {4'b0000, a};
    //   end

    //   if_statement = 2'b11;
    // end
    else if(signed_mul && (a[n-1] || b[n-1]) && a != '0 && b != '0) begin
      // res_backup2 = {1'b1, res_backup[n-2:0]};
      res_backup_signed = (res_backup ^ '1) + 1;  // 8'b11111111;
      if_statement = 2'b01;
    end
    else begin
      res_backup_signed = res_backup;
      if_statement = 2'b10;
    end
      
  assign res = signed_mul ? res_backup_signed : res_backup;

endmodule
