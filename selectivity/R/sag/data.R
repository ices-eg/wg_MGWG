## Preprocess data, write TAF data tables

## Before: refpt_2020.rds, refpt_2021.rds, refpt_2022.rds, refpt_2023.rds,
##         stocks_2020.csv, stocks_2021.csv, stocks_2022.csv, stocks_2023.csv,
##         sumtab_2020.rds, sumtab_2021.rds, sumtab_2022.rds, sumtab_2023.rds
##         (boot/data/sag)
## After:

library(TAF)

mkdir("data")

# Read SAG data
stocks.2020 <- read.taf("boot/data/sag/stocks_2020.csv")
stocks.2021 <- read.taf("boot/data/sag/stocks_2021.csv")
stocks.2022 <- read.taf("boot/data/sag/stocks_2022.csv")
stocks.2023 <- read.taf("boot/data/sag/stocks_2023.csv")
sumtab.2020 <- readRDS("boot/data/sag/sumtab_2020.rds")
sumtab.2021 <- readRDS("boot/data/sag/sumtab_2021.rds")
sumtab.2022 <- readRDS("boot/data/sag/sumtab_2022.rds")
sumtab.2023 <- readRDS("boot/data/sag/sumtab_2023.rds")
refpt.2020 <- readRDS("boot/data/sag/refpt_2020.rds")
refpt.2021 <- readRDS("boot/data/sag/refpt_2021.rds")
refpt.2022 <- readRDS("boot/data/sag/refpt_2022.rds")
refpt.2023 <- readRDS("boot/data/sag/refpt_2023.rds")

