# Source traceability ledger

This file is an editorial working aid for the manual. It records where claims are grounded in the product repository; it is not a user-facing bibliography and does not replace implementation or hardware testing.

**Product source of truth:** the owner's local `sandmanbuzz/breadbin` `main`; the GitHub `main` branch is a mirror, not authoritative.  
**Product revision consulted for the Programs and Tools pass:** remote mirror `main` at `270ed1e83f6341700d25a8386912790ff212a646` (2026-11-26). The local authoritative branch was not directly inspected in this pass; refresh against it before publication. Earlier chapter entries may refer to prior revisions.  
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



## Chapter: Disks and Storage

| Manual claim | Product-repository evidence | Basis / qualification |
|---|---|---|
| Device roles: boot drive 8, REU RAM disk, drives 9–11; mount table has four entries including /tmp | `src/kernel/blk.s`, `src/kernel/k.inc`, `src/kernel/fs.s`, `src/bin/mount.s`, `docs/filesystem.md` | Implementation and product documentation. Internal device indices differ from user-facing drive numbers. |
| Mount attaches a device at an existing directory; unmount refuses busy volumes | `src/bin/mount.s`, `src/bin/umount.s`, `src/kernel/fs.s`, `src/kernel/file.s`, `docs/filesystem.md` | Command interface and kernel implementation. Busy includes open files and a process cwd on the mounted device. |
| c64fs and CBM DOS are distinct supported volume types | `src/kernel/fs.s`, `src/mod/cbm.s`, `src/kernel/blk.s`, `docs/filesystem.md` | Implementation. c64fs supports directories and executable files; CBM DOS is a flat directory and is not executable storage. |
| Formatting is destructive; only drives 9–11; default c64fs; drive 8 and mounted disks are refused | `src/bin/format.s`, `src/kernel/fs.s`, `docs/filesystem.md` | Command implementation and product documentation. Real-drive duration is documented observation, not a universal timing guarantee. |
| REU /tmp is volatile and boot initializes it; REU can separately cache boot-disk blocks | `src/kernel/blk.s`, `src/kernel/fs.s`, `src/kernel/k.inc`, `docs/filesystem.md` | Implementation. Cache requires at least four REU banks in the configured build; REU root-image boot is a separate configuration and not covered as an ordinary /tmp setup here. |
| eject/reattach allows single-drive disk swapping with a sufficient REU cache | `src/bin/eject.s`, `src/bin/reattach.s`, `src/kernel/blk.s`, `src/kernel/fs.s`, `docs/filesystem.md` | Implementation and product documentation. Reattach checks the CBM label and c64fs build identifier; writes under / wait while the boot disk is ejected. |
| 1581 support is for c64fs volumes, not ordinary CBM DOS disks | `src/mod/d81.s`, `src/mod/cbm.s`, `src/bin/format.s`, `docs/filesystem.md` | Implementation. Module must be loaded before mounting/formatting; unload is refused while a volume uses its geometry. |
| Host-side mkimage workflows build, inspect, upgrade, and create D81 images | `tools/mkimage.py`, `docs/filesystem.md`, `Makefile` | Host-tool implementation and product documentation. Format-1 images can be inspected but current kernel mounts format 2; upgrading without a replacement boot program preserves an incompatible old boot file. |
| c64fs limits: 35,840-byte files, 127 inodes available to files/directories, 683/3200/2048 blocks, 14-character names, 47-character cwd path, 24 system open files, 8 per process | `src/kernel/fs.s`, `src/kernel/k.inc`, `src/kernel/file.s`, `src/kernel/proc.s`, `docs/filesystem.md` | Implementation constants and product documentation. REU block count is capacity/configuration dependent up to 2048. |
| UCI / Ultimate host storage is not presented as a generally available disk workflow in this chapter | `src/mod/uci.s`, `src/bin/mount.s`, `docs/design/next/uci-v1.md` | Deliberate exclusion: source labels UCI v1 throwaway/development-only. Revisit only when its status changes. |

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


## Chapter: Programs and Tools

