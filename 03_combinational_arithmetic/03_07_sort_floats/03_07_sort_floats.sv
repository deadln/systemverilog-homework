//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module sort_two_floats_ab (
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,

    output logic [FLEN - 1:0] res0,
    output logic [FLEN - 1:0] res1,
    output                    err
);

    logic a_less_or_equal_b;

    f_less_or_equal i_floe (
        .a   ( a                 ),
        .b   ( b                 ),
        .res ( a_less_or_equal_b ),
        .err ( err               )
    );

    always_comb begin : a_b_compare
        if ( a_less_or_equal_b ) begin
            res0 = a;
            res1 = b;
        end
        else
        begin
            res0 = b;
            res1 = a;
        end
    end

endmodule

//----------------------------------------------------------------------------
// Example - different style
//----------------------------------------------------------------------------

module sort_two_floats_array
(
    input        [0:1][FLEN - 1:0] unsorted,
    output logic [0:1][FLEN - 1:0] sorted,
    output                         err
);

    logic u0_less_or_equal_u1;

    f_less_or_equal i_floe
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( u0_less_or_equal_u1 ),
        .err ( err                 )
    );

    always_comb
        if (u0_less_or_equal_u1)
            sorted = unsorted;
        else
              {   sorted [0],   sorted [1] }
            = { unsorted [1], unsorted [0] };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_three_floats (
    input        [0:2][FLEN - 1:0] unsorted,
    output logic [0:2][FLEN - 1:0] sorted,
    output                         err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order.
    // The module should be combinational with zero latency.
    // The solution can use up to three instances of the "f_less_or_equal" module.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res2
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.

    // localparam [FLEN - 1:0] inf     = {0, {NE{1'b1}}, {NF{1'b0}}},  // 64'h7FF0_0000_0000_0000,
    //                         neg_inf = {1, {NE{1'b1}}, {NF{1'b0}}},  // 64'hFFF0_0000_0000_0000,
    //                         zero    = {0, {NE{1'b0}}, {NF{1'b0}}},  // 64'h0000_0000_0000_0000,
    //                         nan     = {0, {NE{1'b1}}, {NF{1'b1}}};  // 64'h7FF1_2345_6789_ABCD;

    // Nan Inf check
    // NE Nan

    logic err1;
    logic err2;
    logic err3;

    logic less_or_equal_1;
    logic less_or_equal_2;
    logic less_or_equal_3;

    logic [0:1][FLEN - 1:0] unsorted_buff;
    logic [FLEN - 1:0] bigger_number_1;
    logic [FLEN - 1:0] bigger_number_2;

    f_less_or_equal i_floe_1
    (
        .a   ( unsorted [0]        ),
        .b   ( unsorted [1]        ),
        .res ( less_or_equal_1 ),
        .err ( err1                 )
    );
    always_comb
        /*if(err)
        else*/ if (less_or_equal_1)
        begin
            bigger_number_1 = unsorted [1];
            unsorted_buff[0] = unsorted [0];
        end
        else
        begin
            bigger_number_1 = unsorted [0];
            unsorted_buff[0] = unsorted [1];
        end
    
    f_less_or_equal i_floe_2
    (
        .a   ( bigger_number_1        ),
        .b   ( unsorted [2]        ),
        .res ( less_or_equal_2 ),
        .err ( err2                 )
    );
    always_comb
        if (less_or_equal_2)
        begin
            sorted[2] = unsorted [2];
            unsorted_buff[1] = bigger_number_1;
        end
        else
        begin
            sorted[2] = bigger_number_1;
            unsorted_buff[1] = unsorted [2];
        end

    f_less_or_equal i_floe_3
    (
        .a   ( unsorted_buff [0]        ),
        .b   ( unsorted_buff [1]        ),
        .res ( less_or_equal_3 ),
        .err ( err3                 )
    );

    always_comb
        if (less_or_equal_3)
            sorted[1:0] = unsorted_buff;
        else
              {   sorted [0],   sorted [1] }
            = { unsorted_buff [1], unsorted_buff [0] };

    assign err = err1 | err2 | err3;

endmodule
