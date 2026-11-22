# Breadbox documentation

Source for the *Breadbox: The Complete Manual* project.

The book is authored in LaTeX and built with `make`. The initial document architecture is being established; see the build instructions and source layout as they land.

This repository is separate from the Breadbox operating-system source repository. The manual describes released and observed behavior, and marks implementation-dependent details explicitly.

## Building

Requirements:

- A reasonably complete TeX Live or MacTeX installation
- LuaLaTeX
- `latexmk`
- `biber`
- `makeglossaries` (normally included with TeX Live)

Build the PDF:

```sh
make
```

The output is `build/book.pdf`. Use `make clean` to remove auxiliary files or `make distclean` to remove the complete build directory.

## Source layout

- `book.tex` — document structure and reading order
- `tex/` — typography, shared macros, and callout environments
- `frontmatter/` — title and editorial front matter
- `chapters/` — modular narrative chapters
- `backmatter/` — reference appendices, glossary, and bibliography

Chapters are independent source files. Shared terminology and formatting belong in the preamble/macros rather than being redefined locally.

The manuscript uses editorial markers such as `\\todo{...}` for unfinished material and `\\notverified{...}` for claims that need source or hardware confirmation. These are temporary authoring aids, not a substitute for a documented evidence standard.
