# Source traceability ledger

This file is an editorial working aid for the manual. It records where claims are grounded in the product repository; it is not a user-facing bibliography and does not replace implementation or hardware testing.

**Product source of truth:** `sandmanbuzz/breadbin`, branch `main`.  
**Product revision consulted for the latest Files and Directories pass:** `bb0844354bca8ab0401c0faf40918bc3115bfcc2` (2026-11-23, `test: keep p-code compile refusals active without py65`). Earlier chapter entries may refer to the prior revision; refresh them before publication.  
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
| Background jobs and process scheduling | `src/bin/sh.s`, `src/kernel/proc.s`, `src/kernel/k.inc` | Implementation. `MAXPROC=8`, `SLICE=3`; timer IRQ and scheduler are in `proc.s`. The eight slots are shared by all processes, not reserved for background jobs. |
| RUN/STOP signals the foreground process; `kill` signals by PID | `src/kernel/proc.s`, `src/bin/sh.s`, `src/bin/kill.s`, `tests/test_system.py` | Implementation and test coverage; RUN/STOP path is handled in the IRQ code. |
| c64fs has inodes, directories, block bitmap, format version 2 | `src/kernel/fs.s`, `src/kernel/k.inc`, `docs/filesystem.md` | Implementation. The on-disk magic is `C64F2`; version constant is 2. |
| Boot disk is hybrid: CBM DOS boot directory plus c64fs sectors | `README.md`, `tools/mkimage.py`, `src/kernel/fs.s`, `src/kernel/blk.s` | Product description and image/driver implementation. |
| Paths abstract over mounted storage, while volume capabilities remain distinct | `src/kernel/fs.s`, `src/kernel/file.s`, `src/kernel/blk.s`, `src/mod/cbm.s`, `src/mod/d81.s`, `src/mod/uci.s` | Implementation. Mount points attach devices to the path namespace; CBM DOS remains a flat directory and is not executable storage. |
| Ordinary CBM DOS disks, c64fs on 1581 media, and Ultimate storage use distinct backends/modules | `src/kernel/fs.s`, `src/kernel/file.s`, `src/mod/cbm.s`, `src/mod/d81.s`, `src/mod/uci.s`, `docs/design/next/uci-v1.md` | Important boundary: `d81.km` adds 1581 geometry for c64fs volumes; its source explicitly says CBM DOS disks on a 1581 are not handled. Hardware claims require trial records. |
| CX loader allocates, relocates, and starts programs | `src/kernel/exec.s`, `tools/cx.py`, `include/breadbin.inc` | Implementation. |
| On-machine editor, BASIC, assembler; host-side C-subset compiler and p-code VM | `src/bin/edit.s`, `src/bin/basic.s`, `src/bin/as.s`, `tools/cc.py`, `src/pvm/`, `docs/design/pvm.md` | Implementation; compiler host/on-target distinction matters. |
| Breadbox replaces the Commodore KERNAL at run time | `src/kernel/main.s`, `src/kernel/proc.s`, `src/kernel/kbd.s`, `src/kernel/con.s`, `src/kernel/iec.s`, `README.md` | Implementation. Verify exact boot/vector path before expanding this explanation. |
| Kernel is non-preemptible; user programs are preempted | `src/kernel/proc.s`, `src/kernel/main.s`, `src/kernel/k.inc` | Implementation. `proc.s` documents the non-preemptible kernel model; IEC I/O is a critical section. |
| Stock C64, REU, and Ultimate are capability tiers | `README.md`, `docs/roadmap.md`, `docs/hardware-notes.md`, `docs/design/io-trial-protocol.md` | Product intent plus configuration-specific observations. Do not generalize hardware results beyond recorded setups. |
| Project lineage and retained names | `README.md`, `LICENSE`, `include/breadbin.inc`, build rules in `Makefile` | Product description and current naming. |


## Chapter: Your First Session

