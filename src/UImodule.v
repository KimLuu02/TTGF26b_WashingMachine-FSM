

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

// assign start_cycle = start & door_closed;
// assign warning = start & ~door_closed;
// assign mode = mode_select;
// assign reset_out = reset_in;


always @(*) begin
    if (mode_select == 1'b1) begin
        mode = 1'b1;
    end else begin
        mode = 1'b0;
    end
end

always @(*) begin
    if ((start & door_closed) == 1'b1) begin
        warning = 1'b0;
        start_cycle = 1'b1;
    end else begin
        warning = 1'b1;
        start_cycle = 1'b0;
    end
end

always @(*) begin
    if (reset_in == 1'b1) begin
        reset_out = 1'b1;
    end else begin
        reset_out = 1'b0;
    end
end


`ifdef FORMAL
always @(*) begin
    assert(start_cycle == (start & door_closed));
    assert(warning == (start & ~door_closed));
    assert(mode == mode_select);
    assert(reset_out == reset_in);
end
`endif

endmodule