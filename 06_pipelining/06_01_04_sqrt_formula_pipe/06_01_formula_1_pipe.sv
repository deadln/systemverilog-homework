//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res


    // output as_vld,
    // output bs_vld,
    // output cs_vld,
    // output [31:0] as,
    // output [31:0] bs,
    // output [31:0] cs
);

    // logic as_vld;
    // logic bs_vld;
    // logic cs_vld;
    // logic [31:0] as;
    // logic [31:0] bs;
    // logic [31:0] cs;
    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
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

    // isqrt i1(clk, rst, arg_vld, a, as_vld, as);
    // isqrt i2(clk, rst, arg_vld, b, bs_vld, bs);
    // isqrt i3(clk, rst, arg_vld, c, cs_vld, cs);

    logic input_stage_a_valid;
    logic input_stage_b_valid;
    logic input_stage_c_valid;

    logic [31:0] input_stage_a;
    logic [31:0] input_stage_b;
    logic [31:0] input_stage_c;

    logic sqrt_a_valid;
    logic sqrt_b_valid;
    logic sqrt_c_valid;

    logic [31:0] sqrt_a;
    logic [31:0] sqrt_b;
    logic [31:0] sqrt_c;

    always_ff @ (posedge clk or posedge rst)
        if (rst) begin
            input_stage_a_valid <= '0;
            input_stage_b_valid <= '0;
            input_stage_c_valid <= '0;
        end
        else begin
            input_stage_a_valid <= arg_vld;
            input_stage_b_valid <= arg_vld;
            input_stage_c_valid <= arg_vld;
        end

    // Input data pipeline
    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_a <= a;

    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_b <= b;
            
    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_c <= c;

    isqrt i1(clk, rst, input_stage_a_valid, input_stage_a, sqrt_a_valid, sqrt_a);
    isqrt i2(clk, rst, input_stage_b_valid, input_stage_b, sqrt_b_valid, sqrt_b);
    isqrt i3(clk, rst, input_stage_c_valid, input_stage_c, sqrt_c_valid, sqrt_c);

    assign res_vld = sqrt_a_valid && sqrt_b_valid && sqrt_c_valid;
    assign res = sqrt_a + sqrt_b + sqrt_c;

    // always_comb begin
    //     if(sqrt_a_valid && sqrt_b_valid && sqrt_c_valid)
    // end

    // always_ff @ (posedge clk)
    // begin

    // end


endmodule
