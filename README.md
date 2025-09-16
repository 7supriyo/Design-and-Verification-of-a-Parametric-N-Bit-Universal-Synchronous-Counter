# Design and Verification of a Parametric N-Bit Universal Synchronous Counter

## Overview

This project demonstrates the **design and verification of a parametric N-bit universal synchronous counter** using a combination of hardware description (Verilog) and modern, software-driven verification techniques. The workflow incorporates high-level modeling in Python to automate the creation of test vectors, and a self-checking Verilog testbench to validate the RTL implementation.

---

## Features

- **Parametric Counter:**  
  The counter module (`counter.v`) is parameterized for bit-width (`N`), making it reusable for different sizes (default is 8 bits).
- **Universal Operation:**  
  Supports hold, count-up, count-down, and parallel load operations via a 2-bit control signal.
- **Automated Test Vector Generation:**  
  A Python script (`generate_vectors.py`) implements a "golden model" of the counter, generating comprehensive and randomized test vectors.
- **Self-Checking Testbench:**  
  The Verilog testbench (`tb_counter.v`) reads the test vectors, applies them to the DUT, and automatically checks the output against expected values.
- **Simulation Results:**  
  All results are dumped for waveform analysis (e.g., GTKWave).

---

## Methodology

### 1. Hardware Description (RTL)

- The counter is described in Verilog (`counter.v`), supporting:
  - **Hold** (`control=2'b00`): Retains current value
  - **Count Up** (`control=2'b01`): Increments
  - **Count Down** (`control=2'b10`): Decrements
  - **Parallel Load** (`control=2'b11`): Loads input value

### 2. Golden Model & Test Vector Generation

- `generate_vectors.py` defines a Python class that models the counter's expected behavior.
- The script generates directed and randomized test vectors, outputting them in binary format to `test_vectors.txt`.

### 3. Self-Checking Testbench

- `tb_counter.v` initializes the DUT and reads test vectors from `test_vectors.txt`.
- On each clock cycle, it applies inputs and compares the DUT output to the expected value.
- Discrepancies are reported, and a summary is displayed at the end of simulation.

---

## How to Run

### 1. Generate Test Vectors

```bash
python generate_vectors.py
```
This creates `test_vectors.txt` with a mix of directed and random tests.

### 2. Simulate the Testbench

Use your preferred Verilog simulator (e.g., Icarus Verilog, ModelSim).

```bash
# For Icarus Verilog
iverilog -g2012 -o tb_counter tb_counter.v counter.v
vvp tb_counter
```

### 3. View Waveforms (Optional)

```bash
gtkwave counter_wave.vcd
```

---

## File Structure

- `counter.v` - Verilog RTL for the parametric universal counter
- `generate_vectors.py` - Python script for automated test vector generation (golden model)
- `tb_counter.v` - Self-checking Verilog testbench
- `test_vectors.txt` - Generated test vectors (input/output reference)
- `counter_wave.vcd` - Simulation waveform dump

---

## Key Takeaways

- Combines **hardware and software techniques** for robust verification.
- **Python golden model** ensures the correctness of test vectors and serves as a reference for expected DUT behavior.
- **Self-checking testbench** automates output validation, improving confidence in design correctness.
- The methodology is scalable, reusable, and adaptable to other digital designs beyond counters.

---

