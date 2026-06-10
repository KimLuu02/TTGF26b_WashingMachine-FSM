module wmFSM (
    input wire clk,
    input wire start_cycle,
    input wire reset_in,
    input wire timer_done,
    input wire warning,

    output reg water_valve,
    output reg wash_motor,
    output reg spin_motor,
    output reg done_led,
    output reg timer_en,
    output reg timer_sel
);


parameter IDLE = 3'b000;
parameter WARN = 3'b001;
parameter FILL = 3'b010;
parameter WASH = 3'b011;
parameter RINSE = 3'b100;
parameter SPIN = 3'b101;
parameter DONE = 3'b110;


reg [2:0] current_state;
reg [2:0] next_state;

// State Register
always @(posedge clk) begin
    if (!reset_in) begin
        current_state <= IDLE;
    end
    else 
        current_state <= next_state;
    
end

// Next-State Logic
always @(*) begin
    next_state = current_state;
    case (current_state) 
    IDLE: begin 
        if(warning)
            next_state = WARN;
        else if(start_cycle)
            next_state = FILL;
    end

    WARN: begin 
        if(!warning)
            next_state = IDLE;
    end

    FILL: begin 
        if(timer_done)
            next_state = WASH;
    end

    WASH: begin 
        if(timer_done)
            next_state = RINSE;
    end

    RINSE: begin 
        if(timer_done)
            next_state = SPIN;
    end

    SPIN: begin 
        if(timer_done)
            next_state = DONE;
    end

    DONE: begin 
        if(timer_done)
            next_state = IDLE;
    end

    default: begin
    next_state = IDLE;
    end
    endcase
end

// Output Logic
always @(*) begin

water_valve = 1'b0;
wash_motor = 1'b0;
spin_motor = 1'b0;
done_led = 1'b0;
timer_en = 1'b0;
timer_sel = 1'b0;

    case(current_state)

    WARN: begin
        done_led = 1'b1;
        if(next_state == IDLE)
            timer_en = 1'b0;
    end

    FILL: begin
        water_valve = 1'b1;
        timer_en = 1'b1;
        if(next_state == WASH)
            timer_en = 1'b0;
    end

    WASH: begin
        wash_motor = 1'b1;
        timer_en = 1'b1;
        timer_sel = 1'b1;
        if(next_state == RINSE)
            timer_en = 1'b0;
    end

    RINSE: begin
        water_valve = 1'b1;
        wash_motor = 1'b1;
        timer_en = 1'b1;
        if(next_state == SPIN)
            timer_en = 1'b0;
    end

    SPIN: begin
        spin_motor = 1'b1;
        timer_en = 1'b1;
        timer_sel = 1'b1;
        if(next_state == DONE)
            timer_en = 1'b0;
    end

    DONE: begin
        done_led = 1'b1;
        timer_en = 1'b1;
        if(next_state == IDLE)
            timer_en = 1'b0;
    end

    endcase
end
endmodule