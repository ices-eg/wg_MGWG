## Preprocess data, write TAF data tables

## Before: tonnes.csv (boot/data), stocks.rds (boot/data/stocks)
## After:  stocks.RData, tonnes.csv (data)

library(TAF)

mkdir("data")

# Copy from boot to data
cp("boot/data/stocks/stocks.rds", "data")
cp("boot/data/tonnes.csv", "data")
