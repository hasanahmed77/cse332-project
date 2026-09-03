# CSE332 / EEE336 — Single-Cycle MIPS Project

Assignment #5 (Summer 2026): extend a single-cycle MIPS datapath with new
instructions, assemble MIPS assembly into machine code, and simulate the
result — done entirely natively on Windows (no WSL). Nothing here is
Windows-specific, though; the same steps work unchanged on macOS, just with
Homebrew and clang/g++ instead of MSYS2 (see below).

## Contents

```
├── MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/   Single-cycle MIPS datapath (Verilog)
├── Assembler/Assembler/                     MIPS assembler (C++)
└── CSE 332 Assignment#5_*.pdf               Assignment sheet
```

## What's implemented

Starting from the given "WOJAL" (Without JAL) single-cycle datapath, which
already had SLL/SRL wired up, the following were added:

| Instruction | Type | What it does |
|---|---|---|
| **JAL** `jal target` | J-type | Jumps to `target`, and writes `PC+4` into `$ra` ($31) |
| **JR** `jr $ra` | R-type | Jumps to the address held in `$ra` (or any register) |
| **MULT** `mult $rs,$rt` | R-type | 64-bit signed multiply: `{HI,LO} = $rs * $rt` |
| **MFHI** `mfhi $rd` | R-type | `$rd = HI` |
| **MFLO** `mflo $rd` | R-type | `$rd = LO` |

All five were verified end-to-end: assembled with the (Windows-native)
assembler, loaded into the instruction ROM, and run in simulation, with
register/HI/LO values checked against hand-calculated expected results.

## Hardware changes (Verilog)

| File | Change |
|---|---|
| `control.v` | New outputs `JAL`, `JR`, `MultOp`, `MFHiLo`. Decodes JAL (opcode `000011`), JR (funct `001000`), MULT (funct `011000`), MFHI (funct `010000`), MFLO (funct `010010`). JR/MULT force `RegWrite=0` since neither writes a general-purpose register. |
| `datapath.v` | Write-register mux and write-back-data mux widened from 2-way to 4-way (`mux4`, previously unused in the starter) so JAL can force the destination to `$ra` and the write-back value to `PC+4`. A new mux chains onto the existing jump mux so JR can force the next PC to the register file's `Read data 1` output. A 64-bit signed multiplier plus new `HI`/`LO` registers (`hilo.v`) feed one more write-back mux for MFHI/MFLO. |
| `hilo.v` | **New file.** Clocked HI/LO register pair, written on `MultOp`. |
| `MIPS_SCP.v` | Wires the new control signals between `control.v` and `datapath.v`. |
| `MIPS_SCP_tb.v` | Added `$finish` (the original testbench never terminated), a VCD dump, and `$display` statements to check results. |

Three pre-existing bugs in the given starter were also fixed along the way
(needed just to get *any* simulation running, unrelated to the new instructions):

- `control.v`: `PCSrc = Branch & (Zero ^ B)` referenced an undefined signal `B` → fixed to `BNE`.
- `rom.v`: read `"memory.txt"`, a file that doesn't exist → fixed to `"memfile.txt"`.
- `flopr_param.v` / `regfile32.v`: PC and the register file had no defined value at time 0 (all-X) → added `initial` blocks so they reset to 0 cleanly.

One real Verilog gotcha worth knowing about if you extend this further:
writing the same variable (`temp`) via non-blocking assignment from two
*nested* `case` scopes in one combinational `always @(*)` block causes a
genuine simulator livelock (confirmed in Icarus Verilog — the simulation
never advances past time 0). Fix: only ever assign each signal once per
execution path, and put any instruction-specific overrides (like JR/MULT's
`RegWrite=0`) **after** the block's `temp` decode, reading only stable input
ports — see `control.v` lines ~153–158.

## The assembler

