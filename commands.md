# Demo commands

Verified end-to-end on this machine. Every block below is self-contained —
full absolute paths, no shell variables to set up first — so you can copy
any single block into any terminal window/tab and it'll just work, even if
you never ran an earlier block in that same window.

## 0. One-time setup (macOS)

```bash
brew install gcc icarus-verilog surfer
```

- `gcc` — Apple's system `g++`/`clang++` lacks the GNU-only `bits/stdc++.h`
  header the assembler includes, so a real GCC is needed. Check which
  versioned binary Homebrew installed: `ls /opt/homebrew/bin/g++-*` (used
  as `g++-16` below — adjust every command if yours differs).
- `icarus-verilog` — the Verilog simulator (`iverilog` + `vvp`).
- `surfer` — waveform viewer. (GTKWave was tried first; Homebrew only
  ships an unmaintained Intel-only build that macOS now refuses to run.
  Surfer is actively maintained and native on Apple Silicon.)

## 1. Build the assembler

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/Assembler/Assembler
g++-16 -O2 -std=gnu++17 -o MipsAssembler finalassembler.cpp
```

Only needed once, or after editing `finalassembler.cpp`.

## 2. JAL / JR test (also exercises SLL, SRL, ADD, ADDI, J)

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/Assembler/Assembler
./MipsAssembler input.s/jal_jr_test.s output/jal_jr_test.out logs/jal_jr_test.log > /dev/null
./to_memfile.sh output/jal_jr_test.out > /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt

cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1
iverilog -g2012 -o sim.vvp MIPS_SCP.v MIPS_SCP_tb.v
vvp sim.vvp
```

Expected result:
```
PC=40  a0=5  v0=105  ra=12  t1=105  t2=20  t3=10  t7=1
```
`a0=5, v0=105 (a0+100), ra=12, t1=105 == v0` proves `jr` returned
correctly; `t2=20` (5<<2), `t3=10` (20>>1), `t7=1` reached the end.

## 3. MULT / MFHI / MFLO test

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/Assembler/Assembler
./MipsAssembler input.s/mult_test.s output/mult_test.out logs/mult_test.log > /dev/null
./to_memfile.sh output/mult_test.out > /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt

cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1
iverilog -g2012 -o sim.vvp MIPS_SCP.v MIPS_SCP_tb.v
vvp sim.vvp
```

Expected result:
```
PC=X  a0=0  v0=0  ra=0  t1=5  t2=4294967271  t3=4294967295  t7=0
t0=4294967291(fffffffb)  t1=5(00000005)  HI=ffffffff  LO=ffffffe7  t2(mflo)=ffffffe7  t3(mfhi)=ffffffff
```
`-5 * 5 = -25` → `HI=0xFFFFFFFF, LO=0xFFFFFFE7`; `mflo`/`mfhi` correctly
copy those into `$t2`/`$t3`.

## 4. Data memory (dmem) test

Neither test above touches data memory (`sw`/`lw`) — this one does, and
dumps the RAM's final contents to a file so you have something concrete
to show. Uses a separate testbench, `MIPS_SCP_dmem_tb.v`, identical to the
normal one but with an added `$writememh` dump at the end.

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/Assembler/Assembler
./MipsAssembler input.s/mem_test.s output/mem_test.out logs/mem_test.log > /dev/null
./to_memfile.sh output/mem_test.out > /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt

cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1
iverilog -g2012 -o sim_dmem.vvp MIPS_SCP.v MIPS_SCP_dmem_tb.v
vvp sim_dmem.vvp
```

Expected result:
```
t0(addr)=8  t1(stored)=99  t2(loaded back)=99  t7=1
Dmem[2] (word at byte address 8) = 99 (00000063)
```
`mem_test.s` does `sw $t1, 0($t0)` (address 8, value 99) then
`lw $t2, 0($t0)` to read it straight back — proving the store actually
reached memory, not just a register. `dmem_dump.txt` is written alongside
`memfile.txt` — a full 128-word dump of the RAM's final contents (one hex
word per line, `//` address markers every 16 words), with exactly one
non-zero word: `00000063` at index 2. That file is the "screenshot" of
data memory — open it directly, or expand `uut` → `dmem` → `Dmem` in
Surfer's Scopes to see the same array live in the waveform viewer.

