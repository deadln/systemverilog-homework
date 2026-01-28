//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);


    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs their discriminant.
    // The resulting value res should be calculated as a discriminant of the quadratic polynomial.
    // That is, res = b^2 - 4ac == b*b - 4*a*c
    //
    // Note:
    // If any argument is not a valid number, that is NaN or Inf, the "err" flag should be set.
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.


    localparam [FLEN - 1:0] four = 64'h4010_0000_0000_0000;

    // logic [FLEN - 1:0] add_a;
    // logic [FLEN - 1:0] add_b;
    // logic add_up_valid;
    // logic [FLEN - 1:0] add_res;
    // logic              add_down_valid;
    // logic              add_busy;
    // logic              add_error;


    logic [FLEN - 1:0] mult1_a;
    logic [FLEN - 1:0] mult1_b;
    logic mult1_up_valid;
    logic [FLEN - 1:0] mult1_res;
    logic              mult1_down_valid;
    logic              mult1_busy;
    logic              mult1_error;


    logic [FLEN - 1:0] mult2_a;
    logic [FLEN - 1:0] mult2_b;
    logic mult2_up_valid;
    logic [FLEN - 1:0] mult2_res;
    logic              mult2_down_valid;
    logic              mult2_busy;
    logic              mult2_error;


    logic [FLEN - 1:0] sub_a;
    logic [FLEN - 1:0] sub_b;
    logic sub_up_valid;
    logic [FLEN - 1:0] sub_res;
    logic              sub_down_valid;
    logic              sub_busy;
    logic              sub_error;

    logic [FLEN - 1:0] left_statement;
    logic [FLEN - 1:0] right_statement;


    enum logic [2:0]
    {
        st_idle       = 3'd0,
        st_calc_left_right = 3'd1,
        st_mul_right = 3'd2,
        st_sub_both = 3'd3,
        st_error    = 3'd4
    }
    state, next_state;



    always_comb
    begin
        next_state = state;

        mult1_up_valid = '0;
        mult1_a = 'x;
        mult1_b = 'x;
        mult2_up_valid = '0;
        mult2_a = 'x;
        mult2_b = 'x;
        sub_up_valid = '0;
        sub_a = 'x;
        sub_b = 'x;

        case (state)

            st_idle:
            begin
                
                if(arg_vld)
                begin
                    mult1_a = b;
                    mult1_b = b;

                    mult2_a = a;
                    mult2_b = c;

                    mult1_up_valid = '1;
                    mult2_up_valid = '1;
                    next_state = st_calc_left_right;
                end
            end

            st_calc_left_right:
            begin
                mult1_a = four;
                mult1_b = mult2_res;
                
                if(mult1_error || mult2_error)
                begin
                    next_state = st_error;

                end
                if(mult1_down_valid && mult2_down_valid)
                begin
                    mult1_up_valid = '1;

                    next_state = st_mul_right;
                end
            end

            st_mul_right:
            begin
                sub_a = left_statement;
                sub_b = mult1_res;

                if(mult1_down_valid)
                begin
                    sub_up_valid = '1;

                    next_state = st_sub_both;
                end
            end

            st_sub_both:
            begin
                if(sub_down_valid)
                    next_state = st_idle;
            end

            st_error:
            begin
                err = '1;
                res_vld = '1;
                next_state = st_idle;
            end
        
        endcase
    end

    always_ff @ (posedge clk)
    begin
        if (rst)
            state <= st_idle;
        else
        begin
            state <= next_state;
        end

    end

    always_ff @ (posedge clk)
        if (rst)
        begin
            res_vld <= '0;
            err <= '0;
        end
        else
        begin
            res_vld <= (state == st_sub_both & sub_down_valid);
        end

    always_ff @ (posedge clk)
        if (state == st_idle)
        begin
            res <= {FLEN{1'bx}};
            err <= '0;
        end
        else if(state == st_calc_left_right && mult1_down_valid)
            left_statement <= mult1_res;
        else if (state == st_mul_right && mult1_down_valid)
            right_statement <= mult1_res;
        else if (state == st_sub_both & sub_down_valid)
            res <= sub_res;

    // Все модули выдают результат на 4 такт
    // f_add addition(.clk(clk), .rst(rst), .a(four), .b(four), .up_valid(arg_vld), .res(add_res), .down_valid(add_down_valid), .busy(add_busy), .error(add_error));
    f_mult multiplication1(.clk(clk), .rst(rst), .a(mult1_a), .b(mult1_b), .up_valid(mult1_up_valid), .res(mult1_res), .down_valid(mult1_down_valid), .busy(mult1_busy), .error(mult1_error));

    f_mult multiplication2(.clk(clk), .rst(rst), .a(mult2_a), .b(mult2_b), .up_valid(mult2_up_valid), .res(mult2_res), .down_valid(mult2_down_valid), .busy(mult2_busy), .error(mult2_error));

    f_sub substraction(.clk(clk), .rst(rst), .a(sub_a), .b(sub_b), .up_valid(sub_up_valid), .res(sub_res), .down_valid(sub_down_valid), .busy(sub_busy), .error(sub_error));

endmodule