`Assembler/Assembler/` is a third-party MIPS assembler, originally from
[RoySRC/UpgradedMIPS32Assembler](https://github.com/RoySRC/UpgradedMIPS32Assembler),
vendored here (its own `.git` history was dropped when folding it into this
repo). It already supported `jal`, `jr`, `mult`, `mfhi`, `mflo` — its
encodings were used to double-check the Verilog control-signal decode logic.

The prebuilt binary that shipped with it was an **ARM64 Linux ELF** and
cannot run on Windows — that's very likely what your professor meant by
"use WSL". It was rebuilt natively for Windows instead (see below); no WSL
needed.

## Building and running

### 1. Build the assembler

Requires a C++17 compiler.

**Windows** — [MSYS2](https://www.msys2.org/) (`pacman -S
mingw-w64-ucrt-x86_64-gcc`) works well and is **not** WSL — it's a normal
native Windows toolchain.

```bash
cd Assembler/Assembler
g++ -O2 -std=gnu++17 -o MipsAssembler.exe finalassembler.cpp
```

**macOS** — the system `g++`/`clang++` (from Xcode Command Line Tools,
`xcode-select --install` if you don't have them yet) is actually Apple
Clang, which doesn't ship the GNU-only `bits/stdc++.h` header this file
includes, so it fails with `fatal error: 'bits/stdc++.h' file not found`.
Install a real GCC via Homebrew instead:

```bash
brew install gcc
```

Then build with the versioned binary Homebrew installs (e.g. `g++-16` —
check `ls /opt/homebrew/bin/g++-*` for the exact version) instead of plain
`g++`. No `.exe` extension needed for the output.

```bash
cd Assembler/Assembler
g++-16 -O2 -std=gnu++17 -o MipsAssembler finalassembler.cpp
```

(`MipsAssembler.exe` is a Windows binary and won't run on macOS — build a
Mac binary with the command above instead. Use `./MipsAssembler` in place
of `./MipsAssembler.exe` in step 2 below.)

### 2. Assemble a program

```bash
./MipsAssembler.exe input.s/jal_jr_test.s output/jal_jr_test.out logs/jal_jr_test.log
```

This produces `output/jal_jr_test.out` (machine code with addresses) and
`.no_address.text.bin` / `.no_address.data.bin` (machine code without
addresses, split by segment).

### 3. Load it into the simulator's instruction memory

`rom.v` reads `memfile.txt` (one 32-bit hex word per line) via `$readmemh`.
`to_memfile.sh` converts the assembler's `.out` format into that:

```bash
./to_memfile.sh output/jal_jr_test.out > ../../MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt
```

### 4. Simulate

[Icarus Verilog](https://bleyer.org/icarus/) is a free Verilog simulator —
a drop-in stand-in for ModelSim for local testing, on both Windows and
macOS. The same `.v` files work unchanged in ModelSim once it's available.

**Windows** — install via the [official installer](https://bleyer.org/icarus/)
or `winget install Icarus.Verilog`.

**macOS** — install via Homebrew:

```bash
brew install icarus-verilog gtkwave
```

Then, on either platform, from `MIPSVerilogWOJALv1/MIPSVerilogWOJALv1`:

```bash
iverilog -g2012 -o sim.vvp MIPS_SCP.v MIPS_SCP_tb.v
vvp sim.vvp
```

`vvp` prints final register/HI/LO values and produces `MIPS_SCP_tb.vcd`,
viewable in GTKWave (bundled with the Icarus Verilog Windows installer, or
installed separately via Homebrew above) or in ModelSim later.

### 5. Simulate in ModelSim

No changes to the `.v` files are needed — ModelSim reads the same source
that Icarus Verilog does. From the `MIPSVerilogWOJALv1/MIPSVerilogWOJALv1`
directory (`rom.v`/`ram.v` load `memfile.txt`/`datafile.txt` with a
relative path, so the working directory matters):

```
vsim -do sim.do
```

`sim.do` compiles both files (`MIPS_SCP_tb.v` doesn't `include` the top
module itself, so it and `MIPS_SCP.v` are named explicitly — everything
else is pulled in through the `include` chain), opens a wave window with
PC, the control signals, HI/LO, and the ALU result already added, and runs
to completion. Or do it by hand in the GUI: **Compile > Compile...** both
files, **Simulate > Start Simulation... > work > MIPS_SCP_tb**, then
**Simulate > Run > Run -All**.

The Transcript pane prints the same final register/HI/LO values `vvp`
does. `memfile.txt` currently holds the baseline program; swap in
`jal_jr_test.s` or `mult_test.s` first (step 3 above) to see those.

## Test programs and expected results

| Program | Exercises | Expected result |
|---|---|---|
| `input.s/jal_jr_test.s` | JAL, JR, SLL, SRL, ADD, ADDI, J | `a0=5, v0=105 (a0+100), ra=12, t1=105 (== v0, proves JR returned correctly), t2=20 (5<<2), t3=10 (20>>1), t7=1 (reached the end)` |
| `input.s/mult_test.s` | MULT, MFHI, MFLO | `-5 * 5 = -25` → `HI=0xFFFFFFFF, LO=0xFFFFFFE7`, and `mflo`/`mfhi` correctly copy those into `$t2`/`$t3` |

`memfile.txt` currently ships with the **original baseline program** (the
one the starter repo came with) so the ROM matches the unmodified starter
by default; use step 3 above to load either test program instead.

## Note on the written assignment

The PDF assignment (page 3) also asks for a filled-in control-signal truth
table and an annotated datapath diagram for JAL/JR/SLL/SRL — that's a
separate written deliverable, not part of this repo.
