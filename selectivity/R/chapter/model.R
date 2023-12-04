## Run analysis, write model results

## Before: stocks.RData, tonnes.csv (data)
## After:  summary.csv (model)

library(TAF)
source("boot/software/A50.R")
source("boot/software/Abar.R")
source("utilities.R")

mkdir("model")

stocks <- readRDS("data/stocks.rds")
tonnes <- read.taf("data/tonnes.csv")

# Calculate summary table

summary <- data.frame(id=names(tonnes)[-1])
summary$Stock <- c("Eastern Baltic", "Faroe Plateau", "Georges Bank",
                   "Greenland inshore", "Gulf of Maine", "Iceland", "Irish Sea",
                   "Kattegat", "Northern", "Flemish Cap", "Grand Bank",
                   "St Pierre", "Northeast Arctic", "North Sea",
                   "Norway coastal", "Southern Celtic", "Western Baltic")
summary$Label <- c("E Baltic", "Faroe", "Georges",
                   "Greenland", "Maine", "Iceland", "Irish",
                   "Kattegat", "Northern", "Flemish", "Grand",
                   "Pierre", "NE Arctic", "North Sea",
                   "Norway", "Celtic", "W Baltic")
summary$Years <- sapply(summary$id, years)
summary$Catch <- sapply(summary$id, catch)
summary$AbarCatch <- sapply(stocks, abar_catch)
summary$A50mat <- sapply(stocks, a50mat)
summary$W5 <- sapply(stocks, w5)

# Examine stocks by biological characteristics

by.weight <- data.frame(summary[order(summary$W5),], row.names=NULL)
rnd(by.weight[c("id", "W5")], 2, 1)
# Cod at age 5 are light (<3 kg) in colder waters and the Baltic
# and heavy (>3 kg) in the North Sea and neighboring areas:
#   id            W5
#   e_baltic      0.6
#   nafo_3no      1.2
#   nafo_3ps      1.4
#   greenland     1.6
#   nafo_2j3kl    1.6
#   ne_arctic     1.7
#   nafo_3m       2.2
#   iceland       2.5
#   w_baltic      3.0
#   norway        3.3
#   faroe_plateau 3.3
#   gulf_of_maine 3.6
#   kattegat      3.7
#   georges_bank  3.8
#   north_sea     6.0
#   irish_sea     7.9
#   s_celtic      9.3

by.maturity <- data.frame(summary[order(-summary$A50mat),], row.names=NULL)
rnd(by.maturity[c("id", "A50mat")], 2, 1)
# Cod mature later (> 3 years) in colder waters
# and earlier (<3 years) in warmer waters
#   id            A50mat
#   ne_arctic     7.0
#   iceland       6.4
#   nafo_3no      5.5
#   nafo_2j3kl    5.3
#   norway        5.2
#   nafo_3ps      5.2
#   greenland     4.3
#   nafo_3m       4.0
#   faroe_plateau 2.7
#   gulf_of_maine 2.5
#   north_sea     2.5
#   georges_bank  2.3
#   s_celtic      2.2
#   kattegat      2.1
#   e_baltic      2.0
#   irish_sea     1.7
#   w_baltic      1.7

by.abar <- data.frame(summary[order(-summary$AbarCatch),], row.names=NULL)
rnd(by.abar[c("id", "AbarCatch")], 2, 1)
# Cod are caught older (>4.5 years) in colder waters
# and younger (<4.5 years) in warmer waters
#   id            AbarCatch
#   nafo_3ps      6.9
#   nafo_2j3kl    6.7
#   ne_arctic     6.7
#   iceland       5.9
#   norway        5.4
#   greenland     5.1
#   nafo_3m       4.6
#   nafo_3no      4.6
#   gulf_of_maine 4.2
#   georges_bank  4.0
#   e_baltic      3.9
#   faroe_plateau 3.9
#   w_baltic      2.9
#   s_celtic      2.3
#   north_sea     2.3
#   irish_sea     2.0
#   kattegat      1.6

# Write table
write.taf(summary, dir="model")
