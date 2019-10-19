LATEX := pdflatex -halt-on-error -recorder

LANGS := fr en

TARGETS := $(addprefix resume_, $(addsuffix .pdf, $(LANGS)))

.DEFAULT_GOAL := all

all : $(TARGETS)

.PHONY : clean watch all

clean :
	git clean -fdX

resume_%.pdf : resume_%.tex
	$(LATEX) $<
	< $(basename $@).fls grep --perl-regexp "INPUT \K[^/].*tex" --only-matching | sort | uniq | xargs echo $@: >$(basename $@).d

SHELL := bash
WATCH ?= $(.DEFAULT_GOAL)

watch :
	inotifywait --monitor --event modify `LANG=en_EN make $(WATCH) --always-make --dry-run --silent --debug=v | grep --perl-regexp "Considering target file '\K[^']+" --only-matching | xargs ls` | while read; do make $(WATCH); done

-include $(wildcard *.d)