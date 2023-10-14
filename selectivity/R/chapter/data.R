## Preprocess data, write TAF data tables

## Before: stocks.RData (boot/data/stocks)
## After:  stocks.RData (data)

library(TAF)

mkdir("data")

cp("boot/data/stocks/stocks.RData", "data")
