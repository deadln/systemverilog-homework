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
    logic prev_was_first;
    logic [1:0] if_state;

    always_comb begin
        if(up_first !== 1'bX)
        begin
            down_valid = future_valid;
            // down_last = future_last;
            down_data = future_data;


            if(prev_was_first && up_first) begin
                down_last = 1'b1;
                if_state = 2'b00;
            end
            else if(prev_was_first && ~up_first) begin
                down_last = 1'b0;
                if_state = 2'b01;
            end
            else if(~prev_was_first && up_first) begin
                down_last = 1'b1;
                if_state = 2'b10;
            end
            else begin
                down_last = 1'b0;
                if_state = 2'b11;
            end
        end
        else
        begin
            down_valid = '0;
            down_last = '0;
            down_data = up_data;
        end
        
    end

    always_ff @ (posedge clock)
    begin
        if(reset)
        begin
            future_valid <= '0;
            future_data <= '0;
            future_last <= '0;
            prev_was_first <= '0;
        end
        // else if(up_data)
        else if(up_first !== 1'bX)
        begin
            // New
            // if(up_data !== 8'bXXXXXXX)
            future_data <= up_data;
            future_valid <= up_valid;
            // if(prev_was_first && up_first)
            //     future_last <= 1'b1;
            // else if(prev_was_first && ~up_first)
            //     future_last <= 1'b0;
            // else if(~prev_was_first && up_first)
            //     future_last <= 1'b1;
            // else
            //     future_last <= 1'b0;
            prev_was_first <= up_first;
            
            // Old
            // future_valid <= up_valid;
            // future_data <= up_data;
            
            // if(up_first)
            // begin
            //     // if(transmission_is_active)
            //         future_last <= '1;
            //     transmission_is_active <= '1;
            //     // future_last <= '1;
            // end
            // else
            //     future_last <= '0;
            
            // ХЗ
            // else
            // begin
            //     transmission_is_active <= '0;
            // end
                // future_last <= '0;
        end
    end

endmodule
