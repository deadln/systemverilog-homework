//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

    // Task:
    //
    // Implement a pipelined module formula_2_pipe that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    localparam width = 32;
    localparam stages = 5;

    logic isqrt1_vld;
    logic isqrt2_vld;
    logic isqrt3_vld;
    logic isqrt1_out_vld;
    logic isqrt2_out_vld;
    logic isqrt3_out_vld;

    logic [width-1:0] isqrt1_data;
    logic [width-1:0] isqrt2_data;
    logic [width-1:0] isqrt3_data;

    logic [width-1:0] cb_sum;
    logic [width-1:0] ba_sum;

    always_ff @ (posedge clk)
    begin
        if(isqrt1_vld)
    end

    shift_register_with_valid # (width, stages+1) sr1(clk, rst, arg_vld, b, isqrt2_vld, isqrt2_data);
    shift_register_with_valid # (width, stages*2+1) sr2(clk, rst, arg_vld, a, isqrt3_vld, isqrt3_data);

    isqrt i1(clk, rst, arg_vld, c, isqrt1_vld, isqrt1_data);
    isqrt i2(clk, rst, isqrt2_vld, cb_sum, sqrt_b_valid, sqrt_b);
    isqrt i3(clk, rst, isqrt3_vld, ba_sum, sqrt_c_valid, sqrt_c);


endmodule
