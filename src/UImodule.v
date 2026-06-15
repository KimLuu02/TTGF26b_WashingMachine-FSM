

module ui_module(
    input wire start,
    input wire door_closed,
    input wire mode_select,
    input wire reset_in,

    output reg start_cycle,
    output reg warning,
    output reg mode,
    output reg reset_out

);

// Debouncing-Module for CLK = 20MHz and DEBOUNCE_MS = 20ms
    debouncer #(.CLK_FREQ(20_000_000), .DEBOUNCE_MS(20)) db_start (
        .clk(clk), .button_in(start), .button_out(start_debounced)
    );
    
    debouncer #(.CLK_FREQ(20_000_000), .DEBOUNCE_MS(20)) db_door (
        .clk(clk), .button_in(door_closed), .button_out(door_debounced)
    );

    debouncer #(.CLK_FREQ(20_000_000), .DEBOUNCE_MS(20)) db_mode (
        .clk(clk), .button_in(mode_select), .button_out(mode_debounced)
    );

    debouncer #(.CLK_FREQ(20_000_000), .DEBOUNCE_MS(20)) db_reset (
        .clk(clk), .button_in(reset_in), .button_out(reset_debounced)
    );

    assign start_cycle = start_debounced & door_debounced;
    assign warning     = start_debounced & ~door_debounced;
    assign mode        = mode_debounced;
    assign reset_out   = reset_debounced;


`ifdef FORMAL
always @(*) begin
    assert(start_cycle == (start & door_closed));
    assert(warning == (start & ~door_closed));
    assert(mode == mode_select);
    assert(reset_out == reset_in);
end
`endif

endmodule