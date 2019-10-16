A4ADIRS := $(shell echo 'cat(list.dirs()[grep("a4asca*", list.dirs())])' | R --slave)

.PHONY: runs

runs:
	@for d in $(A4ADIRS); do cd $$d && rm -f *.Rout *.csv *.pdf *.txt .RData .Rhistory && echo 'source("algorithm.R");q("yes")' | R --slave && cd ../..; done