| Manual claim / exercise | Product-repository evidence | Basis / qualification |
|---|---|---|
| `help` displays the installed command summary | `src/bin/help.s`, `rootfs/etc/help` | Implementation and shipped rootfs content. |
| `pwd`, `ls /`, `cat /etc/motd`, `ls /bin` | `src/bin/pwd.s`, `src/bin/ls.s`, `src/bin/cat.s`, `rootfs/etc/motd`, build rule in `Makefile` | Commands and paths verified against current source and rootfs. |
| Supplied readme and three-stage pipeline | `rootfs/home/readme`, `src/bin/sh.s`, `src/kernel/file.s`, `tests/test_system.py::Boot.test_05_pipe_three_stages` | The exact example is present in the shipped readme and exercised by a VICE system test. |
| `cd` changes the shell's working directory | `src/bin/sh.s`, `src/kernel/proc.s`, `tests/test_system.py::Boot.test_07_directories` | `cd` is a shell built-in; cwd is per process. |
| `>` replaces and `>>` appends | `src/bin/sh.s`, `src/kernel/file.s`, `tests/test_system.py::Boot.test_06_redirect_roundtrip` | Shell opens with create/truncate or create/append; exact round-trip is tested. |
| `count` prints once per second; background execution | `src/bin/count.s`, `src/bin/sh.s`, `src/kernel/proc.s` | Implementation. `count` sleeps 60 ticks between lines. |
| The installed help text is a system-image inventory | `rootfs/etc/help`, `src/bin/help.s` | Shipped rootfs content and command implementation. |
| `mount`, `df`, and `ps` provide storage/process inventory | `src/bin/mount.s`, `src/bin/df.s`, `src/bin/ps.s`, kernel mount/process info syscalls | Implementation. Output is live system state and should not be quoted as fixed output. |
| `jobs`, `ps`, and `kill PID` | `src/bin/sh.s`, `src/bin/ps.s`, `src/bin/kill.s`, `src/kernel/proc.s`, `tests/test_system.py` | Interface and implementation; kill defaults to SIGTERM. |
| RUN/STOP interrupts the foreground job | `src/kernel/proc.s`, `tests/test_system.py::Boot.test_13_ctrl_c_blocked_reader`, related foreground Ctrl-C tests | IRQ path and system-test coverage. |


## Review notes

- Re-check the product revision before publishing a release of the manual. This ledger records the revision used during drafting, not a permanent promise about future source.
- For user procedures, verify exact command syntax and expected output against the current program and a reproducible test.
- For hardware claims, name the C64, drive model/ROM, expansion, Ultimate firmware, and software revision when the source records provide them.
- If a claim cannot be tied to implementation or a test, mark it as uncertain or omit it.

## Chapter: The C64 Keyboard and Screen

| Manual claim | Product-repository evidence | Basis / qualification |
|---|---|---|
| The shifted minus key produces the shell pipeline character | `src/kernel/keytab.inc`, `src/bin/sh.s` | Keyboard decode table maps the shifted minus matrix position; shell source documents and parses pipelines. |
| Control notation means hold CTRL and press the named key | `src/kernel/kbd.s`, `src/kernel/keytab.inc` | CTRL is a keyboard-matrix modifier; the control decode table maps letter positions to control PETSCII values. |
| DEL backspaces in the shell line editor | `src/bin/sh.s` | `readline` handles `K_DEL` by reducing the input-line length and emitting DEL. |
| DEL backspaces in the full-screen editor; CTRL-O saves, CTRL-X quits, CTRL-K deletes a line | `src/bin/edit.s` | Key dispatch compares the decoded control values and key constants; behavior is implemented in the editor. |
| The C64 up-arrow and left-arrow occupy character positions represented as caret and underscore in modern notation | `src/kernel/keytab.inc` | The unshifted decode table labels the positions UP-ARROW and LEFT-ARROW; the printed manual uses modern typographic stand-ins, not literal C64 glyph artwork. |

## Introductory expansion notes