| Manual claim / reference entry | Product-repository evidence | Basis / qualification |
|---|---|---|
| Most commands are separate executables in `/bin`; shell built-ins are distinct | `src/bin/sh.s`, `src/kernel/exec.s`, `src/bin/*.s`, program build rules in `Makefile` | Implementation. `cd`, `jobs`, `kill`, and `exit` are shell built-ins; the executable `kill` also exists. |
| `help` is a summary file, not a complete inventory; `ls /bin` shows installed executables | `src/bin/help.s`, `rootfs/etc/help`, `src/bin/` directory, `Makefile` | Implementation and shipped image. Current `/etc/help` omits several installed commands, including `cache`, `eject`, `exec`, `mod`, `reattach`, `calc`, `cut`, and `uniq`; do not describe it as exhaustive. |
| File commands and their syntax | `src/bin/pwd.s`, `ls.s`, `cat.s`, `cp.s`, `mv.s`, `rm.s`, `mkdir.s`, `rmdir.s`, `touch.s`, `stat.s` | Implementation. Detailed filesystem semantics are in Files and Directories. `touch` creates missing files and does not update timestamps on existing files. |
| Text-filter synopsis and constraints | `src/bin/echo.s`, `grep.s`, `head.s`, `tail.s`, `more.s`, `wc.s`, `cut.s`, `sort.s`, `uniq.s`, `tee.s`, `hexdump.s` | Implementation. `tail` retains 2 KB; `sort` is bounded to 8 KB / 255 lines; `cut` and `uniq` line buffers are 255 bytes. |
| Diagnostic and time commands | `src/bin/ps.s`, `free.s`, `df.s`, `uptime.s`, `date.s`, `uname.s`, `version.s`, `sleep.s`, `clear.s`, `count.s` | Implementation. Values such as process counts, memory, and free space are live state, not fixed examples. |
| Full-screen editor controls and buffer limit | `src/bin/edit.s`, `tools/test_edit.py`, `tools/test_edit_at_end.py` | Implementation and host-side tests. 12 KB buffer; 24 text rows; status row; CTRL-O/F1 save, CTRL-X/F7 quit, CTRL-K delete line, CTRL-L/CLR redraw. |
| Integer BASIC statements, variables, and program limits | `src/bin/basic.s`, `tools/test_bas.py`, `tools/test_bas_rt.py` | Current implementation and tests. Integer variables are signed 16-bit; program buffer is 8 KB; GOSUB stack has 16 entries and FOR stack 8. Do not imply compatibility with Commodore BASIC 2.0. |
| On-machine assembler syntax and output | `src/bin/as.s`, `src/bin/as_ops.inc`, `tools/test_as.py`, `include/breadbin.inc` | Implementation and tests. Two-pass assembler; symbol table 255 entries, output cap 8 KB, symbol names up to 14 characters; produces relocatable CX executables. |
| Calculator grammar and arithmetic limits | `src/bin/calc.s` | Implementation. Signed 16-bit integer arithmetic; six levels of nesting; error lines go to stderr and any error yields status 1. |
| Account tools and identity | `src/bin/login.s`, `passwd.s`, `whoami.s`, `src/bin/init.s`, `rootfs/etc/passwd` | Implementation and shipped configuration. Login is conditional on account database/configuration. |
| Module manager and optional modules | `src/bin/mod.s`, `src/mod/con80.s`, `src/mod/d81.s`, `src/mod/fast.s`, `src/mod/cbm.s`, `mk/modules.mk`, `tests/test_modules.py`, `tests/test_con80.py`, `tests/test_fast.py` | Implementation and tests. Module loading/unloading is root-only; individual modules have additional dependencies and active-use constraints. |
| 80-column console behavior | `src/mod/con80.s`, `src/mod/con80.inc`, `tests/test_con80.py`, `tests/test_con80_sim.py` | Implementation and test coverage. Optional 80x25 bitmap console; requires 32 pages in the designated pool region; standard 40-column console is restored on unload. Scrolling performance is hardware-dependent. |
| Boot-drive block cache and single-drive eject workflow | `src/bin/cache.s`, `src/bin/eject.s`, `src/bin/reattach.s`, `src/mod/eject.s`, `src/kernel/blk.s` | Implementation. The block cache and REU filesystem at `/tmp` are separate facilities. Media-swap safety caveats are documented in Disks and Storage. |
| UCI v1 is a current user-facing Ultimate storage mount | `src/mod/uci.s`, `src/kernel/uci.s`, `src/bin/mount.s`, `tests/test_uci_sim.py`, `tests/test_ultimate.py`, `docs/hardware-notes.md` | Owner-confirmed product status plus implementation and test evidence. The source header and old design note still say “dev-only” / “nothing built”; those labels are stale and must not override the current product decision. UCI v1 requires the Ultimate Command Interface and is file storage, not networking. |
| Host-side C subset compiler and p-code backend | `tools/cc.py`, `tools/cc_pcode.py`, `tools/pvmlink.py`, `src/pvm/`, `tools/test_cc.py`, `tools/test_cc_pcode.py` | Implementation and tests. Native backend has static locals and no recursion; p-code backend uses frames and supports recursion. Both are restricted C subsets, not standard C compilers. |
| Host-side executable packaging | `tools/cx.py`, `src/prog.cfg`, `Makefile` | Build implementation. Normally invoked by the build rules rather than as a C64 command. |
