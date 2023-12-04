## Prepare table

## Before: summary.csv (output)
## After:  summary.csv (report)

library(TAF)

# Read output table
summary <- read.taf("output/summary.csv")

# Format columns
summary$id <- summary$Label <- NULL
summary$Catch <- round(summary$Catch, -2)
summary <- rnd(summary, 4:6, 1)
names(summary)[names(summary) == "Years"] <- "Decade"
names(summary)[names(summary) == "AbarCatch"] <- "Abar"

# Sort rows
z <- c("Greenland inshore",
       "Northeast Arctic",
       "Iceland",
       "Faroe Plateau",
       "Norway coastal",
       "North Sea",
       "Kattegat",
       "Western Baltic",
       "Eastern Baltic",
       "Irish Sea",
       "Southern Celtic",
       "Northern",
       "Flemish Cap",
       "Grand Bank",
       "St Pierre",
       "Gulf of Maine",
       "Georges Bank")
rownames(summary) <- summary$Stock
summary <- summary[z,]

# Write report table
write.taf(summary, dir="report")
