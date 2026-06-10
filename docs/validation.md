# Validation

| REQ | Testcase | Expected Result | 
| - | - | - | 
| [REQ-1](specifications.md#REQ-1) | When selecting the mode in the UI the timer module should receive the correct mode | select_mode = '1' and then output 'mode' = '1' for 'quick mode' |  
| [REQ-2](specifications.md#REQ-2) | If the door is open, the washing cycle should not start and a warning signal should be given | door_closed = 0 and start = 1 then warning = 1 and start_cycle = 0 |  
| [REQ-3](specifications.md#REQ-3) | If the user presses the reset button, all modules should go to their reset state | reset = 1 then reset input at FSM and timer should be 1 and timer_en = 0|  
| [REQ-4](specifications.md#REQ-4) | The washing cycle or warning should only start if the user pressed the start button | door_closed = 1 and start = 0, then timer_en = 0, start_cycle = 0, warning = 0|  
| [REQ-5](specifications.md#REQ-5) | If the door is not closed, the washing machine should warn the user | door_closed = 0 and start = 1 then warning = 1 and done_led = 1 |  
| [REQ-6](specifications.md#REQ-6) | After succefully starting the washing machine, the washing cycle begins | If start_cycle = 1 then water_valve = 1 and timer_en = 1 and timer_sel = 0 |  
| [REQ-7](specifications.md#REQ-7) | after the washing cylce was started, each step has to be reached | Testing if after FILL -> WASH -> RINSE -> SPIN -> DONE -> IDLE and their corresponding output signals |  
| [REQ-8](specifications.md#REQ-8), [REQ-9](specifications.md#REQ-9) | After receiving the signal to start, the timer should start counting the cycles and output a signal, after the timer is done | timer_en = 1 then timer counts until duration is reached and timer_done = 1 |  
| [REQ-10](specifications.md#REQ-10) | The user can select a mode which changes the duration of each washing cycle | if mode = 1 and timer_sel = 0 then parameter cylces = 5 |  
