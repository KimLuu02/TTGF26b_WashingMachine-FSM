

module ui_module(
    input wire start,
    input wire door_closed,
    input wire mode_select,
    input wire reset_in,

    output wire start_cycle,
    output wire warning,
    output wire mode,
    output wire reset_out

);

assign start_cycle = start & door_closed;
assign warning = start & ~door_closed;
assign mode = mode_select;
assign reset_out = reset_in;

`ifdef FORMAL
always @(*) begin
    assert(start_cycle == (start & door_closed));
    assert(warning == (start & ~door_closed));
    assert(mode == mode_select);
    assert(reset_out == reset_in);
end
`endif

endmodule