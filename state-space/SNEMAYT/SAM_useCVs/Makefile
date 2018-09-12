.PHONY: all clean

datafiles := $(wildcard ../data/*)

all: Mohn.txt

Mohn.txt: $(datafiles) run.R model.cfg pred.R 
	echo 'source("run.R")' | R --slave 

clean: 
	rm -f *.pdf *.txt *.csv
