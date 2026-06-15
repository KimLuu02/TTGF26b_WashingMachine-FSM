

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

module debouncer #(
    parameter CLK_FREQ = 20_000_000, // 20 MHz 
    parameter DEBOUNCE_MS = 20       // 20 ms debounce
)(
    input wire clk,
    input wire button_in,
    output reg button_out
);

    // Berechnung der benötigten Taktzyklen
    localparam sum_cycles = (CLK_FREQ / 1000) * DEBOUNCE_MS;
    
    reg [$clog2(sum_cycles)-1:0] counter = 0;
    reg sync_0, sync_1;

    // 1. Synchronisation (verhindert Metastabilität)
    always @(posedge clk) begin
        sync_0 <= button_in;
        sync_1 <= sync_0;
    end

    // 2. Zähler-Logik für das Entprellen
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