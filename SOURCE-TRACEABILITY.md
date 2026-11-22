# Source traceability ledger

This file is an editorial working aid for the manual. It records where claims are grounded in the product repository; it is not a user-facing bibliography and does not replace implementation or hardware testing.

**Product source of truth:** `sandmanbuzz/breadbin`, branch `main`.  
**Product revision consulted for this pass:** `7c8fab495bb1d73672b644ff78213ce9058a3539` (2026-11-21, `size ledger: ee06ae8 (pvm squish)`).  
**Manual branch:** `c/book-foundation`.

## Evidence levels

- **Interface:** behavior intentionally exposed to users/programs.
- **Implementation:** established by the current source; may change with implementation.
- **Observed:** exercised on a named emulator or hardware setup in a test record.
- **Experimental / planned:** not to be described as generally available.

A source file is evidence of implementation, not by itself evidence of correct behavior on every target. Use the product tests and hardware trial records for claims about observed behavior.

## Chapter: Meet Breadbox

| Manual claim | Product-repository evidence | Basis / qualification |
|---|---|---|
| Shell is a program; external commands are separate programs | `src/bin/sh.s`, `src/bin/*.s`, `src/kernel/exec.s` | Implementation. Shell comments document command syntax and built-ins; loader handles CX images. |
| Pipes connect process streams; readers/writers block | `src/kernel/file.s`, `src/kernel/proc.s`, `tests/test_system.py` (pipe tests), `docs/testing.md` | Implementation plus system-test coverage. |
| Background jobs and process scheduling | `src/bin/sh.s`, `src/kernel/proc.s`, `src/kernel/k.inc` | Implementation. `MAXPROC=8`, `SLICE=3`; timer IRQ and scheduler are in `proc.s`. |
| RUN/STOP signals the foreground process; `kill` signals by PID | `src/kernel/proc.s`, `src/bin/sh.s`, `src/bin/kill.s`, `tests/test_system.py` | Implementation and test coverage; RUN/STOP path is handled in the IRQ code. |
| c64fs has inodes, directories, block bitmap, format version 2 | `src/kernel/fs.s`, `src/kernel/k.inc`, `docs/filesystem.md` | Implementation. The on-disk magic is `C64F2`; version constant is 2. |
| Boot disk is hybrid: CBM DOS boot directory plus c64fs sectors | `README.md`, `tools/mkimage.py`, `src/kernel/fs.s`, `src/kernel/blk.s` | Product description and image/driver implementation. |
| CBM DOS, 1581, and Ultimate volumes use distinct backends/modules | `src/kernel/fs.s`, `src/kernel/file.s`, `src/mod/cbm.s`, `src/mod/d81.s`, `src/mod/uci.s`, `docs/design/next/uci-v1.md` | Implementation; capabilities differ by backend. Hardware claims require trial records. |
| CX loader allocates, relocates, and starts programs | `src/kernel/exec.s`, `tools/cx.py`, `include/breadbin.inc` | Implementation. |
| On-machine editor, BASIC, assembler; host-side C-subset compiler and p-code VM | `src/bin/edit.s`, `src/bin/basic.s`, `src/bin/as.s`, `tools/cc.py`, `src/pvm/`, `docs/design/pvm.md` | Implementation; compiler host/on-target distinction matters. |
| Breadbox replaces the Commodore KERNAL at run time | `src/kernel/main.s`, `src/kernel/irq.s` (if present), `src/kernel/kbd.s`, `src/kernel/con.s`, `src/kernel/iec.s`, `README.md` | Implementation. Verify exact boot/vector path before expanding this explanation. |
| Kernel is non-preemptible; user programs are preempted | `src/kernel/proc.s`, `src/kernel/main.s`, `src/kernel/k.inc` | Implementation. `proc.s` documents the non-preemptible kernel model; IEC I/O is a critical section. |
| Stock C64, REU, and Ultimate are capability tiers | `README.md`, `docs/roadmap.md`, `docs/hardware-notes.md`, `docs/design/io-trial-protocol.md` | Product intent plus configuration-specific observations. Do not generalize hardware results beyond recorded setups. |
| Project lineage and retained names | `README.md`, `LICENSE`, `include/breadbin.inc`, build rules in `Makefile` | Product description and current naming. |

## Review notes

- Re-check the product revision before publishing a release of the manual. This ledger records the revision used during drafting, not a permanent promise about future source.
- For user procedures, verify exact command syntax and expected output against the current program and a reproducible test.
- For hardware claims, name the C64, drive model/ROM, expansion, Ultimate firmware, and software revision when the source records provide them.
- If a claim cannot be tied to implementation or a test, mark it as uncertain or omit it.
