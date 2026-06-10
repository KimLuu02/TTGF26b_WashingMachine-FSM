`default_nettype none
`timescale 1ns/10ps

module top_system(
    input wire clk,
    input wire start,
    input wire reset_in,
    input wire mode_select,
    input wire door_closed,

    output wire water_valve,
    output wire wash_motor,
    output wire spin_motor,
    output wire done_led
);

wire start_cycle;
wire mode;
wire reset_out;

wire timer_done;
wire timer_en;
wire timer_sel;
wire warning;

ui_module ui_inst(
    .start(start),
    .door_closed(door_closed),
    .reset_in(reset_in),
    .start_cycle(start_cycle),
    .warning(warning),
    .mode_select(mode_select),
    .mode(mode),
    .reset_out(reset_out)
);

wmFSM fsm_inst(
    .clk(clk),
    .reset_in(reset_out),
    .start_cycle(start_cycle),
    .warning(warning),
    .timer_done(timer_done),
    .water_valve(water_valve),
    .wash_motor(wash_motor),
    .spin_motor(spin_motor),
    .done_led(done_led),
    .timer_en(timer_en),
    .timer_sel(timer_sel)
);

timer_module timer_inst(
    .clk(clk),
    .reset_in(reset_out),
    .timer_en(timer_en),
    .mode(mode),
    .timer_sel(timer_sel),
    .timer_done(timer_done)
);
endmodule


module cocotb_iverilog_dump();
    initial begin
        $dumpfile("sim_build/top_system.vcd");
        $dumpvars(0, top_system);
        #1;
    end
endmodule