## Preprocess data, identity when stocks were assessed

## Before: stocks_2020.csv, stocks_2021.csv, stocks_2022.csv,
##         stocks_2023.csv (boot/data/sag)
## After:  assessments.csv, assessments_all.csv (data)

library(TAF)

mkdir("data")

# Read SAG data
stocks.2020 <- read.taf("boot/data/sag/stocks_2020.csv")
stocks.2021 <- read.taf("boot/data/sag/stocks_2021.csv")
stocks.2022 <- read.taf("boot/data/sag/stocks_2022.csv")
stocks.2023 <- read.taf("boot/data/sag/stocks_2023.csv")

# Identify when stocks were assessed
codes <- sort(unique(c(stocks.2020$StockKeyLabel, stocks.2021$StockKeyLabel,
                       stocks.2022$StockKeyLabel, stocks.2023$StockKeyLabel)))
assessments.all <- data.frame(stock=codes,
                              "2020"=codes %in% stocks.2020$StockKeyLabel,
                              "2021"=codes %in% stocks.2021$StockKeyLabel,
                              "2022"=codes %in% stocks.2022$StockKeyLabel,
                              "2023"=codes %in% stocks.2023$StockKeyLabel,
                              check.names=FALSE)
assessments.all[assessments.all == "TRUE"] <- "x"
assessments.all[assessments.all == "FALSE"] <- ""

# Remove selected stocks
assessments <- assessments.all
assessments <- assessments[assessments$stock != "cod.21.1.osc",] # WGrn offshore
assessments <- assessments[assessments$stock != "cod.21.1a-e",]  # WGrn offshore
assessments <- assessments[assessments$stock != "cod.2127.1f14",]  # E Greenland
assessments <- assessments[assessments$stock != "cod.27.1-2.coastN",]  # NCoastN
assessments <- assessments[assessments$stock != "cod.27.2.coastS",]    # NCoastS
assessments <- assessments[assessments$stock != "cod.27.46a7d20",]  # NSea split
assessments <- assessments[assessments$stock != "cod.27.5b2",]  # Faroe Bank
assessments <- assessments[assessments$stock != "cod.27.6a",]   # W Scotland
assessments <- assessments[assessments$stock != "cod.27.6b",]   # Rockall

# Label remaining stocks
assessments$label <- c("Greenland", "NE Arctic", "Norway", "Kattegat",
                       "W Baltic", "E Baltic", "North Sea", "Iceland", "Faroe",
                       "Irish", "S Celtic")
assessments <- assessments[c("stock", "label", "2020", "2021", "2022", "2023")]

# Write TAF tables
write.taf(assessments.all, dir="data")
write.taf(assessments, dir="data")
