
LATEX = pdflatex

LANGS = fr en

TARGETS = $(addprefix resume_, $(addsuffix .pdf, $(LANGS)))

default : all
	$(LATEX) merge.tex

all : $(TARGETS)

.PHONY : clean

clean :
	yes | bzr clean-tree
	@echo

resume_%.pdf : resume_%.tex body_%.tex header.tex
	$(LATEX) $<
