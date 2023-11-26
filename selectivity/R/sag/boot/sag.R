library(TAF)
library(icesSAG)

# Download stocks
stocks.2020 <- getListStocks(2020)
stocks.2020 <- stocks.2020[stocks.2020$SpeciesName=="Gadus morhua" &
                           stocks.2020$Purpose == "Advice",]
stocks.2021 <- getListStocks(2021)
stocks.2021 <- stocks.2021[stocks.2021$SpeciesName=="Gadus morhua" &
                           stocks.2021$Purpose == "Advice",]
stocks.2022 <- getListStocks(2022)
stocks.2022 <- stocks.2022[stocks.2022$SpeciesName=="Gadus morhua" &
                           stocks.2022$Purpose == "Advice",]
stocks.2023 <- getListStocks(2023)
stocks.2023 <- stocks.2023[stocks.2023$SpeciesName=="Gadus morhua" &
                           stocks.2023$Purpose == "Advice",]

# Download summary tables
sumtab.2020 <- sapply(stocks.2020$AssessmentKey, getSummaryTable)
names(sumtab.2020) <- stocks.2020$StockKeyLabel
sumtab.2021 <- sapply(stocks.2021$AssessmentKey, getSummaryTable)
names(sumtab.2021) <- stocks.2021$StockKeyLabel
sumtab.2022 <- sapply(stocks.2022$AssessmentKey, getSummaryTable)
names(sumtab.2022) <- stocks.2022$StockKeyLabel
sumtab.2023 <- sapply(stocks.2023$AssessmentKey, getSummaryTable)
names(sumtab.2023) <- stocks.2023$StockKeyLabel

# Write tables
write.taf(stocks.2020, quote=TRUE)
write.taf(stocks.2021, quote=TRUE)
write.taf(stocks.2022, quote=TRUE)
write.taf(stocks.2023, quote=TRUE)