## 4b. MIN / MAX / SUM test (custom instructions, also writes to dmem)

MIN, MAX and SUM are custom R-type instructions added for this project
(function codes `101100`, `101101`, `101110`). This test computes all three
and stores every result to data memory, so the dump file doubles as the
evidence. Uses its own testbench, `MIPS_SCP_minmax_tb.v`, which runs 20
cycles instead of 10 because the program is 14 instructions long.

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/Assembler/Assembler
./MipsAssembler input.s/minmaxsum_test.s output/minmaxsum_test.out logs/minmaxsum_test.log > /dev/null
./to_memfile.sh output/minmaxsum_test.out > /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1/memfile.txt

cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1
iverilog -g2012 -o sim_minmax.vvp MIPS_SCP.v MIPS_SCP_minmax_tb.v
vvp sim_minmax.vvp
```

Expected result:
```
--- registers ---
t0=25  t1=7  t2=-12
min(25,7)   -> s0 = 7
max(25,7)   -> s1 = 25
sum(25,7)   -> s2 = 32
min(25,-12) -> s3 = -12
max(-12,7)  -> s4 = 7
reached end -> t7 = 1

--- data memory ---
Dmem[0] @byte 0  = 7 (00000007)
Dmem[1] @byte 4  = 25 (00000019)
Dmem[2] @byte 8  = 32 (00000020)
Dmem[3] @byte 12 = -12 (fffffff4)
Dmem[4] @byte 16 = 7 (00000007)
```

The last two register lines are the important ones. `min(25,-12) = -12` and
`max(-12,7) = 7` only come out that way if the comparison is **signed** — an
unsigned compare would give 25 and -12 instead, because -12 as an unsigned
32-bit value is huge.

`minmax_dmem_dump.txt` is written alongside `memfile.txt`. It's a full
128-word dump of data memory with exactly five non-zero words at the top,
which is the screenshot-friendly artifact for this test:

```
// 0x00000000
00000007      <- min(25,7)  = 7
00000019      <- max(25,7)  = 25
00000020      <- sum(25,7)  = 32
fffffff4      <- min(25,-12) = -12, two's complement
00000007      <- max(-12,7) = 7
00000000
...
```

## 5. (Optional) View the waveform

```bash
cd /Users/mustakimahmedhasan/Studies/NSU/262/CSE332/project/MIPSVerilogWOJALv1/MIPSVerilogWOJALv1
surfer MIPS_SCP_tb.vcd
```

(For the dmem test's own waveform instead, use `MIPS_SCP_dmem_tb.vcd` —
step 4 dumps to that filename, not `MIPS_SCP_tb.vcd`.)

Drag `PC`, `JAL`, `JR`, `MultOp`, `HI`, `LO` into the waveform pane to
watch them change cycle-by-cycle.

## Notes

- Steps 2 and 3 each overwrite `memfile.txt` — only one test program is
  loaded at a time. Re-run the other step to switch.
- The `> /dev/null` on the assembler command just silences its verbose
  debug trace; harmless either way.
- `$readmemh`/`$readmemb` version warnings and "not enough words in the
  file" on `vvp` are expected — the ROM is sized larger than the test
  programs need.
- `git status` will show `memfile.txt`, `sim.vvp`, and `MIPS_SCP_tb.vcd`
  as modified after running this — expected simulation output, not
  something to commit.
- If a block ever fails with `cd: no such file or directory`, you're
  likely in a leftover directory from a previous unrelated command and a
  relative path broke — every `cd` here is already absolute, so just
  re-paste the block fresh and it'll work regardless of your current
  directory.
