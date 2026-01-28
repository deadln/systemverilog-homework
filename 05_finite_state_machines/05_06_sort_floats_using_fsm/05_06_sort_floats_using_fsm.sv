//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err,

    output logic                   valid_check
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.

    /*
        Сортировать пузырьком
        Сделать состояния IDLE и состояния ожидания сравнения на каждой итерации пузырька
    */

    logic [0:2][FLEN - 1:0] unsorted_internal;
    logic [0:2][FLEN - 1:0] unsorted_input;

    enum logic [3:0]
    {
        st_idle       = 4'd0,
        st_compare_1_ab = 4'd1,
        st_reset_cmp_1  = 4'd2,
        st_compare_2_bc = 4'd3,
        st_reset_cmp_2  = 4'd4,
        st_compare_3_ac = 4'd5,
        st_reset_cmp_3  = 4'd6,
        st_sorted       = 4'd7,
        st_error        = 4'd8
    }
    state, next_state;

    always_comb
    begin
        next_state = state;

        case (state)

        st_idle:
        begin
            // valid_check = (unsorted_internal[1] != {FLEN{1'bx}});

            if (valid_in)
            begin
                // f_le_a = unsorted[0];
                // f_le_b = unsorted[1];
                next_state  = st_compare_1_ab;
            end
        end

        st_compare_1_ab:
        begin
            f_le_a = unsorted_input[0];
            f_le_b = unsorted_input[1];

            if(f_le_err == '1)
                next_state  = st_error;
            else
                next_state  = st_reset_cmp_1;
        end

        st_reset_cmp_1:
        begin
            // if(f_le_err == '1)
            //     next_state = st_error;
            // else
                next_state  = st_compare_2_bc;
            f_le_a = {FLEN{1'bx}};
            f_le_b = {FLEN{1'bx}};
        end

        st_compare_2_bc:
        begin
            // valid_check = (f_le_a == {FLEN{1'bx}});
            // if (f_le_a == {FLEN{1'bx}})
            // begin
            f_le_a = unsorted_internal[1];
            f_le_b = unsorted_input[2];

            if(f_le_err == '1)
                next_state  = st_error;
            else
                next_state  = st_reset_cmp_2;
            // end
            // else if(f_le_err == '1)
            // begin
            //     next_state  = st_idle;
            //     valid_out = '1;
            //     err = '1;

            //     f_le_a = {FLEN{1'bx}};
            //     f_le_b = {FLEN{1'bx}};
            // end
        end

        st_reset_cmp_2:
        begin
            // if(f_le_err == '1)
            //     next_state = st_error;
            // else
            next_state  = st_compare_3_ac;
            f_le_a = {FLEN{1'bx}};
            f_le_b = {FLEN{1'bx}};

        end

        st_compare_3_ac:
        begin
            // valid_check = (unsorted_internal[1] != 'x);

            // if (unsorted_internal[2] != {FLEN{1'bx}})
            // begin
                f_le_a = unsorted_internal[0];
                f_le_b = unsorted_internal[1];

            if(f_le_err == '1)
                next_state  = st_error;
            else
                next_state  = st_reset_cmp_3;
            // end
            // else if(f_le_err == '1)
            // begin
            //     next_state = st_idle;
            //     valid_out = '1;
            //     err = '1;

            //     f_le_a = {FLEN{1'bx}};
            //     f_le_b = {FLEN{1'bx}};
            // end
        end

        st_reset_cmp_3:
        begin
            // if(f_le_err == '1)
            //     next_state = st_error;
            // else
            next_state  = st_idle;
            f_le_a = {FLEN{1'bx}};
            f_le_b = {FLEN{1'bx}};
        end

        // st_compare_3_ac:
        // begin
        //     next_state = st_sorted;
        //     // f_le_a = {FLEN{1'bx}};
        //     // f_le_b = {FLEN{1'bx}};
        // end

        st_sorted:
        begin
            next_state = st_idle;
        end

        st_error:
        begin
            next_state = st_idle;
            f_le_a = {FLEN{1'bx}};
            f_le_b = {FLEN{1'bx}};
            valid_out <= '1;
            err <= '1;

        end

        // st_wait_b_res:
        // begin
        //     isqrt_x = c;

        //     if (isqrt_y_vld)
        //     begin
        //         isqrt_x_vld = '1;
        //         next_state  = st_wait_c_res;
        //     end
        // end

        // st_wait_c_res:
        // begin
        //     if (isqrt_1_y_vld)
        //     begin
        //         next_state = st_idle;
        //     end
        // end
        endcase

        // verilator lint_on  CASEINCOMPLETE

    end

    always_ff @ (posedge clk)
        if (rst)
            state <= st_idle;
        else
            state <= next_state;

            
    always_ff @ (posedge clk)
        if (rst)
        begin
            valid_out <= '0;
            err <= '0;
            // о <= '0;
        end
        // else if(f_le_err == '1)
        // begin
        //     valid_out <= '1;
        //     err <= '1;

        // end
        else
        begin
            valid_out <= (state == st_reset_cmp_3);  //  & (f_le_res  != {FLEN{1'bx}}));  // Возможно условие готовности результата нужно будет поменять
            sorted <= unsorted_internal;
        end

    always_ff @ (posedge clk)
    // TODO: сохранение в сортирующий массив
        if (state == st_idle)
        begin
            valid_out <= '0;
            err <= '0;
            if(valid_in == '1)
                unsorted_input <= unsorted;
            unsorted_internal <= {{FLEN{1'bx}}, {FLEN{1'bx}}, {FLEN{1'bx}}};
        end
        else if (state == st_compare_1_ab)
        begin
            if(f_le_res)
            begin
                unsorted_internal[0] <= unsorted[0];
                unsorted_internal[1] <= unsorted[1];
            end
            else
            begin
                unsorted_internal[0] <= unsorted[1];
                unsorted_internal[1] <= unsorted[0];
            end
        end
        else if (state == st_compare_2_bc)
        begin
            if(f_le_res)
            begin
                unsorted_internal[1] <= unsorted_internal[1];
                unsorted_internal[2] <= unsorted[2];
            end
            else
            begin
                unsorted_internal[1] <= unsorted[2];
                unsorted_internal[2] <= unsorted_internal[1];
            end
        end
        else if (state == st_compare_3_ac)
        begin
            if(!f_le_res)
            begin
                unsorted_internal[0] <= unsorted_internal[1];
                unsorted_internal[1] <= unsorted_internal[0];
            end
            // else
            // begin
            //     unsorted_internal[1] <= unsorted[2];
            //     unsorted_internal[2] <= unsorted_internal[1];
            // end
        end
        //     res <= res + 32' (isqrt_1_y) + 32' (isqrt_2_y);
        // else if (state == st_wait_c_res & isqrt_1_y_vld)
        //     res <= res + 32' (isqrt_1_y);

endmodule
