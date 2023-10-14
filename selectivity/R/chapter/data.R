## Preprocess data, write TAF data tables

## Before: tonnes.csv (boot/data), stocks.RData (boot/data/stocks)
## After:  stocks.RData, tonnes.csv (data)

library(TAF)

mkdir("data")

cp("boot/data/stocks/stocks.RData", "data")
cp("boot/data/tonnes.csv", "data")
