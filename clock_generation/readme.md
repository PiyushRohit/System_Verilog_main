# Verilog Clock Generation Testbench

This folder contains a Verilog testbench that demonstrates how to generate custom clock signals using tasks to compute pulse characteristics such as duty cycle, frequency, and phase shift.

## 📁 Files

- `tb.v`: The main Verilog testbench file.
- `dut.vcd`: Waveform output file generated after simulation (viewable with GTKWave or similar tools).

## 🛠️ Features

- **Primary Clock (`clk`)**:
  - 100 MHz (10 ns period)
  - Square wave generated using an `always` block.

- **Derived Clock (`clk50`)**:
  - Frequency, duty cycle, and phase shift are configurable via the `calc` task.
  - Pulse generation implemented using `clkgen` task.

- **Tasks Used**:
  - `calc`: Computes `ton`, `toff`, and handles phase offset.
  - `clkgen`: Generates pulses with calculated timing based on `calc`.

## 🧪 Simulation Output

A waveform dump (`dut.vcd`) is generated and can be viewed using [GTKWave](http://gtkwave.sourceforge.net/):

```bash
gtkwave dut.vcd
