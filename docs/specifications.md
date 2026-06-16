# Specifications

The controller takes in user input and simulates a simplified washing cycle. The controller architecture consists of three core modules:


## UI Module

### REQ-1 - Mode Selection
With `mode_select`, the user selects between two modes: 
* **Normal Mode**
* **Quick Mode** (takes half the cycles of the normal mode)

The UI module shall forward the selected washing mode to the timer module.

[VAL-1](validation.md#val-1-mode-selection)

### REQ-2 - Warning door open
The UI module can generate a valid start signal only if the door is closed, which is tested by reading out the input `door_closed`. Otherwise, the `warning` output is activated within one clock cycle.

[VAL-2](validation.md#val-2-door-open-warning)

### REQ-3 - Reset
The `reset` signal should also be propagated to all connected modules from the UI module.

[VAL-3](validation.md#val-3-reset)


## Washing Machine (FSM)

### REQ-4 - Start 
The beginning state after a reset is the `IDLE` state, which the FSM shall transition to in one clock cycle. It should remain in the `IDLE` state until a valid start signal or a warning signal is received.

[VAL-4](validation.md#val-4-start)

### REQ-5 - Warning LED
If a warning signal is received, the FSM should transition to the `WARN` state, which turns the LED lights on through `done_led`.

[VAL-5](validation.md#val-5-warning-led)

### REQ-6 - Timer Start
If the warning signal is off or a valid start signal `start_cycle` was received, the FSM goes into the `FILL` state. The `FILL` state turns on the water valve to fill the washing machine through the output `water_valve` and starts the timer module with `timer_en`.

[VAL-6](validation.md#val-6-timer-start)

### REQ-7 - Washing Cycle
After receiving the `timer_done` signal, it continues with the washing sequence by shifting sequentially through the states: 
WASH -> RINSE -> SPIN -> DONE

With every state change, the timer gets restarted. The following table defines the specific outputs activated by each state:

| State | water_valve | wash_motor | spin_motor | done_led | timer_en | timer_sel |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **FILL** | 1 | 0 | 0 | 0 | 1 | 0 |
| **WASH** | 0 | 1 | 0 | 0 | 1 | 1 |
| **RINSE** | 1 | 1 | 0 | 0 | 1 | 1 |
| **SPIN** | 0 | 0 | 1 | 0 | 1 | 1 |
| **DONE** | 0 | 0 | 0 | 1 | 1 | 0 |

[VAL-7](validation.md#val-7-washing-cycle)


## Timer Module

### REQ-8 - Counting
The timer module shall start counting when `timer_en` = 1.

[VAL-8](validation.md#val-8-counting-and-done-signal)

### REQ-9 - Done signal
After the timer finishes its countdown, the signal `timer_done` should be generated.

[VAL-8](validation.md#val-8-counting-and-done-signal)

### REQ-10 - Duration
The timer duration dynamically scales depending on the selected mode and the current stage of the washing cycle.

[VAL-9](validation.md#val-9-duration)


## Verification

[Verification Report](verification-report.md#verification-report)