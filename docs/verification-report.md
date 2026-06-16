# Verification Report
All verification test cases are implemented in [testbench.py](../test/testbench/testbench.py), which contains all the Cocotb test functions used to verify the requirements specified in the [specifications.md](../docs/specifications.md). Properties were 

## Testbench Results
| REQ | VAL TB |  Result | 
| - | - | - | 
| [REQ-1](specifications.md#req-1---mode-selection) | req_1_mode_select | pass |
| [REQ-2](specifications.md#req-2---warning-door-open) | req_2_door_open_warning | pass |
| [REQ-3](specifications.md#req-3---reset) | req_3_reset | pass |
| [REQ-4](specifications.md#req-4---start) | req_4_start_cycle | pass |
| [REQ-5](specifications.md#req-5---warning-led) | req_5_warning_LED | pass |
| [REQ-6](specifications.md#req-6---timer-start) | req_6_warning_LED | pass |
| [REQ-7](specifications.md#req-7---washing-cycle) | req_7_wash_cycles | pass |
| [REQ-8](specifications.md#req-8---counting), [REQ-9](specifications.md#req-9---done-signal) | req_8_9_timer | pass |
| [REQ-10](specifications.md#req-10---duration) | req_10_duration | pass |

## Formal Verification Results

| Module | Properties |  Result | 
| - | - | - | 
| [UImodule](../src/UImodule.v) | 'start_cycle', 'warning', 'mode_select', 'reset_in' | [pass](../test/sby/UImodule_verification/PASS) |
| [timermodule](../src/timermodule.v) | 'mode', 'timer_sel', reset behaviour, timer disable behaviour | [pass](../test/sby/timermodule_verification/PASS) |
