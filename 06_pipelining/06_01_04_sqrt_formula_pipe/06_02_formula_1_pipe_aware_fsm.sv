//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0

    // TODO: убрать, т.к. не используется
    // logic input_stage_a_valid;
    // logic input_stage_b_valid;
    // logic input_stage_c_valid;

    logic [31:0] input_stage_a;
    logic [31:0] input_stage_b;
    logic [31:0] input_stage_c;

    logic [2:0]  sqrt_counter;
    logic [31:0] sqrt_sum;

    logic check_if_1;
    logic check_if_2;
    logic output_res_flag;

    // logic sqrt_a_valid;
    // logic sqrt_b_valid;
    // logic sqrt_c_valid;

    // logic [31:0] sqrt_a;
    // logic [31:0] sqrt_b;
    // logic [31:0] sqrt_c;

    //------------------------------------------------------------------------
    // States

    enum logic [1:0]
    {
        st_set_a       = 2'd0,
        st_set_b = 2'd1,
        st_set_c = 2'd2
    }
    state, next_state;

    //------------------------------------------------------------------------
    
    // Input valid logic
    // always_ff @ (posedge clk or posedge rst)
    //     if (rst) begin
    //         input_stage_a_valid <= '0;
    //         input_stage_b_valid <= '0;
    //         input_stage_c_valid <= '0;
    //     end
    //     else begin
    //         input_stage_a_valid <= arg_vld;
    //         input_stage_b_valid <= arg_vld;
    //         input_stage_c_valid <= arg_vld;
    //     end

    
    // Input data pipeline TODO: возможно перенести во внутреннее состояние с помощью условия
    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_a <= a;

    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_b <= b;
            
    always_ff @ (posedge clk)
        if (arg_vld)
            input_stage_c <= c;

    //------------------------------------------------------------------------
    // Next state and isqrt interface
    always_comb
    begin
        next_state  = state;

        isqrt_x_vld = '0;
        isqrt_x     = 'x;  // Don't care

        // This lint warning is bogus because we assign the default value above
        // verilator lint_off CASEINCOMPLETE

        case (state)
        st_set_a:
        begin
            isqrt_x = a;

            if (arg_vld)
            begin
                isqrt_x_vld = '1;
                next_state  = st_set_b;
            end
        end

        st_set_b:
        begin
            isqrt_x = input_stage_b;
            isqrt_x_vld = '1;
            next_state  = st_set_c;
        end

        st_set_c:
        begin
            isqrt_x = input_stage_c;
            isqrt_x_vld = '1;
            next_state  = st_set_a;
        end

        endcase

        // verilator lint_on  CASEINCOMPLETE

    end
    //------------------------------------------------------------------------

    //------------------------------------------------------------------------
    // Assigning next state

    always_ff @ (posedge clk)
        if (rst)
            state <= st_set_a;
        else
            state <= next_state;

    //------------------------------------------------------------------------

    //------------------------------------------------------------------------
    // Accumulating the result

    // always_ff @ (posedge clk)
    //     if (rst)
    //         res_vld <= '0;
    //     else
    //         res_vld <= (sqrt_counter == 3'd3);// && isqrt_y_vld);

    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            res_vld <= '0;
            sqrt_sum = '0;
            sqrt_counter = '0;
            output_res_flag = '0;

            check_if_1 = '0;
            check_if_2 = '0;
        end
        else if (isqrt_y_vld)
        begin
            if(sqrt_counter == 3'd3 && res_vld)
            begin
                res_vld <= '0;
                sqrt_sum = '0;
                sqrt_counter = '0;
            end
            check_if_1 = '1;
            sqrt_sum = sqrt_sum + isqrt_y;
            sqrt_counter = sqrt_counter + 1'd1;
            if(sqrt_counter == 3'd3)
            begin
                check_if_2 = '1;
                // output_res_flag = '1;
                res_vld <= '1;
                res <= sqrt_sum;
                sqrt_sum <= '0;
                sqrt_counter = '0;
            end
            // else if (output_res_flag)
            //     output_res_flag = '0;
        end
        else
        begin
            res_vld <= '0;
            check_if_1 = '0;
            check_if_2 = '0;
        end
    end
    

endmodule
