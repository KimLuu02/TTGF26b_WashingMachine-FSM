
module debouncer #(
    parameter CLK_FREQ = 20_000_000, // 20 MHz 
    parameter DEBOUNCE_MS = 20       // 20 ms debounce
)(
    input wire clk,
    input wire button_in,
    output reg button_out
);

    localparam sum_cycles = (CLK_FREQ / 1000) * DEBOUNCE_MS;
    
    reg [$clog2(sum_cycles)-1:0] counter = 0;
    reg sync_0, sync_1;


    always @(posedge clk) begin
        sync_0 <= button_in;
        sync_1 <= sync_0;
    end

    always @(posedge clk) begin
        if (sync_1 != button_out) begin
            if (counter < sum_cycles - 1) begin
                counter <= counter + 1'b1;
            end else begin
                button_out <= sync_1; // Signal war lang genug stabil
                counter <= 0;
            end
        end else begin
            counter <= 0; // Signal hat sich nicht geändert oder zappelt noch
        end
    end

endmodule