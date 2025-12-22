//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module conv_first_to_last_no_ready
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_first,
    input  [width - 1:0] up_data,

    output logic              down_valid,
    output logic              down_last,
    output logic[width - 1:0] down_data
);
    // Task:
    // Implement a module that converts 'first' input status signal
    // to the 'last' output status signal.
    //
    // See README for full description of the task with timing diagram.

    logic future_valid;
    logic [width - 1:0] future_data;
    logic future_last;
    logic transmission_is_active;

    always_comb begin
        down_valid <= future_valid;
        down_data <= future_data;
        down_last <= future_last;
        // if(up_valid)
        // begin
        //     down_valid <= '1;
        //     down_data <= up_data;
        //     if(up_first)
        //         down_last <= '1;
        //     else
        //         down_last <= '0;
        // end
        // begin
        //     down_valid <= '0;
        //     down_data <= '0;
        //     down_last <= '0;
        // end
    end

    always_ff @ (posedge clock)
    begin
        if(reset)
        begin
            future_valid <= '0;
            future_data <= '0;
            future_last <= '0;
            transmission_is_active <= '0;
        end
        else if(up_data)
        else
        begin
            future_valid <= up_valid;
            future_data <= up_data;
            
            if(up_first)
            begin
                if(transmission_is_active)
                    future_last <= '1;
                transmission_is_active <= '1;
                // future_last <= '1;
            end
            else
                future_last <= '0;
            // else
            // begin
            //     transmission_is_active <= '0;
            // end
                // future_last <= '0;
        end
    end

endmodule
