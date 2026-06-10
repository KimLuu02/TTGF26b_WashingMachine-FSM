# Verification Report
All verification test cases are implemented in [testbench.py](../test/testbench/testbench.py), which contains all the Cocotb test functions used to verify the requirements specified in the [specifications.md](../docs/specifications.md). Properties were 

## Testbench Results
| REQ | VAL TB |  Result | 
| - | - | - | 
| [REQ-1](specifications.md#REQ-1) | req_1_mode_select | pass |
| [REQ-2](specifications.md#REQ-2) | req_2_door_open_warning | pass |
| [REQ-3](specifications.md#REQ-3) | req_3_reset | pass |
| [REQ-4](specifications.md#REQ-4) | req_4_start_cycle | pass |
| [REQ-5](specifications.md#REQ-5) | req_5_warning_LED | pass |
| [REQ-6](specifications.md#REQ-6) | req_6_warning_LED | pass |
| [REQ-7](specifications.md#REQ-7) | req_7_wash_cycles | pass |
| [REQ-8](specifications.md#REQ-8), [REQ-9](specifications.md#REQ-9) | req_8_9_timer | pass |
| [REQ-10](specifications.md#REQ-10) | req_10_duration | pass |

## Formal Verification Results

| Module | Properties |  Result | 
| - | - | - | 
| [UImodule](../src/UImodule.v) | 'start_cycle', 'warning', 'mode_select', 'reset_in' | [pass](../test/sby/UImodule_verification/PASS) |
| [timermodule](../src/timermodule.v) | 'mode', 'timer_sel', reset behaviour, timer disable behaviour | [pass](../test/sby/timermodule_verification/PASS) |
