## Run analysis, write model results

## Before: stocks.RData, tonnes.csv (data)
## After:  summary.csv (model)

library(TAF)
source("boot/software/A50.R")
source("boot/software/Abar.R")
source("utilities.R")

mkdir("model")

load("data/stocks.RData")
tonnes <- read.taf("data/tonnes.csv")

## 1  Prepare summary table
summary <- data.frame(id=names(tonnes)[-1])
summary$Stock <- c("Eastern Baltic", "Faroe Plateau", "Georges Bank",
                   "Greenland inshore", "Gulf of Maine", "Iceland", "Irish Sea",
                   "Kattegat", "NAFO 2J3KL", "NAFO 3M", "NAFO 3NO", "NAFO 3Ps",
                   "Northeast Arctic", "North Sea", "Norway coastal",
                   "Southern Celtic", "Western Baltic")
summary$Years <- sapply(summary$id, years)
summary$Catch <- sapply(summary$id, catch)
summary$AbarCatch <- sapply(summary$id, abar_catch)
summary$A50mat <- sapply(summary$id, a50mat)
summary$W5 <- sapply(summary$id, w5)

## 2  Write table
write.taf(summary, dir="model")