| Manual claim / orientation | Product-repository evidence | Basis / qualification |
|---|---|---|
| Initialization displays the message of the day and starts login or the shell | `src/bin/init.s`, `rootfs/etc/motd`, `rootfs/etc/passwd` | Implementation. The login path is conditional on the passwd file existing. |
| `/etc`, `/home`, and `/tmp` have distinct roles in the supplied image | `rootfs/etc/help`, `rootfs/home/readme`, rootfs image construction, `src/kernel/main.s` | Shipped content and implementation. `/tmp` as REU storage is conditional on REU availability. |
| The first-session inventory commands are available | `rootfs/etc/help`, `src/bin/mount.s`, `src/bin/df.s`, `src/bin/ps.s` | Shipped command summary and implementations. Their output depends on current mounts and running processes. |
| Process slots are a shared system limit, not a background-job quota | `src/kernel/k.inc`, `src/kernel/proc.s`, `src/kernel/exec.s` | Implementation. `MAXPROC=8`; shell, init, and external commands all use the process table. |

## Chapter: The Shell

| Manual claim / tutorial exercise | Product-repository evidence | Basis / qualification |
|---|---|---|
| Command lookup uses `/bin` unless the command name contains a slash | `src/bin/sh.s` (`make_path`) | Implementation. |
| Console line editing supports DEL as backspace at the end of the line, CTRL-D on an empty line, TAB completion, and UP/DOWN history | `src/bin/sh.s` (`readline`, `addch`, `hshow`), `tests/test_system.py::Readline` | Implementation and VICE system tests. DEL decrements the line length and emits the C64 DEL control; there is no cursor movement or forward-delete operation. History is a four-entry in-memory ring per shell. |
| TAB completion completes command names in `/bin`, file names elsewhere, common prefixes, and lists ambiguous matches | `src/bin/sh.s` (`complete`, `glob`), `tests/test_system.py::Readline` | Implementation and system tests for command completion, post-pipe completion, directory slash, ambiguous matches, no-match behavior, and existing patterns. |
| Single and double quotes group text; shell operators inside quotes are literal | `src/bin/sh.s` (`tokenize`), `tests/test_system.py::Boot.test_18_basic_pipe` | Implementation. Both quote characters use the same grouping logic; there is no backslash escape processing. |
| `#` begins a comment at the start of a new token | `src/bin/sh.s` (`tokenize`) | Implementation. A hash within an already-started word is ordinary text. |
| `*` and `?` expand against directory entries; unmatched patterns remain literal; dot names require a leading-dot pattern | `src/bin/sh.s` (`is_glob`, `glob`, `match`), `tests/test_system.py::Boot.test_23_wildcards_and_jobs` | Implementation and VICE tests for wildcard expansion and unmatched patterns. |
| Built-ins are `cd`, `jobs`, `kill`, and `exit`; scripts run with `sh file` | `src/bin/sh.s` (`builtin`, startup argument handling) | Implementation. Built-ins execute in the shell process and are not ordinary pipeline stages. |
| `<`, `>`, and `>>` connect standard input/output to files | `src/bin/sh.s` (`run_cmd`), `src/kernel/file.s`, `tests/test_system.py::Boot.test_06_redirect_roundtrip` | Implementation and system test for replace/append output redirection. Input redirection is implemented in the same parser/execution path. |
| `|` creates pipelines; pipe readers/writers block and broken readers signal writers | `src/bin/sh.s`, `src/kernel/file.s`, `src/kernel/proc.s`, `tests/test_system.py::Boot.test_05_pipe_three_stages`, `Boot.test_11_head_pipe_early_exit`, `Boot.test_12_sigpipe` | Implementation and VICE system tests. |
| `;`, `&&`, and `||` sequence or conditionally execute commands; `$?` expands the previous status | `src/bin/sh.s` (`run_line`, `T_DOLLAR`), `tests/test_system.py::ShellOperators` | Implementation and VICE tests for both conditional operators, chained conditions, and success/failure status expansion. |
| Trailing `&` starts a background command; `jobs` lists shell children and `ps` lists system processes | `src/bin/sh.s`, `src/bin/ps.s`, `src/kernel/proc.s`, `tests/test_system.py::Boot.test_08_background_and_kill`, `Boot.test_21_many_sleepers_stay_responsive` | Implementation and system tests. |
| Shell limits are 127 input characters, 32 tokens, and 16 argument-vector entries | `src/bin/sh.s` (`LINEMAX`, `MAXTOK`, `MAXARG`) | Current implementation constants; not a general system-wide limit. |
| There is no variable expansion beyond `$?`, command substitution, arithmetic expansion, or backslash escaping | `src/bin/sh.s` tokenizer and expansion logic | Negative capability claim derived from the complete current shell parser; re-check when the grammar changes. |

