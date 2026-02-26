module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output logic                      down_vld,
    output logic [ width   - 1 : 0 ]  down_data
);

    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.

    logic [ n_inputs - 1 : 0 ] internal_data_valid;
    logic [width - 1 : 0] internal_data [ 0 : n_inputs - 1 ];  // [ n_inputs - 1 : 0 ] [0 : width - 1]
    logic [$clog2(n_inputs)-1:0] input_index;
    logic [$clog2(n_inputs)-1:0] output_index;
    logic [1:0] index_reset;
    logic [1:0] if_statement;

    always_ff @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            internal_data_valid <= '0;
            input_index <= '0;

            for(int i = 0; i < n_inputs; i++)
                internal_data[i] <= '0;
        end
        else
        begin
            // if(output_index == n_inputs - 1'd1) // TODO
            // begin
            //     input_index = '0;
            //     // internal_data_valid = '0;
            // end
            for(int i = 0; i < n_inputs; i++)
            begin
                if(up_vlds[i])
                begin
                    // input_index <= input_index + 1'd1;
                    internal_data_valid[i] <= up_vlds[i];
                    internal_data[i] <= up_data[i];
                end
            end
        end
    end
    // TODO
    // assign down_vld = (input_index == n_inputs);
    // assign down_vld = &internal_data_valid;
    // assign down_data = internal_data;


    // always_ff @ (posedge clk or posedge rst)
    // begin

    // end

    always_comb
    begin
        if(internal_data_valid[output_index])
            begin
                if_statement <= 2'd1;
                // down_vld <= '1;
                // down_data <= internal_data[output_index];
                // internal_data_valid[output_index] <= '0;
                // output_index = output_index + 1'd1;
                // if(output_index == n_inputs) // может напороться на 2 подряд идущих значения на последнем входе
                // begin
                //     output_index = '0;
                //     index_reset = 2'd1;
                // end

            end
            // else if(up_vlds[output_index])
            // begin
            //     if_statement <= 2'd2;
                // down_vld <= '1;
                // down_data <= up_data[output_index];
                // internal_data_valid[output_index] <= '0; // might be double assignment
                // output_index = output_index + 1'd1;
                // if(output_index == n_inputs-1) // может напороться на 2 подряд идущих значения на последнем входе
                // begin
                //     output_index = '0;
                //     index_reset = 2'd2;
                // end
            // end
            else
            begin
                if_statement <= 2'd3;
                // if(output_index == n_inputs) // может напороться на 2 подряд идущих значения на последнем входе
                // begin
                //     output_index = '0;
                //     index_reset = 2'd3;
                // end
                // down_vld <= '0;
            end
    end

    always_ff @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            output_index <= '0;
            index_reset <= '0;
            if_statement <= '0;
        end
        else
        begin
            if(internal_data_valid[output_index])
            begin
                // if_statement <= 2'd1;
                down_vld = '1;
                down_data = internal_data[output_index];
                internal_data_valid[output_index] = '0;
                output_index = output_index + 1'd1;
                if(output_index == n_inputs) // может напороться на 2 подряд идущих значения на последнем входе
                begin
                    output_index = '0;
                    index_reset = 2'd1;
                end

            end
            // else if(up_vlds[output_index])
            // begin
            //     // if_statement <= 2'd2;
            //     down_vld <= '1;
            //     down_data <= up_data[output_index];
            //     internal_data_valid[output_index] <= '0; // might be double assignment
            //     output_index = output_index + 1'd1;
            //     if(output_index == n_inputs-1) // может напороться на 2 подряд идущих значения на последнем входе
            //     begin
            //         output_index = '0;
            //         index_reset = 2'd2;
            //     end
            // end
            // else if(output_index == n_inputs - 1)
            // begin

            // end
            else
            begin
                // if_statement <= 2'd3;
                if(output_index == n_inputs) // может напороться на 2 подряд идущих значения на последнем входе
                begin
                    output_index = '0;
                    index_reset = 2'd3;
                end
                down_vld <= '0;
            end
        end
    end

    // always_ff @ (posedge clk or posedge rst)
    // begin
    //     if(rst)
    //     begin
    //         down_vld <= '0;
    //         for(int i = 0; i < n_inputs; i++)
    //             down_data[i] <= '0;

    //     end
    //     else if(input_index == n_inputs)
    //     begin
    //         down_vld <= '1;
    //         down_data <= internal_data;
    //     end
    //     else
    //     begin
    //         down_vld <= '0;
    //     end


    // end


endmodule
