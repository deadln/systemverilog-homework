//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module gearbox_1_to_2
# (
    parameter width = 0
)
(
    input                    clk,
    input                    rst,

    input                    up_vld,    // upstream
    input  [    width - 1:0] up_data,

    output logic                  down_vld,  // downstream
    output logic [2 * width - 1:0] down_data
);
    // Task:
    // Implement a module that transforms a stream of data
    // from 'width' to the 2*'width' data width.
    //
    // The module should be capable to accept new data at each
    // clock cycle and produce concatenated 'down_data'
    // at each second clock cycle.
    //
    // The module should work properly with reset 'rst'
    // and valid 'vld' signals

    logic [    width - 1:0] buff_data;
    logic valid_clock;
    // logic output_happened;

    always_comb begin
        if(up_vld && valid_clock)  // && !output_happened)
        begin
            down_vld <= '1;
            down_data <= {buff_data, up_data};
        end
        else
        begin
            down_vld <= '0;
            // down_data <= '0; 
        end
    end

    always_ff @ (posedge clk)
    begin
    if (rst)
    begin
        valid_clock <= '0;
        buff_data <= '0;
        // output_happened <= '0;
    end
    else if(up_vld)
    begin
        valid_clock <= valid_clock ^ '1;
        buff_data <= up_data;
    end
    // if(valid_clock)
    //     output_happened <= '1;
    // else
    //     output_happened <= '0;
    end
endmodule
