## Extract results of interest, write TAF output tables

## Before: summary.csv (model)
## After:  summary.csv (output)

library(TAF)

mkdir("output")

cp("model/summary.csv", "output")
