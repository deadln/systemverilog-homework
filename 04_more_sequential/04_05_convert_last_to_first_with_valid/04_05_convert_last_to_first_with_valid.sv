//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module conv_last_to_first
# (
    parameter width = 8
)
(
    input                clock,
    input                reset,

    input                up_valid,
    input                up_last,
    input  [width - 1:0] up_data,

    output logic              down_valid,
    output logic              down_first,
    output logic [width - 1:0] down_data
);
    // Task:
    // Implement a module that converts 'last' input status signal
    // to the 'first' output status signal.
    //
    // See README for full description of the task with timing diagram.

    // Пришли данные с up_valid - ставим down_first в 1 один такт и пересылаем данные.
    // Когда приходит up_last, то следующий пакет с up_valid ставим down_first

    logic transmission_is_up;

    always_comb begin
        /*if(reset)
        begin
            down_valid <= '0;
            down_data <= '0;
            down_first <= '0;
        end
        else*/ if(up_valid)
        begin
            down_valid <= '1;
            down_data <= up_data;
            if(~transmission_is_up)
                down_first <= '1;
            else
                down_first <= '0;
        end
        else
        begin
            down_valid <= '0;
            down_data <= '0;
            down_first <= '0;
        end
    end

    always_ff @ (posedge clock)
    begin
        if (reset)
        begin
            transmission_is_up = '0;
        end
        // Начало передачи данных
        else if(up_valid && ~transmission_is_up && ~up_last)
        begin
            transmission_is_up = 1;
        end
        // Конец передачи данных
        else if(up_last)  // transmission_is_up && 
            transmission_is_up = 0;
    end
endmodule
