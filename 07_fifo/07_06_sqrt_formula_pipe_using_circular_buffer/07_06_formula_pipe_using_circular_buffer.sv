//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe_using_circular
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
    // Implement a pipelined module formula_2_pipe_using_circular
    // that computes the result of the formula defined in the file formula_2_fn.svh.
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
    // 3. Your solution should use circular buffers instead of shift registers
    // which were used in 06_04_formula_2_pipe.sv.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    // isqrt DELAY: 16 clock cycles

    localparam width = 32;
    localparam stages = 16;

    logic isqrt1_in_vld;
    logic isqrt2_in_vld;
    logic isqrt3_in_vld;
    logic isqrt1_out_vld;
    logic isqrt2_out_vld;
    logic isqrt3_out_vld;

    logic b_delayed_vld;
    logic a_delayed_vld;

    logic [width-1:0] b_delayed;
    logic [width-1:0] a_delayed;

    logic [width-1:0] isqrt1_output;
    logic [width-1:0] isqrt2_output;
    logic [width-1:0] isqrt3_output;

    logic [width-1:0] cb_sum;
    logic [width-1:0] ba_sum;

    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            // isqrt1_out_vld <= '0;
            // isqrt2_out_vld <= '0;
            // isqrt3_out_vld <= '0;
            isqrt1_in_vld <= '0;
            isqrt2_in_vld <= '0;
            isqrt3_in_vld <= '0;
        end
        if(isqrt1_out_vld)
        begin
            cb_sum = isqrt1_output + b_delayed;
        end
        if(isqrt2_out_vld)
        begin
            ba_sum = isqrt2_output + a_delayed;
        end
 
        isqrt2_in_vld <= b_delayed_vld;
        isqrt3_in_vld <= a_delayed_vld;

    end

//     circular_buffer_with_valid # ( width, stages )
// (
//     input                clk,
//     input                rst,

//     input                in_valid,
//     input  [width - 1:0] in_data,

//     output logic              out_valid,
//     output logic [width - 1:0] out_data
// );

    circular_buffer_with_valid # (width, stages) cb1(clk, rst, arg_vld, b, b_delayed_vld, b_delayed);
    circular_buffer_with_valid # (width, stages*2+1) sr2(clk, rst, arg_vld, a, a_delayed_vld, a_delayed);

    isqrt i1(clk, rst, arg_vld, c, isqrt1_out_vld, isqrt1_output);
    isqrt i2(clk, rst, isqrt2_in_vld, cb_sum, isqrt2_out_vld, isqrt2_output);
    isqrt i3(clk, rst, isqrt3_in_vld, ba_sum, res_vld, res);

endmodule
