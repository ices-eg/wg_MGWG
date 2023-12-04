## Preprocess data, write TAF data tables

## Before: stock_names.csv, tonnes.csv (boot/data),
##         stocks.rds (boot/data/stocks)
## After:  stock_names.csv, stocks.RData, tonnes.csv (data)

library(TAF)

mkdir("data")

# Copy from boot to data
cp("boot/data/stocks/stocks.rds", "data")
cp("boot/data/tonnes.csv", "data")

# Simplify column names
stock.names <- read.taf("boot/data/stock_names.csv")
names(stock.names) <- c("Code", "Label", "Name")
write.taf(stock.names, dir="data", quote=TRUE)
