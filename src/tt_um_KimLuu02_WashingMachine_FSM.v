/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_KimLuu02_WashingMachine_FSM (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire start = ui_in[0]; // start signal from ui_in[0]
  wire mode_select = ui_in[1]; // mode_select signal from ui_in[1]
  wire door_closed = ui_in[2]; // door_closed signal from ui_in[2]

  wire water_valve = uo_out[0]; // water_valve control signal
  wire wash_motor = uo_out[1]; // wash_motor control signal
  wire spin_motor = uo_out[2]; // spin_motor control signal
  wire done_led = uo_out[3]; // done_led control signal

  assign uio_out = 8'b0; // No outputs on uio_out
  assign uio_oe = 8'b0; // All uio pins are inputs
  assign uo_out[7:4] = 4'b0; // Unused outputs set to 0

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0, ui_in[7:3], uio_in[7:0]};

  top_system top_system_inst(
    .clk            (clk),
    .start          (start),
    .reset_in       (rst_n),
    .mode_select    (mode_select),
    .door_closed    (door_closed),

    .water_valve    (water_valve),
    .wash_motor     (wash_motor),
    .spin_motor     (spin_motor),
    .done_led       (done_led)
);

endmodule
