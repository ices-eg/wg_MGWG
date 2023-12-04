## Preprocess data, write TAF data tables

## Before: stock_names.csv, tonnes.csv (boot/data),
##         stocks.rds (boot/data/stocks)
## After:  stock_names.csv, stocks.RData, tonnes.csv (data)

library(TAF)

mkdir("data")

# Copy from boot to data
cp("boot/data/stocks/stocks.rds", "data")
cp("boot/data/tonnes.csv", "data")

# Convert txt -> csv
stock.names <- read.fwf("boot/data/stock_names.txt", c(17, 11, 100),
                        col.names=c("Code", "Label", "Name"))
stock.names <- data.frame(lapply(stock.names, trimws))
write.taf(stock.names, dir="data", quote=TRUE)
