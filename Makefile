# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: thesis.pdf all clean show

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: thesis.pdf book.pdf

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interactive=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

thesis thesis.pdf: thesis.tex
	latexmk -pdf   \
	-jobname=thesis        \
	-pdflatex="pdflatex --file-line-error --shell-escape --synctex=1 %O '\input{%S}'" thesis.tex

force: thesis.tex
	latexmk -pdf -g   \
	-jobname=thesis        \
	-pdflatex="pdflatex --file-line-error --shell-escape --synctex=1 %O '\input{%S}'" thesis.tex


book book.pdf: thesis.tex
	latexmk -pdf       \
	-jobname=book   \
	-pdflatex="pdflatex --file-line-error --shell-escape --synctex=1 %O '\def\hardcopy{}\input{%S}'" thesis.tex


thesis.acr: thesis.aux
	makeglossaries thesis

clean:
	latexmk -C
	rm -f thesis.aux thesis.bbl thesis.bcf thesis.blg thesis.fls thesis.lof thesis.log thesis.lot thesis.out thesis.pdf thesis.run.xml thesis.synctex.gz thesis.toc
	rm -f book.aux book.bbl book.bcf book.blg book.fls book.lof book.log book.lot book.out book.pdf book.run.xml book.synctex.gz book.toc book.fdb_latexmk

show: thesis.pdf
	zathura thesis.pdf &
