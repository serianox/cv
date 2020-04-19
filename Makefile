.DEFAULT_GOAL := all
SHELL := bash

all : moderncv_fr.pdf ## Build all the targets

.PHONY : clean
clean : ## Clean the folder
	git clean -fdX

%.pdf : %.tex
	pdflatex -halt-on-error -recorder $<
	< $(basename $@).fls grep --perl-regexp "INPUT \K[^/].*tex" --only-matching | sort | uniq | xargs echo $@: >$(basename $@).d

%.tex : %.md
	pandoc --from markdown $< --to latex --output $@

WATCH ?= $(.DEFAULT_GOAL)

.PHONY : watch
watch : ## Watch dependencies and rebuild a file
	inotifywait --monitor --event modify `LANG=en_EN make $(WATCH) --always-make --dry-run --silent --debug=v | grep --perl-regexp "Considering target file '\K[^']+" --only-matching | xargs ls` | while read; do make $(WATCH); done

.PHONY : help
help : ## Show the list of targets
	@grep -E '^[a-zA-Z_-]+.*:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

-include $(wildcard *.d)