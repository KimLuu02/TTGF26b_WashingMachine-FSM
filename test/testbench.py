import cocotb
from cocotb.triggers import Timer, RisingEdge, ReadOnly, ClockCycles
from cocotb.clock import Clock

import os

GATE_LEVEL = os.getenv("GATES") == "yes"



@cocotb.test(skip=GATE_LEVEL)
async def req_1_mode_select(dut):
    """ REQ-1: the selected washing mode shall be forwarded by the UI module """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.start.value = 0
    dut.reset_in.value = 0
    dut.mode_select.value = 0
    dut.door_closed.value = 1

    await RisingEdge(dut.clk)
    #Test quick mode
    dut.reset_in.value = 1
    await RisingEdge(dut.clk)

    dut.mode_select.value = 0
    await RisingEdge(dut.clk)

    assert dut.user_project.top_system_inst.mode.value == 0, "REQ-1 failed: mode was not 0"

    #Test normal mode
    dut.mode_select.value = 1

    await RisingEdge(dut.clk)
    assert dut.user_project.top_system_inst.mode.value == 1, "REQ-1 failed: mode was not 1"

    dut._log.info("Req-1 Passed")

@cocotb.test(skip=GATE_LEVEL)
async def req_2_door_open_warning(dut):
    """ REQ-2: If the door is open, the washing cycle should not start and a warning signal should be given """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.door_closed.value = 0
    dut.reset_in.value = 1
    dut.mode_select.value = 0

    # Testing
    dut.start.value = 1
    await RisingEdge(dut.clk)
    
    assert dut.user_project.top_system_inst.warning.value == 1, "REQ-2 failed: warning was not active"
    assert dut.user_project.top_system_inst.start_cycle.value == 0, "REQ-2 failed: start_cycle started"

    dut._log.info("Req-2 Passed")

@cocotb.test(skip=GATE_LEVEL)
async def req_3_reset(dut):
    """ REQ-3: If the user presses the reset button, all modules should go to their reset state """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 1
    dut.mode_select.value = 0
    dut.door_closed.value = 1
    dut.start.value = 1

    # Testing
    dut.reset_in.value = 0
    await RisingEdge(dut.clk)

    assert dut.user_project.top_system_inst.reset_out.value == 0, "REQ-3 failed: reset_out was not 0"
    assert dut.user_project.top_system_inst.timer_en.value == 0, "REQ-3 failed: timer was enabled"

    dut._log.info("Req-3 Passed")

@cocotb.test(skip=GATE_LEVEL)
async def req_4_start_cycle(dut):
    """ REQ-4: The washing cycle or warning should only start if the user pressed the start button """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 1
    dut.mode_select.value = 0
    

    # Testing
    dut.door_closed.value = 1
    dut.start.value = 0
    await RisingEdge(dut.clk)

    assert dut.user_project.top_system_inst.start_cycle.value == 0, "REQ-4 failed: Cycle started"
    assert dut.user_project.top_system_inst.timer_en.value == 0, "REQ-4 failed: timer was enabled"
    assert dut.user_project.top_system_inst.warning.value == 0, "REQ-4 failed: there was a warning"

    dut._log.info("Req-4 Passed")

@cocotb.test()
async def req_5_warning_LED(dut):
    """ REQ-5: If the door is not closed, the washing machine should warn the user """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 1
    dut.mode_select.value = 0
    dut.door_closed.value = 0

    # Testing
    dut.start.value = 1
    await RisingEdge(dut.clk)

    await ReadOnly()

    if not GATE_LEVEL:
        assert dut.user_project.top_system_inst.warning.value == 1, "REQ-5 failed: Warning is not on"
    assert dut.done_led.value == 1, "REQ-5 failed: LED not on"

    dut._log.info("Req-5 Passed")

@cocotb.test()
async def req_6_warning_LED(dut):
    """ REQ-6:  After succefully starting the washing machine, the washing cycle begins """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 0
    dut.mode_select.value = 0
    dut.door_closed.value = 1
    dut.start.value = 0

    await RisingEdge(dut.clk)

    # Testing
    dut.reset_in.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 1

    await RisingEdge(dut.clk)

    await ReadOnly()

    if GATE_LEVEL:
        assert dut.user_project.top_system_inst.timer_en.value == 1, "REQ-6 failed: timer not enabled"
        assert dut.user_project.top_system_inst.warning.value == 0, "REQ-6 failed: Warning active"
    assert dut.water_valve.value == 1, "REQ-6 failed: water valve was not turned on"

    dut._log.info("Req-6 Passed")

