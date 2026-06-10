# Specifications
The controller consists of three modules:

## UI Module
The UI module accepts the inputs "start", "door_closed", "mode_select" and "reset".

### REQ-1
With "select_mode", the user selects between two modes: "normal mode" and "quick mode" which takes half the cycles of the normal mode. The UI module shall forward the selected washing mode to the timer module.

### REQ-2
The UI module can generate a valid start signal, only if the door is closed, which is tested by reading out the input "door_closed" otherwise the "warning" output is activated within one clock cycle.

### REQ-3
The "reset" signal should also be propagated to all connected modules from the UI module.

## Washing Machine (FSM)
### REQ-4
The beginning state after a reset is the IDLE state, which the FSM shall transition to in one clock cycle. It should remain in the IDLE state until a valid start signal is received or a warning signal.

### REQ-5
If a warning signal is received, the FSM should transition to the WARN state, which turns the LED lights on through done_led.

### REQ-6
If the warning signal is off or a valid start signal start_cycle was received, the FSM goes into the FILL state. The FILL state turns on the water valve, to fill the washing machine through the output "water_valve" and start the timer module with "timer_en". 

### REQ-7
After receiving the "timer_done" signal, it continues with the washing sequence by going into the state WASH -> RINSE -> SPIN -> DONE. With every state the timer gets restarted. The following table shows the output each state turns on.

| State | water_valve | wash_motor | spin_motor | done_led | timer_en | timer_sel |
| - | - | - | - | - | - | - |
| FILL | 1 | 0 | 0 | 0 | 1 | 0 |
| WASH | 0 | 1 | 0 | 0 | 1 | 1 |
| RINSE | 1 | 1 | 0 | 0 | 1 | 1 |
| SPIN | 0 | 0 | 1 | 0 | 1 | 1 |
| DONE | 0 | 0 | 0 | 1 | 1 | 0 |

## Timer Module
### REQ-8
The timer module shall start counting when 'timer_en' = 1

### REQ-9
After the timer is done, the signal "timer_done" should generate.

### REQ-10
The timer duration depends on the selected mode and the stage of the washing cycle.

## Verification
[Verification Report](verification-report.md#verification-report)

## Inputs

## Outputs