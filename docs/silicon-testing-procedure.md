# Silicon Testing Procedure

This document defines the physical hardware verification and silicon testing procedure for the Washing Machine Controller implemented. It details the required equipment, external interfaces, and test vectors to validate the Finite State Machine (FSM) and timing modules against physical silicon behavior.

## Measurement Instruments

| Instrument | Minimum Performance Requirements |
| :--- | :--- |
| **Mixed Signal Oscilloscope (MSO)** | <ul><li>**Bandwidth:** $\ge 100\text{ MHz}$</li><li>**Sampling Rate:** $\ge 500\text{ MHz}$</li><li>**Channels:** $\ge 4$ analog channels, $\ge 8$ digital channels</li><li>**Input Range:** $0\text{V}$ to $3.6\text{V}$</li></ul> |
| **Logic Analyzer** |<ul><li>**Sampling Rate:** $\ge 100\text{ MHz}$</li><li>**Channels:** $\ge 8$ digital input channels</li><li>**Threshold:** Fixed or adjustable at $3.3\text{V}$</li></ul> |
| **DC Power Supply** | <ul><li>**Voltage:** $+5\text{V}$</li><li>**Current Limit:** $500\text{ mA}$</li></ul> |

## External Circuitry
### Input Signal Debouncing
Mechanical switches assigned to control inputs (`start`, `door_closed`, `reset_in`) exhibit contact bounce. To prevent unintended multiple triggering of synchronous circuits on clock edges, an external hardware low-pass RC network combined with a Schmitt-trigger buffer must be connected between the switch and the FPGA pins.

## Test Cases
All clock cycles transition on the positive edge (`posedge clk`). 

*Configuration Context:* In **Quick Mode** (`mode_select = 0`), the timer module loads two specific limits:
* States: `FILL`, `RINSE`, `DONE` triggers a duration of **3 cycles** (`4'b0011`).
* States: `WASH`, `SPIN` triggers a duration of **5 cycles** (`4'b0101`).

### Test Case 1: Power-On Reset and IDLE Verification
Verify that the hardware forces all registers into their safe, predictable default states upon initialization and remains safely in the `IDLE` state while no operational triggers are active.

| Cycle | Applied Inputs<br>`(reset_in, start, door_closed, mode_select)` | Expected State | Expected Digital Outputs<br>`(water_valve, wash_motor, spin_motor, done_led)` | Measured | Pass / Fail |
| :---: | :--- | :---: | :--- |  :--- |  :--- | 
| **1** | `0, 0, 0, 0` *(Reset Active)* | **IDLE** | `0, 0, 0, 0` | | |
| **2** | `1, 0, 0, 0` *(Reset Released)* | **IDLE** | `0, 0, 0, 0` |  | |

### Test Case 2: Door Safety Interlock (WARN State)
Validate the safety logic within the UI and FSM sub-modules. The system must refuse activation and trigger a distinct warning output if a start sequence is attempted while the machine door is physically open.

| Cycle | Applied Inputs<br>`(reset_in, start, door_closed, mode_select)` | Expected State | Expected Digital Outputs<br>`(water_valve, wash_motor, spin_motor, done_led)` | Measured | Pass / Fail |
| :---: | :--- | :---: | :--- | :--- |  :--- | 
| **1** | `1, 1, 0, 0` *(Start with Door Open)* | **WARN** | `0, 0, 0, 1`| | |
| **2** | `1, 0, 0, 0` *(Start Released)* | **IDLE** | `0, 0, 0, 0` | | |

### Test Case 3: Water Fill Cycle and Timer Selection
Verify successful FSM advancement into operational states and ensure that the timer correctly loads, tracks, and terminates a low-duration cycle configuration (3 clock cycles).

| Cycle | Applied Inputs<br>`(reset_in, start, door_closed, mode_select)` | Expected State | Expected Digital Outputs<br>`(water_valve, wash_motor, spin_motor, done_led)` | Measured | Pass / Fail |
| :---: | :--- | :---: | :--- |  :--- |  :--- | 
| **1** | `1, 1, 1, 0` *(Valid Cycle Start)* | **FILL** | `1, 0, 0, 0`| | |
| **2** | `1, 1, 1, 0` | **FILL** | `1, 0, 0, 0`| | |
| **3** | `1, 1, 1, 0` | **FILL** | `1, 0, 0, 0`| | |
| **4** | `1, 1, 1, 0` | **FILL** | `1, 0, 0, 0`| | |
| **5** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0`| | |

### Test Case 4: Extended Wash Cycle and Timer Selection
Validate that the dynamic timing logic correctly identifies a high-duration state operation and sets the cycle runtime to 5 clock cycles when active.

| Cycle | Applied Inputs<br>`(reset_in, start, door_closed, mode_select)` | Expected State | Expected Digital Outputs<br>`(water_valve, wash_motor, spin_motor, done_led)` | Measured | Pass / Fail |
| :---: | :--- | :---: | :--- |  :--- |  :--- | 
| **1** | `1, 1, 1, 0` *(FSM enters Wash)* | **WASH** | `0, 1, 0, 0` *(Wash Motor active, timer_sel=1)*|
| **2** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` |  | |
| **3** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` |  | |
| **4** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` |  | |
| **5** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` |  | |
| **6** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` |  | |
| **7** | `1, 1, 1, 0` | **RINSE**| `1, 1, 0, 0` |  | |

### Test Case 5: Runtime Reset
Verify synchronous reset behavior. Activating the reset should set the state into their reset state after one clock cycle.

| Cycle | Applied Inputs<br>`(reset_in, start, door_closed, mode_select)` | Expected State | Expected Digital Outputs<br>`(water_valve, wash_motor, spin_motor, done_led)` | Measured | Pass / Fail |
| :---: | :--- | :---: | :--- |  :--- |  :--- | 
| **1** | `1, 1, 1, 0` | **WASH** | `0, 1, 0, 0` | | |
| **2** | `0, 1, 1, 0` | **WASH** | `0, 1, 0, 0` | | |
| **3** | `1, 0, 0, 0` | **IDLE** | `0, 0, 0, 0` | | |