# FPGA Test Report

This report documents the physical silicon verification of the digital Washing Machine Controller module implemented on the iCEbreaker FPGA development board. The design encapsulates the `ui_module`, the state machine `wmFSM`, and the dynamic `timer_module`.

## Preperation
### FPGA Pin Mapping

| Port | Pin | Description |
| :--- | :---: | :--- |
| **`clk`** | **18** | Push button, generating single clock step transitions |
| **`reset_in`** | **10** | Push button tied to an internal pull-up resistor |
| **`start`** | **20** | Push button used to start the operation |
| **`door_closed`** | **19** | Push button simulating the door interlock sensor |
| **`mode_select`** | **4** | PMOD 1A used to select the washing program configuration |
| **`water_valve`** | **21** | LED1 on board |
| **`wash_motor`** | **22** | LED2 on board |
| **`spin_motor`** | **23** | LED3 on board|
| **`done_led`** | **25** | LED4 on board |

### Manual Clock Control via Push Button (Clock Substitution)
The onboard crystal oscillator on the iCEbreaker FPGA delivers a continuous master system clock of **12 MHz** (`CLK` mapped to Pin 35). Because this frequency transitions state registers twelve million times per second, human visual tracking of individual FSM state movements, output indicator flips, and cycle timer steps is impossible. 

A **mechanical push button** connected to **Pin 18** acts as the manual clock substitute to cycle through the sequential system manually and inspect state logic changes in real time.


## 3. Testing & Verification Log

| Testcase | Description | Status |
| :---: | :--- | :--- |
| [1](silicon-testing-procedure.md#test-case-1-power-on-reset-and-idle-verification)| **Power-On Reset & Initial IDLE State**<br>Verify pressing `reset_in = 0` clears all internal state registers. Upon release (`reset_in = 1`), all outputs must stay `0` in `IDLE` | PASS |
| [2](silicon-testing-procedure.md#test-case-2-door-safety-interlock-warn-state) | **Door Safety Interlock**<br>Assert `start = 1` while `door_closed = 0`. System must enter `WARN`, activate `done_led = 1`. Shifting `start = 0` must return FSM to `IDLE` | PASS |
| [3](silicon-testing-procedure.md#test-case-3-water-fill-cycle-and-timer-selection-) | **Water Fill Phase**<br>Trigger start with door closed in normal mode. FSM must enter `FILL`, drive `water_valve = 1`, and hold for exactly **3 manual clock cycles** before jumping to `WASH` | PASS |
| [4](silicon-testing-procedure.md#test-case-4-extended-wash-cycle-and-timer-selection-) | **Extended Wash Phase**<br>Step FSM into `WASH`. Verify `wash_motor = 1` activates and the timer dynamically scales the holding duration to lock execution for exactly **5 manual clock cycles** before jumping to `RINSE` | PASS |
| [5](silicon-testing-procedure.md#test-case-5-runtime-reset) | **Runtime Reset**<br>Assert `reset_in = 0` during active runtime operations. All driven outputs must drop to `0` after one clock cycle, forcing FSM back to `IDLE` | PASS |