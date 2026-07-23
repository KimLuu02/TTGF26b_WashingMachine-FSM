# Validation

In this document, testcases for the [requirements](specifications.md) and their expected results are defined.

## Summary

| REQ | Testcase | Expected Result |
| :--- | :--- | :--- |
| [REQ-1](specifications.md#req-1---mode-selection) | When selecting the mode in the UI the timer module should receive the correct mode | `select_mode = 1` $\rightarrow$ `mode = 1` (Normal Mode) |
| [REQ-2](specifications.md#req-2---warning-door-open) | If the door is open, the washing cycle should not start and a warning signal should be given | `door_closed = 0` and `start = 1` $\rightarrow$ `warning = 1`, `start_cycle = 0` |
| [REQ-3](specifications.md#req-3---reset) | If the user presses the reset button, all modules should go to their reset state | `reset = 1` $\rightarrow$ Reset active at FSM/Timer, `timer_en = 0` |
| [REQ-4](specifications.md#req-4---start) | The washing cycle or warning should only start if the user pressed the start button | `door_closed = 1` and `start = 0` $\rightarrow$ `timer_en = 0`, `start_cycle = 0`, `warning = 0` |
| [REQ-5](specifications.md#req-5---warning-led) | If the door is not closed, the washing machine should warn the user | `door_closed = 0` and `start = 1` $\rightarrow$ `warning = 1`, `done_led = 1` |
| [REQ-6](specifications.md#req-6---timer-start) | After successfully starting the washing machine, the timer should be enabled | `start_cycle = 1` $\rightarrow$ `water_valve = 1`, `timer_en = 1`, `timer_sel = 0` |
| [REQ-7](specifications.md#req-7---washing-cycle) | After the washing cycle was started, each step has to be reached | Verify sequence: **FILL** $\rightarrow$ **WASH** $\rightarrow$ **RINSE** $\rightarrow$ **SPIN** $\rightarrow$ **DONE** $\rightarrow$ **IDLE** |
| [REQ-8](specifications.md#req-8---counting), [REQ-9](specifications.md#req-9---done-signal) | After receiving the signal to start, the timer should start counting cycles and output a done signal | `timer_en = 1` $\rightarrow$ Counts until duration reached $\rightarrow$ `timer_done = 1` |
| [REQ-10](specifications.md#req-10---duration) | The user can select a mode which changes the duration of each washing cycle | `mode = 1` and `timer_sel = 0` $\rightarrow$ `cycles = 5` |

---

## UI Module

### VAL-1 Mode Selection
**Requirement:** [REQ-1](specifications.md#req-1---mode-selection)  
**Testcase:** Selecting a mode should forward the correct mode to the timer module

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 0 | 1 | 0 |

**Expected Result:** `mode = 1`

### VAL-2 Door Open Warning
**Requirement:** [REQ-2](specifications.md#req-2---warning-door-open)  
**Testcase:** If the door is not closed, a warning signal should be set and the washing cycle should not start

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 0 | 0 |

**Expected Result:** `warning = 1` ; `start_cycle = 0`

### VAL-3 Reset
**Requirement:** [REQ-3](specifications.md#req-3---reset)  
**Testcase:** After pressing reset, the modules should be set to their reset state

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 0 | 1 | 0 | 0 |

**Expected Result:** `reset = 0`; `timer_en = 0`

---

## Washing Machine (FSM)

### VAL-4 Start
**Requirement:** [REQ-4](specifications.md#req-4---start)  
**Testcase:** Only after a start signal should the state switch

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 0 | 0 | 1 |

**Expected Result:** `timer_en = 0`; `start_cycle = 0`; `warning = 0` (FSM stays in **IDLE**)

### VAL-5 Warning LED
**Requirement:** [REQ-5](specifications.md#req-5---warning-led)  
**Testcase:** If the door is not closed, the user should be warned by an LED

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 0 | 0 |

**Expected Result:** `done_led = 1` (FSM moves to **WARN**)

### VAL-6 Timer Start
**Requirement:** [REQ-6](specifications.md#req-6---timer-start)  
**Testcase:** After a valid start signal the washing cycle should begin and the timer should be enabled

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 0 | 1 |

**Expected Result:** `start_cycle = 1`; `water_valve = 1`; `timer_en = 1`; `timer_sel = 0` (FSM moves to **FILL**)

### VAL-7 Washing Cycle
**Requirement:** [REQ-7](specifications.md#req-7---washing-cycle)  
**Testcase:** After a valid start signal the washing cycle should begin and all states with their outputs should be correct

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 0 | 1 |

**Expected Result:**
| FSM State | `water_valve` | `wash_motor` | `spin_motor` | `done_led` | `timer_en` | `timer_sel` |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **FILL** | 1 | 0 | 0 | 0 | 1 | 0 |
| **WASH** | 0 | 1 | 0 | 0 | 1 | 1 |
| **RINSE** | 1 | 1 | 0 | 0 | 1 | 0 |
| **SPIN** | 0 | 0 | 1 | 0 | 1 | 1 |
| **DONE** | 0 | 0 | 0 | 1 | 1 | 0 |

---

## Timer Module

### VAL-8 Counting and Done Signal
**Requirement:** [REQ-8](specifications.md#req-8---counting), [REQ-9](specifications.md#req-9---done-signal)  
**Testcase:** After the washing cycle starts, the timer should receive a signal to start the timer and send out a signal after it is done counting

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 0 | 1 |

**Expected Result:** `timer_en = 1`; `timer_done = 1`

### VAL-9 Duration
**Requirement:** [REQ-10](specifications.md#req-10---duration)  
**Testcase:** The duration should change depending on the selected mode

**Parameter Settings:**
| Param | `reset` | `start` | `mode` | `door_closed` |
| :--- | :---: | :---: | :---: | :---: |
| **Value** | 1 | 1 | 1 | 1 |

**Expected Result:** `timer_sel = 0`; `cycles = 5`