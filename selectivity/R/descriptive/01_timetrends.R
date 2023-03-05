## 1  Import stocks

library(TAF)  # taf2xtab

## source("stocks.R")
source("../functions/dims.R")
source("../functions/read.R")

path <- "../../data/faroe_plateau"
dims(path)
ages <- as.character(2:10)
plus <- TRUE

N.fp <- taf2xtab(read("natage", path, plus))[ages]
W.fp <- taf2xtab(read("wstock", path, plus))[ages]
m.fp <- taf2xtab(read("maturity", path, plus))[ages]
S.fp <- N.fp * W.fp * m.fp
