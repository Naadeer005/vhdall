# Digital Logic Laboratory — complete VHDL examples

Complete implementations of the VHDL exercises in [Digital Logic Laboratory 010113026](https://pruks-dev.github.io/digital-lab/), Labs 3–8, for the **DE10-Lite / MAX 10 10M50DAF484C7G**. All design files use VHDL-93 and `ieee.std_logic_1164`; arithmetic uses `ieee.numeric_std`.

There are **36 design `.vhd` files**, **18 assertion-based testbenches**, and a shared test package. Labs 1–2, review-question extensions, and the open-ended mini project are excluded. Lab 3.1 is project setup and has no separate circuit; Lab 8.2 tests the same multiplier built in Lab 8.1.

## Open an experiment in Quartus

1. Create a project targeting `10M50DAF484C7G`.
2. Find its group in `tests/experiments.json`. Add only the design files listed under `sources`, in their listed dependency order. Shared circuits live in `common/`.
3. Select the desired entity from `tops` as the top-level entity. Set the VHDL input version to VHDL-1993.
4. Assign the ports to the board signals listed below, using the DE10-Lite board manual for physical pins. All 50 MHz clocks map to `MAX10_CLK1_50`, **PIN_P11**.
5. Compile, inspect timing and warnings, and program the board using USB-Blaster.

The manifest is the authoritative dependency list. **Do not add every `.vhd` file to one project:** the scalar/vector examples both use entity `switch_to_led`, and the three converters all use entity `bin_to_bcd` with different interfaces. Each experiment is compiled in its own work directory. Testbenches and `tb_pkg.vhd` are simulation sources, not FPGA design inputs. Pin constraints, timing constraints, Quartus project files, and programming images are not included.

## Experiments, entities, and board connections

### Lab 3 — switches, multiplexers, and displays

Source: [Lab 3](https://pruks-dev.github.io/digital-lab/lab-3/).

- **3.2 scalar**, `lab3/3_2_scalar/switch_to_led.vhd`, top `switch_to_led`, group `lab3_scalar`: `sw0`–`sw9` → SW0–SW9; `led0`–`led9` → LEDR0–LEDR9.
- **3.2 vector**, `lab3/3_2_vector/switch_to_led.vhd`, top `switch_to_led`, group `lab3_vector`: `sw(9:0)` → SW9–SW0; `led(9:0)` → LEDR9–LEDR0.
- **3.3.1–3.3.3**, `lab3/3_3_mux/`, group `lab3_mux`: top `mux_2to1_gate` or `mux_2to1` uses `i0` → SW0, `i1` → SW1, `s` → SW2, `y` → LEDR0. Top `mux_2to1_4bit` uses `a(3:0)` → SW3–SW0, `b(3:0)` → SW7–SW4, `s` → SW8, `y(3:0)` → LEDR3–LEDR0.
- **3.4**, `lab3/3_4_display/mux_7seg.vhd`, top `mux_7seg`, group `lab3_display`: `sw(1:0)` → SW1–SW0; `hex0(7:0)` → HEX0, selecting digits 0–3.

### Lab 4 — combinational circuits

Source: [Lab 4](https://pruks-dev.github.io/digital-lab/lab-4/).

- **4.1**, `common/bcd_to_7seg.vhd`, top `bcd_to_7seg`, group `lab4_decoder`: complete minimized gate equations; `bcd(3:0)` → SW3–SW0; `seg(7:0)` → HEX0. BCD 10–15 blanks the display.
- **4.2**, `lab4/4_2_binary_display/`, group `lab4_binary_display`: top `bin_to_bcd` converts four-bit values 0–15; `bin(3:0)` → SW3–SW0, `bcd1(3:0)` → LEDR7–LEDR4, `bcd0(3:0)` → LEDR3–LEDR0. Top `bin_to_dual_7seg` structurally connects that converter to two instances of the shared decoder; `hex1`/`hex0` → HEX1/HEX0, displaying decimal 00–15.
- **4.3**, `common/full_adder.vhd` and `lab4/4_3_adder/`, group `lab4_adder`: top `full_adder` provides a one-bit reusable cell; `adder_4bit` structurally chains four cells with initial carry zero. `a(3:0)` → SW3–SW0; `b(3:0)` → SW7–SW4; `sum(3:0)` → LEDR3–LEDR0; `overflow` → LEDR5. Top `adder_display_top` adds HEX1/HEX0. These displays intentionally show the low four-bit sum (0–15); LEDR5 reports unsigned carry beyond 15.

### Lab 5 — sequential circuits

Source: [Lab 5](https://pruks-dev.github.io/digital-lab/lab-5/).

- **5.1**, `lab5/5_1_latches/`, group `lab5_rs`: top `rs_latch` uses `s_n` → SW0, `r_n` → SW1, `q` → LEDR0, `q_n` → LEDR1. Top `rs_gated_latch` uses active-high `s` → SW0, `r` → SW1, `e` → SW2, `q` → LEDR0.
- **5.2.1**, `lab5/5_2_flip_flops/d_gated_latch.vhd`, top `d_gated_latch`, group `lab5_d`: `d` → SW0, `e` → SW2, `q`/`q_n` → LEDR0/LEDR1. Input gating and the cross-coupled NAND pair remain structural.
- **5.2.2–5.2.3**, `lab5/5_2_flip_flops/d_flip_flop_ms.vhd` and `common/d_flip_flop.vhd`, tops `d_flip_flop_ms` and `d_flip_flop`, group `lab5_d`: `d` → SW0, `clk` → KEY0, `q` → LEDR0. A rising clock edge captures data, so the board captures on **button release**.
- **5.3**, `lab5/5_3_register/register_4bit.vhd`, top `register_4bit`, group `lab5_register`: `d(3:0)` → SW3–SW0; `clk` → KEY0; `q(3:0)` → LEDR3–LEDR0.

### Lab 6 — counters, RTC, stopwatch, and scrolling

Source: [Lab 6](https://pruks-dev.github.io/digital-lab/lab-6/).

- **6.1.1**, `lab6/6_1_counter/ripple_counter_top.vhd`, top `ripple_counter_top`, group `lab6_counter`: four shared D flip-flops with inverted feedback and cascading clocks; `clk` → KEY0; `led(3:0)` → LEDR3–LEDR0. Count advances on release.
- **6.1.2**, `common/clock_divider.vhd`, entity `clock_divider`, group `lab6_counter`: `clk` → 50 MHz; `tick` is an internal one-cycle clock enable, not a new clock. Generic `DIV_COUNT` defaults to 50,000,000. With `DIV_COUNT=1`, every cycle is enabled.
- **6.1.3**, `lab6/6_1_counter/counter_top.vhd`, top `counter_top`, group `lab6_counter`: `clk` → 50 MHz; `led(3:0)` → LEDR3–LEDR0. Its `DIV_COUNT` generic defaults to 50,000,000.
- **6.2.1**, `common/mod_counter.vhd`, `common/hours_counter.vhd`, and `lab6/6_2_time/rtc_top.vhd`, group `lab6_rtc`: top `rtc_top` uses `clk` → 50 MHz; `hex5`…`hex0` → HEX5…HEX0, displaying HH:MM:SS with 24-hour rollover. Structural enable chains reuse the shared counters and decoder. `mod_counter` has `MOD_VALUE` 1–16, four-bit `count`, one-cycle `carry`, and default-low synchronous `clr`. `hours_counter` has `tens`, `\units\`, and default-low `clr`; `units` is a reserved word, so the port uses a VHDL-93 extended identifier.
- **6.2.2**, `lab6/6_2_time/stopwatch_top.vhd`, top `stopwatch_top`, group `lab6_stopwatch`: same clock/displays as RTC; `key0` → KEY0 (press toggles start/stop); `key1` → KEY1 (press clears all digits and stops). It starts stopped at 00:00:00. Both time top levels expose `DIV_COUNT`, default 50,000,000.
- **6.3.1–6.3.2**, `lab6/6_3_scrolling/`, group `lab6_scrolling`: entities `char_to_7seg`, `message_rom`, and top `scrolling_top`. `clk` → 50 MHz; `sw9` → SW9; `hex5`…`hex0` → HEX5…HEX0. `DIV_COUNT` defaults to 50,000,000. The message is H,E,L,L,O,space,space,space; character codes are space=0, H=1, E=2, L=3, O=4.

The scrolling circuit preserves the worksheet's explicit mapping: **HEXn = message[position+n]**, positions 0–2. HEX0 is the rightmost display, so the physical order HEX5→HEX0 is initially ` OLLEH`, then `  OLLE`, then `   OLL`. SW9=0 cycles positions 0→1→2→0; SW9=1 cycles 0→2→1→0. The worksheet's verbal “HELLO scrolling left” description does not match that mapping; the implemented index mapping is intentional.

RTC and stopwatch use registered carry pulses. A rollover travels across digits over several 50 MHz cycles before all displayed digits settle. The divider's registered tick is consumed by counters on the following clock edge. This is the worksheet's enable-chain behavior. The stopwatch gates the seconds enable, keeps the oscillator/divider running while paused, and does not preserve a fractional second when stopped. Any already-issued carry finishes propagating after a stop.

### Lab 7 — calculator and accumulator

Source: [Lab 7](https://pruks-dev.github.io/digital-lab/lab-7/).

- **7.1**, `lab7/7_1_calculator/`, group `lab7_calculator`: top `calculator_top`, with its five-bit `bin_to_bcd`, the shared button synchronizer, six-bit structural `adder_n`/`full_adder`, and decoder. `clk` → 50 MHz; `a(3:0)` → SW3–SW0; `b(3:0)` → SW7–SW4; `key0` → KEY0 (add); `key1` → KEY1 (subtract); `hex2` → HEX2 (minus/blank); `hex1`/`hex0` → HEX1/HEX0. Results remain latched until the next press. Simultaneous synchronized presses select addition. The converter handles the full five-bit range 0–31, including the unused value 31.
- **7.2**, `lab7/7_2_accumulator/`, group `lab7_accumulator`: top `accumulator_top` and its eight-bit, three-digit `bin_to_bcd`. `clk` → 50 MHz; `a(7:0)` → SW7–SW0; `add_sub` → SW8 (0=add, 1=subtract); `key0` → KEY0 (one accumulation); `key1` → KEY1 (reset); `hex3` → HEX3 (minus/blank); `hex2`…`hex0` → HEX2…HEX0; `overflow` → LEDR9. Reset wins over accumulation.

The accumulator stores a signed nine-bit value (-256…255). Each operation evaluates a ten-bit sum, flags results below 0 or above 255, then keeps the low nine bits (modulo-512 wrapping). LEDR9 records the **last operation's** range check until another operation or reset. For example, 127+131 gives a full sum of 258, stores -254, displays -254, and sets overflow. The exceptional magnitude 256 bypasses the eight-bit BCD converter so -256 displays correctly.

### Lab 8 — FSM multiplier

Source: [Lab 8](https://pruks-dev.github.io/digital-lab/lab-8/).

- **8.1–8.2**, `lab8/8_1_multiplier/`, group `lab8_multiplier`: `multiplier_fsm` is a four-state shift-and-add core; `multiplier_top` combines button synchronization, that core, the Lab 7.2 eight-bit converter, and three shared decoders. `clk` → 50 MHz; `a(3:0)` → SW3–SW0; `b(3:0)` → SW7–SW4; `key0` → KEY0; `hex2`…`hex0` → HEX2…HEX0; `done` → LEDR9.

The core accepts a one-cycle `start` only in IDLE, snapshots A/B, performs four ADD and three SHIFT operations, and publishes the product on the **ninth rising edge including the acceptance edge**. The DONE-state identifier is `DONE_STATE` to avoid colliding with the output port `done`. Starts during ADD, SHIFT, or DONE are ignored. Operand changes during computation have no effect. The prior completed product stays visible during computation; `done` clears on a new acceptance and stays high after completion until another acceptance. Holding KEY0 causes only one start. The two-stage synchronizer means acceptance occurs on the third sample edge after a stable button press; core latency is measured from that acceptance.

## Corrections and teaching limitations

- Completed all omitted architectures, truth-table assignments, gate equations, connections, and display digits. Explicitly blanked undefined selector/ROM codes; invalid BCD values 10–15 blank every segment.
- Displays consistently use **bit 7 = dp**, bits 6…0 = g,f,e,d,c,b,a; **0 lights a segment**. Decimal points are off. The worksheet's seven-bit character literals were replaced with correct eight-bit H/E/L/O patterns.
- Replaced illegal expression slices in `hours_counter` with VHDL-93-compatible decimal extraction. Used `\units\` for the worksheet's otherwise illegal reserved-word port.
- Zero-extended unsigned switch values before signed arithmetic. Subtraction occurs at the full adder width, so a four-bit two's-complement value is never mistakenly zero-extended into a positive number. The calculator has separate combinational sum and result register signals, avoiding multiple drivers.
- Always deasserted modulo-counter carry by default each cycle, including disabled cycles and clear, preventing repeated carries in the stopwatch.
- The shared behavioral D flip-flop initializes its internal state to zero. This deliberate change makes the feedback ripple counter start and simulate deterministically. The Lab 5 register and structural latches retain their unspecified power-up states and must be driven/captured before checking outputs.
- Buttons sampled by the 50 MHz logic pass through two synchronizer stages before falling-edge detection. This does not provide software debouncing. The board's hardware debounce is assumed. Set switch operands before pressing and keep them stable through synchronized acceptance; switch buses are not independently synchronized.
- The structural latch examples intentionally contain combinational feedback, and the ripple counter intentionally uses derived clocks. Synthesis may report loops/derived clocks; these are teaching circuits. No software delay is added to disguise their hardware behavior.
- An RS NAND latch driven with both active-low inputs zero gives Q=Qn=1. Simultaneous release is undefined and can cause a zero-delay simulation to oscillate. Tests release one input at a time. Master-slave tests obey setup/hold intervals. Simulation does not model metastability or real gate propagation delays.

## Run the checks

From this folder in PowerShell, with GHDL on PATH:

```powershell
./tools/test.ps1
./tools/test.ps1 -Experiment lab8_multiplier -Wave
./tools/test.ps1 -Experiment lab7_calculator,lab7_accumulator
./tools/test.ps1 -CompileOnly
```

The runner analyzes and elaborates every listed design top and testbench as **VHDL-93**, using `.build/<group>/` for isolated work libraries. `-Wave` writes GHDL `.ghw` waveforms there. Assertion failure, simulator failure, or failure to reach a testbench's PASS marker makes the runner fail. `-CompileOnly` performs analysis/elaboration without running generated executables. `-Ghdl` selects another GHDL command/path.

For the installed Questa/ModelSim tools (`vlib`, `vcom`, and `vsim` on PATH):

```powershell
./tools/test-questa.ps1
./tools/test-questa.ps1 -Experiment lab6_rtc,lab6_stopwatch
```

The Questa runner uses the same manifest/testbenches and stores compile/simulation logs in `.build/questa_<group>/`. It stops on assertions and also requires each PASS marker.

Coverage includes:

- All 1,024 switch patterns for both interfaces, every mux input/select combination, all 16 BCD decoder inputs, and every four-, five-, and eight-bit BCD input.
- All full-adder combinations and all 256 four-bit operand pairs; display integration includes overflow cases.
- Latch set/reset/hold/enable and forbidden-state behavior; D-latch transparency, master-slave and behavioral rising-edge capture, register retention, and deterministic ripple-counter startup/wrap.
- Divider counts 1, 2, and 4; modulo counters 1, 6, 10, and 16; carry pulse clearing, enable hold, and reset priority; every stable RTC second through a complete 24-hour cycle, including midnight.
- Stopwatch start/stop/reset, simultaneous reset/start, restart, and held buttons; all ROM addresses/character codes and scrolling in both directions.
- Calculator addition and subtraction for every A/B pair, retention, simultaneous-button priority, and held-button behavior.
- The worksheet's accumulator sequence, overflow and signed wraps in both directions, retention, reset, and -256.
- All 256 multiplier operand pairs, exact completion latency, busy starts, operand changes while busy, result/done retention, held start, and integrated decimal display.

### Validation on this workstation

Verified on **6 October 2026**:

- **GHDL 6.0.0 (LLVM backend):** analysis and elaboration passed for all 17 experiment groups, including their design tops and testbenches. The first four groups also passed GHDL simulation; Windows Application Control blocked the generated decoder simulation executable, so remaining simulation verification used Questa.
- **Questa Altera Starter FPGA Edition 2025.2:** all 18 testbenches reached their PASS markers, covering all 17 experiment groups. Logs are retained in the corresponding `.build/questa_<group>/` directories.
- **Dependency audit:** all 36 design files appear in the manifest, and every listed source/testbench exists.

GHDL's native simulation executables can be blocked by this workstation's Windows Application Control policy. Use Questa to run the same tests if that happens; the OS policy is left intact. **Quartus synthesis, timing closure, pin assignments, and physical DE10-Lite programming have not been verified.**
