LATEXMK ?= latexmk
MAIN := book.tex
OUT := build
PDF := $(OUT)/book.pdf

.PHONY: all pdf clean distclean view help
all: pdf

pdf: $(PDF)

$(PDF): $(MAIN) $(shell find chapters frontmatter backmatter tex -type f 2>/dev/null)
	mkdir -p $(OUT)
	$(LATEXMK) -lualatex -interaction=nonstopmode -halt-on-error -file-line-error -outdir=$(OUT) $(MAIN)

view: pdf
	$(if $(shell command -v xdg-open 2>/dev/null),xdg-open,open) $(PDF)

clean:
	$(LATEXMK) -C -outdir=$(OUT) $(MAIN)
	rm -f $(OUT)/*.run.xml $(OUT)/*.bcf $(OUT)/*.bbl $(OUT)/*.blg $(OUT)/*.glo $(OUT)/*.gls $(OUT)/*.glg $(OUT)/*.ist $(OUT)/*.acn $(OUT)/*.acr $(OUT)/*.alg

distclean: clean
	rm -rf $(OUT)

help:
	@printf '%s\\n' 'make pdf       Build the manual' 'make view      Build and open the PDF' 'make clean     Remove generated auxiliary files' 'make distclean Remove all generated output'
