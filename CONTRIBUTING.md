# Contributing to the manual

The manual is a technical publication, not a marketing overview. Prefer precise, testable statements and complete explanations over compressed feature lists.

## Editorial evidence levels

When a claim could be mistaken for a guarantee, make its basis clear:

- **Interface contract:** behavior deliberately exposed to programs or users and intended to remain stable.
- **Implementation behavior:** behavior established by reading the current source; cite the relevant subsystem or revision in editorial notes where useful.
- **Observed behavior:** behavior confirmed on a named emulator or hardware configuration.
- **Experimental:** available but not yet treated as stable.
- **Planned:** not implemented; keep it out of instructions except in explicitly marked future-work material.

Do not silently promote an observation into a universal guarantee. Hardware-dependent claims should identify the machine, expansion, drive, firmware, and software revision where relevant.

## Chapter structure

A substantial chapter should normally include:

1. A short statement of purpose and applicability.
2. The concepts needed to understand the task.
3. A worked example or procedure.
4. Expected results and ways to verify them.
5. Failure cases, limits, and recovery guidance.
6. Cross-references to deeper technical material.

Use callouts sparingly and semantically:

- `trythis` for a safe experiment.
- `remember` for a rule worth retaining.
- `caution` for destructive or hardware-risk operations.
- `underhood` for implementation explanation.
- `platformnote` for hardware- or configuration-specific behavior.

## Source conventions

- Keep chapters in separate files under `chapters/`.
- Put reusable commands and notation in `tex/macros.tex`.
- Put shared visual environments in `tex/environments.tex`.
- Use labels with stable prefixes: `ch:`, `sec:`, `fig:`, `tab:`, `app:`.
- Cross-reference with `\\cref{...}`; do not hard-code chapter or section numbers.
- Use `\\cmd{...}`, `\\filepath{...}`, `\\key{...}`, and `lstlisting` consistently.
- Keep code examples runnable and identify whether they run on Breadbox or the host.
- Do not use screenshots as a substitute for text explanations; screenshots should demonstrate something that cannot be conveyed better with a diagram or listing.

## Technical review

Before a chapter is considered complete:

- Verify every command, option, path, and output against the current implementation or a reproducible test.
- Check platform requirements and destructive side effects.
- Distinguish user-facing behavior from internal details.
- Include limits and failure behavior, not just the successful path.
- Build the PDF and inspect the rendered pages, especially tables, listings, and callouts.
