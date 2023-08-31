library(icesSAG)

stocks <- getListStocks(2022)
stocks <- stocks[stocks$SpeciesName=="Gadus morhua",]
