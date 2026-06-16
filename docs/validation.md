# Validation
In this document testcases for the [requirements](specifications.md) are defined and it's expected results.

## Summary:
| REQ | Testcase | Expected Result | 
| - | - | - | 
| [REQ-1](specifications.md#req-1---mode-selection) | When selecting the mode in the UI the timer module should receive the correct mode | select_mode = '1' and then output 'mode' = '1' for 'quick mode' |  
| [REQ-2](specifications.md#req-2---warning-door-open) | If the door is open, the washing cycle should not start and a warning signal should be given | door_closed = 0 and start = 1 then warning = 1 and start_cycle = 0 |  
| [REQ-3](specifications.md#req-3---reset) | If the user presses the reset button, all modules should go to their reset state | reset = 1 then reset input at FSM and timer should be 1 and timer_en = 0|  
| [REQ-4](specifications.md#req-4---start) | The washing cycle or warning should only start if the user pressed the start button | door_closed = 1 and start = 0, then timer_en = 0, start_cycle = 0, warning = 0|  
| [REQ-5](specifications.md#req-5---warning-led) | If the door is not closed, the washing machine should warn the user | door_closed = 0 and start = 1 then warning = 1 and done_led = 1 |  
| [REQ-6](specifications.md#req-6---timer-start) | After succefully starting the washing machine, the timer should be enabled | If start_cycle = 1 then water_valve = 1 and timer_en = 1 and timer_sel = 0 |  
| [REQ-7](specifications.md#req-7---washing-cycle) | After the washing cylce was started, each step has to be reached | Testing if after FILL -> WASH -> RINSE -> SPIN -> DONE -> IDLE and their corresponding output signals |  
| [REQ-8](specifications.md#req-8---counting), [REQ-9](specifications.md#req-9---done-signal) | After receiving the signal to start, the timer should start counting the cycles and output a signal, after the timer is done | timer_en = 1 then timer counts until duration is reached and timer_done = 1 |  
| [REQ-10](specifications.md#req-10---duration) | The user can select a mode which changes the duration of each washing cycle | if mode = 1 and timer_sel = 0 then parameter cylces = 5 |  

## UI Module
### VAL-1 Mode Selection
**[REQ-1](specifications.md#req-1---mode-selection)**
**Testcase**: Selecting a mode should forward the correct mode to the timer module

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 0 | 1 | 0 |

**Result**: mode = 1

### VAL-2 Door Open Warning
**[REQ-2](specifications.md#req-2---warning-door-open)**
**Testcase**: If the door is not closed, a warning signal should be set and the washing cycle should not start

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 0 | 0 |

**Result**: warning = 1 ; start_cycle = 0

### VAL-3 Reset
**[REQ-3](specifications.md#req-3---reset)**
**Testcase**: After pressing reset, the modules should be set to their reset state

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 0 | 1 | 0 | 0 |

**Result**: reset = 0; timer_en = 0

## Washing Machine (FSM)
### VAL-4 Start
**[REQ-4](specifications.md#req-4---start)**
**Testcase**: Only after a start signal should the state switch

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 0 | 0 | 1 |

**Result**: timer_en = 0; start_cycle = 0; warning = 0

### VAL-5 Warning LED
**[REQ-5](specifications.md#req-5---warning-led)**
**Testcase**: If the door is not closed, the user should be warned by an led

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 0 | 0 |

**Result**: done_led = 1

### VAL-6 Timer Start
**[REQ-6](specifications.md#req-6---timer-start)**
**Testcase**: After a valid start signal the washing cycle should begin and the timer should be enabled

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 0 | 1 |

**Result**: start_cycle = 1; water_valve = 1; timer_en = 1; timer_sel = 0

### VAL-7 Washing Cycle
** [REQ-7](specifications.md#req-7---washing-cycle)**
**Testcase**: After a valid start signal the washing cycle should begin and all states with their outputs should be correct

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 0 | 1 |

**Result**:

| State | water_valve | wash_motor | spin_motor | done_led | timer_en | timer_sel |
| - | - | - | - | - | - | - |
| FILL | 1 | 0 | 0 | 0 | 1 | 0 |
| WASH | 0 | 1 | 0 | 0 | 1 | 1 |
| RINSE | 1 | 1 | 0 | 0 | 1 | 1 |
| SPIN | 0 | 0 | 1 | 0 | 1 | 1 |
| DONE | 0 | 0 | 0 | 1 | 1 | 0 |

## Timer Module
### VAL-8 Counting and Done Signal
**[REQ-8](specifications.md#req-8---counting), [REQ-9](specifications.md#req-9---done-signal)**
**Testcase**: After the washing cycle starts, the timer should receive a signal to start the timer and send out a signal after it is done counting

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 0 | 1 |

**Result**: timer_en = 1; timer_done = 1

### VAL-9 Duration
**[REQ-10](specifications.md#req-10---duration)**
**Testcase**: The duration should change depending on the selected mode

**Parameter Settings**:  
| Param | reset | start | mode | door_closed | 
| - | - | - | - | - |
| Value | 1 | 1 | 1 | 1 |

**Result**: timer_sel = 0; cycles = 5

