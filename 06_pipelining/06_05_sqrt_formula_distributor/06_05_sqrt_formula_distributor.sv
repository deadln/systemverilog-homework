module sqrt_formula_distributor
# (
    parameter formula = 1,
              impl    = 1
)
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output logic        res_vld,
    output logic [31:0] res
);

    // Task:
    //
    // Implement a module that will calculate formula 1 or formula 2
    // based on the parameter values. The module must be pipelined.
    // It should be able to accept new triple of arguments a, b, c arriving
    // at every clock cycle.
    //
    // The idea of the task is to implement hardware task distributor,
    // that will accept triplet of the arguments and assign the task
    // of the calculation formula 1 or formula 2 with these arguments
    // to the free FSM-based internal module.
    //
    // The first step to solve the task is to fill 03_04 and 03_05 files.
    //
    // Note 1:
    // Latency of the module "formula_1_isqrt" should be clarified from the corresponding waveform
    // or simply assumed to be equal 50 clock cycles.
    //
    // Note 2:
    // The task assumes idealized distributor (with 50 internal computational blocks),
    // because in practice engineers rarely use more than 10 modules at ones.
    // Usually people use 3-5 blocks and utilize stall in case of high load.
    //
    // Hint:
    // Instantiate sufficient number of "formula_1_impl_1_top", "formula_1_impl_2_top",
    // or "formula_2_top" modules to achieve desired performance.

    // formula_1_impl_1_top f1_i1( // 14 тактов

    // formula_1_impl_2_fsm f1_i2( // 34 такта

    // formula_2_fsm i_formula_2_fsm (.*); // 50 тактов

    localparam N = 64;

    logic [N-1:0] arg_vld_input_stage;
    logic [31:0] a_input_stage [0:N-1];
    logic [31:0] b_input_stage [0:N-1];
    logic [31:0] c_input_stage [0:N-1];

    logic [$clog2(N)-1:0] input_index;
    logic [$clog2(N)-1:0] output_index;

    logic [N-1:0] res_vld_arr1;
    // logic [N-1:0] res_vld_arr2;
    // logic [N-1:0] res_vld_arr3;
    logic [31:0] res_mux [0:N-1];

    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            arg_vld_input_stage <= '0;
            input_index <= '0;
            // res_vld_arr1 <= '0;
            // res_vld_arr2 <= '0;
            // res_vld_arr3 <= '0;
            for (int i = 0; i < N; i ++)
            begin
                a_input_stage[i] <= '0;
                b_input_stage[i] <= '0;
                c_input_stage[i] <= '0;
            end
        end
        else// if(arg_vld)
        begin
            arg_vld_input_stage <= '0;
            if(arg_vld)
            begin
                arg_vld_input_stage [input_index] <= arg_vld;
                a_input_stage[input_index] <= a;
                b_input_stage[input_index] <= b;
                c_input_stage[input_index] <= c;
                input_index <= input_index + 1;
            end
        end
    end

    

    generate
        genvar i;
        if(formula == 1 && impl == 1)
            for (i = 0; i < N; i ++)
            begin
                formula_1_impl_1_top f1i1//[N-1:0]
                        (
                            .clk     ( clk         ),
                            .rst     ( rst         ),
                            .arg_vld ( arg_vld_input_stage[i] ),
                            .a       ( a_input_stage[i]     ),
                            .b       ( b_input_stage[i] ),
                            .c       ( c_input_stage[i]     ),
                            .res_vld (res_vld_arr1[i]),
                            .res     (res_mux[i])
                        );
            end
        else if(formula == 1 && impl == 2)
        for (i = 0; i < N; i ++)
            begin
                formula_1_impl_2_top f1i2//[N-1:0]
                    (
                        .clk     ( clk         ),
                        .rst     ( rst         ),
                        .arg_vld ( arg_vld_input_stage[i] ),
                        .a       ( a_input_stage[i]     ),
                        .b       ( b_input_stage[i] ),
                        .c       ( c_input_stage[i]     ),
                        .res_vld (res_vld_arr1[i]),
                        .res     (res_mux[i])
                    );
            end
        else if(formula == 2)
        for (i = 0; i < N; i ++)
            begin
                formula_2_top f1i2//[N-1:0]
                    (
                        .clk     ( clk         ),
                        .rst     ( rst         ),
                        .arg_vld ( arg_vld_input_stage[i] ),
                        .a       ( a_input_stage[i]     ),
                        .b       ( b_input_stage[i] ),
                        .c       ( c_input_stage[i]     ),
                        .res_vld (res_vld_arr1[i]),
                        .res     (res_mux[i])
                    );
            end


        // for (i = 0; i < N; i ++)
        // begin
        //     if(formula == 1)
        //     begin
        //         if(impl == 1)
        //         begin
        //             formula_1_impl_1_top f1i1[N-1:0]
        //             (
        //                 .clk     ( clk         ),
        //                 .rst     ( rst         ),
        //                 .arg_vld ( arg_vld_input_stage ),
        //                 .a       ( a_input_stage[i]     ),
        //                 .b       ( b_input_stage[i] ),
        //                 .c       ( c_input_stage[i]     ),
        //                 .res_vld (res_vld_arr1),
        //                 .res     (res_mux[i])
        //             );
        //         end
        //         else
        //         begin
        //             formula_1_impl_2_top f1i2[N-1:0]
        //             (
        //                 .clk     ( clk         ),
        //                 .rst     ( rst         ),
        //                 .arg_vld ( arg_vld_input_stage ),
        //                 .a       ( a_input_stage[i]     ),
        //                 .b       ( b_input_stage[i] ),
        //                 .c       ( c_input_stage[i]     ),
        //                 .res_vld (res_vld_arr2),
        //                 .res     (res_mux[i])
        //             );
        //         end
        //     end
        //     else
        //     begin
        //         formula_2_top f2[N-1:0]
        //         (
        //             .clk     ( clk         ),
        //             .rst     ( rst         ),
        //             .arg_vld ( arg_vld_input_stage ),
        //             .a       ( a_input_stage[i]     ),
        //             .b       ( b_input_stage[i] ),
        //             .c       ( c_input_stage[i]     ),
        //             .res_vld (res_vld_arr3),
        //             .res     (res_mux[i])
        //         );
        //     end
        // end
    endgenerate

    always_ff @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            output_index <= '0;
        end
        else if(res_vld)
        begin
            output_index <= output_index + 1'b1;
        end
    end

    assign res_vld = res_vld_arr1[output_index];
    assign res = res_mux[output_index];

    // for (int i = 0; i < N; i ++)
    // begin
    //     if(formula == 1)
    //     begin

    //     end
    //     else if(formula == 2)
    // end

endmodule