## Chapter: Files and Directories

| Manual claim / exercise | Product-repository evidence | Basis / qualification |
|---|---|---|
| The supplied root tree includes `/bin`, `/etc`, `/home`, `/lib`, `/mnt`, and `/tmp` | `rootfs/` tree, `tools/mkimage.py` | Shipped image contents. Optional runtime mounts, especially REU-backed `/tmp`, are distinct from the rootfs directory entry. |
| `pwd` reports the working directory; `ls` lists current or named directories and files | `src/bin/pwd.s`, `src/bin/ls.s`, `src/kernel/proc.s`, `src/kernel/file.s` | Implementation. `ls -l` obtains type/size via stat; `-a` includes dot-prefixed entries. |
| Absolute paths start at root; relative paths use per-process cwd; `.` and `..` are resolved by path lookup | `src/kernel/fs.s` (namei/path lookup), `src/kernel/proc.s` (cwd per process), `src/bin/sh.s` (`cd`), `tests/test_system.py::Boot.test_07_directories`, `Boot.test_16_paths` | Implementation and VICE tests. Mounted-filesystem root traversal is described in `docs/filesystem.md`. |
| Path and name limits: 48-byte cwd buffer; 14-character c64fs names | `src/kernel/k.inc` (`CWDLEN=48`, `NAME_MAX=14`), `src/kernel/fs.s`, `docs/filesystem.md` | Implementation constants and product filesystem documentation. The 48-byte value is the cwd/path buffer limit; do not imply every input buffer is independently 48 bytes without checking its caller. |
| Breadbox paths are case-sensitive | `docs/filesystem.md`, `src/kernel/fs.s` directory lookup | Product filesystem documentation and implementation. |
| `cd` is a shell built-in; a process has its own cwd and children inherit it | `src/bin/sh.s`, `src/kernel/proc.s` (`p_cwddev`, `p_cwdino`), `tests/test_system.py::Boot.test_07_directories` | Implementation and system test. |
| `mkdir` creates directories; `rmdir` only removes empty directories; `rm` unlinks files | `src/bin/mkdir.s`, `src/bin/rmdir.s`, `src/bin/rm.s`, `src/kernel/file.s` (`sys_mkdir`, `sys_rmdir`, `sys_unlink`), `tests/test_system.py::Boot.test_07_directories` | Implementation and VICE test including non-empty-directory refusal. |
| `cp` copies file contents; `mv` renames/moves a file or directory | `src/bin/cp.s`, `src/bin/mv.s`, `src/kernel/file.s` (`sys_rename`), `tests/test_system.py::Boot.test_10_mv_cp` | Implementation and system test. Destination-directory behavior is implemented by command-side target handling. |
| `cat` reads files to standard output; shell redirection can create/truncate or append | `src/bin/cat.s`, `src/bin/echo.s`, `src/bin/sh.s`, `tests/test_system.py::Boot.test_06_redirect_roundtrip` | Implementation and VICE test. |
| `stat` reports type, size, inode, links, and device; `df` reports filesystem capacity and inode counts | `src/bin/stat.s`, `src/bin/df.s`, `src/kernel/file.s` (`sys_stat`, `sys_fsinfo`), `docs/filesystem.md` | Implementation and product filesystem documentation. |
| c64fs has real directories; CBM DOS is a flat directory without mkdir or executable loading | `docs/filesystem.md`, `src/mod/cbm.s`, `src/kernel/fs.s`, `src/kernel/file.s` | Product documentation and backend implementation. Full disk/mount procedures belong to the storage chapter. |
| c64fs stores no useful timestamps; file data is allocated in 256-byte blocks | `docs/filesystem.md`, `src/kernel/fs.s`, `src/kernel/blk.s` | Product filesystem documentation and implementation. |
