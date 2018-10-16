# Effects of alternative selectivity patterns

source("functions/applyFmax.R")

## 1  Import

setwd("stocks")
source("iceland.R")
setwd("..")

## Current
applyFmax(Ninit, M, S, mat, wcatch)

## Shifted
stdplot(S, "Shifting the selectivity", "Selectivity", type="o")
grid()
lines(seq(3.5,14.5), S, lty=3)
