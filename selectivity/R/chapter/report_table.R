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
names(summary)[names(summary) == "AbarCatch"] <- "Abar"

# Write report table
write.taf(summary, dir="report")