@cocotb.test()
async def req_7_wash_cycles(dut):
    """ REQ-7:  After succefully starting the washing machine, the washing cycle begins """
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 0
    dut.mode_select.value = 0
    dut.door_closed.value = 1
    dut.start.value = 0

    await RisingEdge(dut.clk)

    # Testing
    dut.reset_in.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 0

    await ReadOnly()

    # FILL
    assert dut.wash_motor.value == 0, "REQ-7 failed: FILL Wash motor active"
    assert dut.spin_motor.value == 0, "REQ-7 failed: FILL Spin motor active"
    assert dut.water_valve.value == 1, "REQ-7 failed: FILL Water valve inactive"

    await ClockCycles(dut.clk, 5) # 3 cycles
    await ReadOnly()

    # WASH
    assert dut.wash_motor.value == 1, "REQ-7 failed: WASH Wash motor inactive"
    assert dut.spin_motor.value == 0, "REQ-7 failed: WASH Spin motor active"
    assert dut.water_valve.value == 0, "REQ-7 failed: WASH Water valve active"

    await ClockCycles(dut.clk, 7) # 5 cycles
    await ReadOnly()

    # RINSE
    assert dut.wash_motor.value == 1, "REQ-7 failed: RINSE Wash motor inactive"
    assert dut.spin_motor.value == 0, "REQ-7 failed: RINSE Spin motor active"
    assert dut.water_valve.value == 1, "REQ-7 failed: RINSE Water valve inactive"

    await ClockCycles(dut.clk, 5) # 3 cycles
    await ReadOnly()

    # SPIN
    assert dut.wash_motor.value == 0, "REQ-7 failed: SPIN Wash motor active"
    assert dut.spin_motor.value == 1, "REQ-7 failed: SPIN Spin motor inactive"
    assert dut.water_valve.value == 0, "REQ-7 failed: SPIN Water valve active"

    await ClockCycles(dut.clk, 7) # 5 cycles
    await ReadOnly()

    # DONE
    assert dut.done_led.value == 1, "REQ-7 failed: led not on"

    await ClockCycles(dut.clk, 5) # 5 cycles
    await ReadOnly()

    # IDLE
    assert dut.wash_motor.value == 0, "REQ-7 failed: SPIN Wash motor active"
    assert dut.spin_motor.value == 0, "REQ-7 failed: SPIN Spin motor active"
    assert dut.water_valve.value == 0, "REQ-7 failed: SPIN Water valve active" 
    assert dut.done_led.value == 0, "REQ-7 failed: led still on"

  
    dut._log.info("Req-7 Passed")

@cocotb.test(skip=GATE_LEVEL)
async def req_8_9_timer(dut):
    """ REQ-8 and 9:  After receiving the signal to start, the timer should start counting the cycles and output a signal, after the timer is done"""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 0
    dut.mode_select.value = 0
    dut.door_closed.value = 1
    dut.start.value = 0

    await RisingEdge(dut.clk)

    # Testing
    dut.reset_in.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 0

    await ReadOnly()

    # FILL
    assert dut.user_project.top_system_inst.timer_en.value == 1, "REQ-8 failed: Timer did not start"

    await ClockCycles(dut.clk, 4) # 3 cycles
    await ReadOnly()

    # Timer check
    assert dut.user_project.top_system_inst.timer_done.value == 1, "REQ-9 failed: Timer did not stop"

    dut._log.info("Req-8 and 9 Passed")

@cocotb.test(skip=GATE_LEVEL)
async def req_10_duration(dut):
    """ REQ-10:  The user can select a mode which changes the duration of each washing cycle"""
    cocotb.start_soon(Clock(dut.clk, 20, unit="ns").start())

    #Set initial inputs
    dut.reset_in.value = 0
    dut.mode_select.value = 1
    dut.door_closed.value = 1
    dut.start.value = 0

    await RisingEdge(dut.clk)

    # Testing
    dut.reset_in.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 1
    await RisingEdge(dut.clk)

    dut.start.value = 0

    await ReadOnly()

    # FILL
    await ClockCycles(dut.clk, 6) # 5 cycles
    await ReadOnly()

    # Timer check
    assert dut.user_project.top_system_inst.timer_done.value == 1, "REQ-10 failed: Timer did not stop after 5 cycles for normal mode for FILL"

    dut._log.info("Req-10 Passed")