library(icesSAG)

s20 <- getListStocks(2020)
s20 <- s20[s20$SpeciesName=="Gadus morhua" & s20$Purpose == "Advice",]

s21 <- getListStocks(2021)
s21 <- s21[s21$SpeciesName=="Gadus morhua" & s21$Purpose == "Advice",]

s22 <- getListStocks(2022)
s22 <- s22[s22$SpeciesName=="Gadus morhua" & s22$Purpose == "Advice",]

s23 <- getListStocks(2023)
s23 <- s23[s23$SpeciesName=="Gadus morhua" & s23$Purpose == "Advice",]

any(duplicated(s20$StockKeyLabel))
any(duplicated(s21$StockKeyLabel))
any(duplicated(s22$StockKeyLabel))
any(duplicated(s23$StockKeyLabel))

options(width=400)
head(s22)

x20 <- sort(unique(s20$StockKeyLabel))
x21 <- sort(unique(s21$StockKeyLabel))
x22 <- sort(unique(s22$StockKeyLabel))
x23 <- sort(unique(s23$StockKeyLabel))
arni::compare(x20, x21)
arni::compare(x21, x22)
arni::compare(x22, x23)

codes <- sort(unique(c(s20$StockKeyLabel, s21$StockKeyLabel, s22$StockKeyLabel, s23$StockKeyLabel)))
present <- data.frame(stock=codes, s20=codes %in% x20, s21=codes %in% x21, s22=codes %in% x22, s23=codes %in% x23)
present[present == "TRUE"] <- "x"
present[present == "FALSE"] <- ""

write.csv(present, quote=FALSE, row.names=FALSE)

################################################################################

print.simple.list(s23[s23$StockKeyLabel == "cod.27.5a",])

################################################################################

sumtab23 <- sapply(s23$AssessmentKey, getSummaryTable)
names(sumtab23) <- s23$StockKeyLabel

sumtab22 <- sapply(s22$AssessmentKey, getSummaryTable)
names(sumtab22) <- s22$StockKeyLabel


names(sumtab23[6])
names(sumtab23[7])
names(sumtab23[8])
names(sumtab23[9])

sumtab23[[6]]$SSB
sumtab23[[7]]$SSB
sumtab23[[8]]$SSB
sumtab23[[9]]$SSB
