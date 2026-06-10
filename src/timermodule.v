module timer_module(
    input wire mode,
    input wire clk,
    input wire reset_in,
    input wire timer_en,
    input wire timer_sel,

    output reg timer_done
);

reg [4:0] cycles;
reg [4:0] duration;

always @(*) begin
    case (timer_sel)
        1'b1: duration = mode ? 4'b1010 : 4'b0101; 
        1'b0: duration = mode ? 4'b0101 : 4'b0011;
        default: duration = 4'b1010;
    endcase
end

always @(posedge clk) begin
    if (!reset_in) begin 
        cycles <= 4'b0000;
        timer_done <= 1'b0;
    end 
    else if (!timer_en) begin
        cycles <= 4'b0000;
        timer_done <= 1'b0;
    end
    else if (cycles >= duration) begin
        timer_done <= 1'b1;
        cycles <= 4'b0000;
    end 
    else begin
        cycles <= cycles + 1'b1;
    end

end

`ifdef FORMAL
    reg past_valid = 0;

    initial assume(reset_in == 1);

    always @(posedge clk) begin
        past_valid <= 1;
        if (past_valid) begin
            if (!$past(reset_in)) begin
                assert(cycles == 4'b0000);
                assert(timer_done == 1'b0);
            end
        end
    end

    always @(posedge clk) begin
        past_valid <= 1;
        if (past_valid) begin
            if ($past(timer_en) == 1'b0) begin
                assert(cycles == 4'b0000);
                assert(timer_done == 1'b0);
            end
        end
    end
    
    always @(*) begin
        case (timer_sel)
        1'b0: assert(duration == (mode ? 4'b0101 : 4'b0011));
        1'b1: assert(duration == (mode ? 4'b1010 : 4'b0101));
        endcase
    end

`endif

endmodule