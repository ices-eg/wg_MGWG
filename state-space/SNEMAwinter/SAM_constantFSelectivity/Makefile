.PHONY: all clean

datafiles := $(wildcard ../data/*)

all: Mohn.txt

Mohn.txt: $(datafiles) run.R ../SAM/model.cfg ../../helper_code/sampred.R 
	echo 'source("run.R")' | R --slave 

clean: 
	rm -f *.pdf *.txt *.csv
