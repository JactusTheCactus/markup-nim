.PHONY : all reset
.ONESHELL : $(BIN)
.SILENT :
SHELL := bash
MD := $(wildcard *.md)
HTML := $(patsubst %.md,htmldocs/%.html,$(MD))
NIM := $(wildcard nim/*.nim)
BIN := $(patsubst nim/%.nim,bin/%,$(NIM))
all : $(HTML) $(BIN)
	find . -empty -delete
reset :
	rm -rf htmldocs $(BIN)
	$(MAKE) all
bin htmldocs :
	mkdir $@
htmldocs/%.html : %.md | htmldocs
	$(nim) md2html $<
bin/% : nim/%.nim | bin
	$(nim) compile -o:$@ -d:nimDebugDlOpen $<
