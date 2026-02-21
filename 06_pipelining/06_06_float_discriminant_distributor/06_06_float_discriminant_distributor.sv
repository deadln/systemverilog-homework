module float_discriminant_distributor (
    input                           clk,
    input                           rst,

    input                           arg_vld,
    input        [64 - 1:0]       a,
    input        [64 - 1:0]       b,
    input        [64 - 1:0]       c,

    output logic                    res_vld,
    output logic [64 - 1:0]       res,
    output logic                    res_negative,
    output logic                    err,

    output logic                    busy
);

    // Task:
    //
    // Implement a module that will calculate the discriminant based
    // on the triplet of input number a, b, c. The module must be pipelined.
    // It should be able to accept a new triple of arguments on each clock cycle
    // and also, after some time, provide the result on each clock cycle.
    // The idea of the task is similar to the task 04_11. The main difference is
    // in the underlying module 03_08 instead of formula modules.
    //
    // Note 1:
    // Reuse your file "03_08_float_discriminant.sv" from the Homework 03.
    //
    // Note 2:
    // Latency of the module "float_discriminant" should be clarified from the waveform.

    localparam N = 16;

    logic [N-1:0] input_stage_valid;

    logic [64-1:0] input_stage_a;
    logic [64-1:0] input_stage_b;
    logic [64-1:0] input_stage_c;


    logic [$clog2(N)-1:0] input_index;
    logic [$clog2(N)-1:0] output_index;

    logic [N-1:0] res_vld_internal;
    logic [64-1:0] res_internal [N-1:0];
    logic [N-1:0] res_neg_internal;
    logic [N-1:0] err_internal;
    logic [N-1:0] busy_internal;

    always_ff @ (posedge clk or posedge rst)
        if (rst) begin
            input_stage_valid <= '0;
            input_index <= '0;
            // output_index <= '0;
        end
        else 
        begin
            input_stage_valid <= '0;
            if (arg_vld)
            begin
                input_stage_valid[input_index] <= arg_vld;
                input_index <= input_index + 1'd1;
                input_stage_a <= a;
                input_stage_b <= b;
                input_stage_c <= c;
                // if(input_index == N)
                //     input_index <= '0;
            end
        end
        // else
        // begin
        //     input_stage_valid[input_index] <= arg_vld;
        // end

    // Input data pipeline
    // always_ff @ (posedge clk)
    //     if (arg_vld)
    //     begin
    //         input_index <= input_index + 1;
    //         if(input_index == N)
    //             input_index <= '0;
    //     end

    // Input data pipeline
    // always_ff @ (posedge clk)
    //     if (arg_vld)
    //         input_stage_a <= a;

    // always_ff @ (posedge clk)
    //     if (arg_vld)
    //         input_stage_b <= b;
            
    // always_ff @ (posedge clk)
    //     if (arg_vld)
    //         input_stage_c <= c;

    generate

        genvar i;

        for(i = 0; i < N; i++)
        begin
            float_discriminant fd1  // Задержка 1 тактов  [N-1:0]
            (
                .clk            ( clk         ),
                .rst            ( rst         ),
                .arg_vld        ( input_stage_valid[i] ),  // input_stage_valid
                .a              ( input_stage_a     ),  // a_input_stage
                .b              ( input_stage_b     ),  // b_input_stage
                .c              ( input_stage_c     ),  // c_input_stage
                .res_vld        (res_vld_internal[i]),  // (res_vld_internal[0]),
                .res            (res_internal[i]),  // (res_internal[0])
                .res_negative   (res_neg_internal[i]),  // (res_neg_internal[0]),
                .err            (err_internal[i]),  // (err_internal[0]),
                .busy           (busy_internal[i])  // (busy_internal[0])
            );
        end


    endgenerate


    // TODO: сделать несколько модулей руками, потом 
    // float_discriminant fd1  // Задержка 1 тактов  [N-1:0]
    // (
    //     .clk            ( clk         ),
    //     .rst            ( rst         ),
    //     .arg_vld        ( input_stage_valid[0] ),  // input_stage_valid
    //     .a              ( input_stage_a     ),  // a_input_stage
    //     .b              ( input_stage_b     ),  // b_input_stage
    //     .c              ( input_stage_c     ),  // c_input_stage
    //     .res_vld        (res_vld_internal[0]),  // (res_vld_internal[0]),
    //     .res            (res_internal[0]),  // (res_internal[0])
    //     .res_negative   (res_neg_internal[0]),  // (res_neg_internal[0]),
    //     .err            (err_internal[0]),  // (err_internal[0]),
    //     .busy           (busy_internal[0])  // (busy_internal[0])
    // );

    // float_discriminant fd2  // Задержка 1 тактов  [N-1:0]
    // (
    //     .clk            ( clk         ),
    //     .rst            ( rst         ),
    //     .arg_vld        ( input_stage_valid[1] ),  // input_stage_valid
    //     .a              ( input_stage_a     ),  // a_input_stage
    //     .b              ( input_stage_b     ),  // b_input_stage
    //     .c              ( input_stage_c     ),  // c_input_stage
    //     .res_vld        (res_vld_internal[1]),
    //     .res            (res_internal[1]),
    //     .res_negative   (res_neg_internal[1]),
    //     .err            (err_internal[1]),
    //     .busy           (busy_internal[1])
    // );

    always_ff @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            output_index <= '0;
            
            // for(int i = 0; i < N; i++)
            // begin
            //     res_vld_internal[i] <= '0;
            //     res_internal[i] <= '0;
            //     res_neg_internal[i] <= '0;
            //     err_internal[i] <= '0;
            //     busy_internal[i] <= '0;
            // end
        end
        else if(res_vld)
        begin
            output_index <= output_index + 1'b1;
            // for(int i = 0; i < N; i++)
            // begin
            //     if(res_vld_internal[i])
            //     begin
            //         res <= res_internal[i];
            //         res_vld <= res_vld_internal[i];
            //         // res_vld_internal[i] <= '0;
            //         res_negative <= res_neg_internal[i];
            //         err <= err_internal[i];
            //         busy <= busy_internal[i];
            //     end
            // end
        end
    end

    assign res_vld = res_vld_internal[output_index];
    assign res          = res_internal[output_index];
    assign res_negative = res_neg_internal[output_index];
    assign err          = err_internal[output_index];
    assign busy         = &busy_internal;

endmodule
